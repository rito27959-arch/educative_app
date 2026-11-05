# AnimaScript threading

A script normally runs on the main lane: the thread that advances and draws
the artboard. Work that is too slow for a frame, or that has to keep running
between frames, can move to one of three other lanes. Each lane runs in its
own instance of the script's module, with its own memory, so lanes never
share variables. They talk by copying values to each other, or through shared
memory that every lane can reach.

The API is in [api/jobs.md](api/jobs.md), [api/workers.md](api/workers.md),
[api/audio.md](api/audio.md), [api/shared.md](api/shared.md),
[api/ports.md](api/ports.md) and [api/lanes.md](api/lanes.md).

## The lanes

| Lane | What it is | Started with | Ends when |
|---|---|---|---|
| main | the script itself: `init`, `advance`, `draw` and the other hooks | the file | the script goes |
| job | a plain function that computes a result from its arguments | `Jobs.run` | it returns, fails or is stopped |
| worker | an async function that lives across frames and keeps its state | `Worker.spawn` | its promise settles or it is stopped |
| audio processor | a class whose `process` renders audio blocks | `Audio.start` | it is stopped, fails or overruns its hard limit |

### Jobs

A job is an exported function marked `@job`. It runs on a pool thread, or,
when a call without a budget joins it before a pool thread has started it, on
the thread that joins it. Each run starts from a fresh state, with every
global back at its initial value, so a job cannot keep state from one run to
the next. A job computes exactly what the main lane would from the same
arguments, as long as it reads no global the main lane has changed, so a test
can call a `@job` function directly.

```as
import { Layout, Context } from "rive/host";
import { Jobs } from "rive/jobs";

@job export function sum(values: Float64Array): f64 {
    let total = 0.0;
    for (let i = 0; i < values.length; i++) {
        total += values[i];
    }
    return total;
}

export class Totals extends Layout {
    total: f64 = 0;

    override init(context: Context): bool {
        let values = new Float64Array(3);
        values[0] = 1;
        values[1] = 2;
        values[2] = 3;
        let result = Jobs.run(sum, values).join();
        if (result != null && result.ok) {
            this.total = result.value;
        }
        return true;
    }
}
```

The main lane waits for a job with `join`, `joinWithin`, `Jobs.joinAny` or
`peek`, or awaits `job.promise()`. A wait never outlasts the call the main
lane is in, so a frame is never held past its budget (see [Limits](#limits)).
Awaited results are copied into the main lane as they settle, a few
megabytes per poll, so a burst of large results settles over several polls.
The pacing counts bytes, not objects; [Large data](#large-data) says what
decoding them costs.

A result is decoded once: `peek`, `join` and `promise` answer the same
outcome from then on, kept until the handle is released. To poll, check
`running` and `peek` once it turns false.

An API that hands out results one at a time, such as a reader whose `next()`
says either that it has another result or that it is done, needs a third
answer once its work moves to a job: not yet, while the job is still
`running`. The caller then stops asking until the next frame instead of
calling `join`, so no frame waits for the pool.

`joinInto(out)` and `peekInto(out)` decode a result into a value the caller
already holds, so nothing is allocated. The value is a typed array, a
`StaticArray` of numbers or a class of numbers, with arrays as long as the
ones the job returns. Both answer false while the job is still running, and
once it failed or was stopped. Unlike `peek`, each call that answers true
decodes the result again.

```as
import { Layout, Context } from "rive/host";
import { Job, Jobs } from "rive/jobs";

@job export function ramp(count: i32): Float32Array {
    let values = new Float32Array(count);
    for (let i = 0; i < count; i++) {
        values[i] = <f32>i;
    }
    return values;
}

export class Ramps extends Layout {
    values: Float32Array = new Float32Array(1024);
    job: Job<Float32Array>? = null;

    override advance(seconds: f64): bool {
        let job = this.job;
        // Decodes into values, which was allocated once.
        if (job != null && job.joinInto(this.values)) {
            this.job = null;
        }
        if (this.job == null) {
            this.job = Jobs.run(ramp, this.values.length);
        }
        return true;
    }
}
```

### Workers

A worker is an exported async function marked `@worker`. It keeps its
instance and its state until it returns. Natively it runs on a thread from
the worker pool between awaits, and uses no thread at all while it awaits. A
browser keeps each worker on one thread, as
[Platform differences](#platform-differences) says. A worker waits on
signals, ports and `Worker.sleep`, and the host resumes it when one fires.

Lanes cannot deadlock, which would mean threads each blocked waiting for
another. A worker waits for signals, ports and sleeps only by awaiting, which
blocks no thread, and a region lock it takes waits at most two seconds. No
lane can wait while it holds a region lock, and every wait that blocks the
main lane gives up within the call's budget. A call without a budget is the
exception: there a join waits for its job to end, so a job that loops until
the main lane acts hangs both. A worker can stall, though: one that awaits an
event that never comes, such as a notify the other workers at a barrier never
send, waits until it is stopped. Nothing detects a stall, but a headless run
in rive-cli ends by naming every worker still waiting, as
[Captures](#captures) says.

Spawn a worker per service rather than per core. Natively a worker holds no
thread while it awaits, and a step that runs past 20 ms gets a thread of its
own, so for workers whose steps run long the size of the worker pool says
little about how many run at once. Workers whose steps are shorter run at
once only up to the pool's size, which [Limits](#limits) gives. Independent
pieces of work spread over the cores belong in jobs, and `Jobs.threads()`
says how many of those run at once. Jobs cannot meet between steps, though,
so the parts of one computation that keep large state from step to step, or
must meet between steps, go to workers that meet at a barrier, as
[Splitting one computation](#splitting-one-computation) shows. Workers that
share one request port, to keep state from one request to the next, gain
little past `Jobs.threads()` of them. Where `Jobs.threads()` is 0 there are
no threads, and workers step between frames.

```as
import { Layout, Context } from "rive/host";
import { Worker } from "rive/workers";
import { Port } from "rive/ports";

@worker export async function doubler(requests: Port<f64>, replies: Port<f64>): Promise<void> {
    while (true) {
        let request = await requests.receive();
        if (request == null) {
            return;
        }
        replies.post(request.value * 2);
    }
}

export class Doubling extends Layout {
    requests: Port<f64> = Port.create<f64>();
    replies: Port<f64> = Port.create<f64>();
    worker: Worker? = null;
    latest: f64 = 0;

    override init(context: Context): bool {
        this.worker = Worker.spawn(doubler, this.requests, this.replies);
        this.requests.post(21);
        return true;
    }

    override advance(seconds: f64): bool {
        let self = this;
        this.replies.drain((value: f64): void => {
            self.latest = value;
        });
        return true;
    }
}
```

On the main lane, a port's `drainFor(handler, seconds)` drains as `drain`
does but stops once the seconds pass. It checks the time after each message,
so it hands at least one when any is queued, and it never waits for one.

`Promise` needs no import, as in TypeScript; `Settled` and the rest of
`rive/promise` still do.

`stop()` asks a worker to end: its awaits settle with `kWaitStopping` (the
wait codes import from `rive/lane_codes`) and `Lanes.stopping()`, from
`rive/lanes`, turns true.

The main lane can also wait for a worker's answer inside the call that
asked. `Port.receiveWithin(seconds)` waits for a message, and
`Signal.waitWithin(after, seconds)` waits for a notify. They block as a join
does, never past the call's budget, and they throw inside
`SharedRegion.exclusive`. Without a budget they wait at most two seconds,
where a join waits for its job to end. Only the main lane may block this way;
a worker awaits instead.

```as
import { Layout, Context } from "rive/host";
import { Worker } from "rive/workers";
import { Port } from "rive/ports";

@worker export async function halver(requests: Port<f64>, replies: Port<f64>): Promise<void> {
    while (true) {
        let request = await requests.receive();
        if (request == null) {
            return;
        }
        replies.post(request.value / 2);
    }
}

export class Halving extends Layout {
    requests: Port<f64> = Port.create<f64>();
    replies: Port<f64> = Port.create<f64>();
    worker: Worker? = null;
    latest: f64 = 0;

    override init(context: Context): bool {
        this.worker = Worker.spawn(halver, this.requests, this.replies);
        return true;
    }

    override advance(seconds: f64): bool {
        this.requests.post(42);
        // The answer to this frame's request, or null after 4 ms.
        let reply = this.replies.receiveWithin(0.004);
        if (reply != null) {
            this.latest = reply.value;
        }
        return true;
    }
}
```

#### Splitting one computation

One computation can be split over workers that meet between its steps, such
as a model whose layers each normalize over the data that all of the workers
hold. They meet at a `Barrier` from `rive/shared`, which crosses to them
through `Worker.spawn`. `Barrier.create(maxParticipants, shareFloats)` makes
one for rounds of up to that many participants, each bringing a share of up
to that many `f32` values. In each round, every participant awaits one of
these:

- `arrive(round, participants)` only meets.
- `sum`, `min` or `max(round, participants, index, share, out)` also
  combines the participants' shares. The last to arrive combines them in
  index order, so `out` holds the same bits in every participant. `out` may
  be the share itself.

The caller numbers the rounds from 0 with no gaps, over every use of the
barrier, and passes each round's participant count, so the count can change
from round to round. The participants of a round pass the same count, each
its own index from 0 to the count less one, and all call the same method
with shares of the same length. A worker that sits rounds out calls the next
round it takes part in, and that call waits until the rounds before it are
over.

```as
import { Layout, Context } from "rive/host";
import { Worker } from "rive/workers";
import { Port } from "rive/ports";
import { Barrier } from "rive/shared";

const kWorkers: i32 = 4;
const kSteps: i32 = 8;
const kSlice: i32 = 1024;

// Short chunks are split over two parts, long ones over all four.
function parts(chunk: i32): i32 {
    return chunk % 3 == 2 ? kWorkers : 2;
}

@worker export async function part(index: i32, chunks: i32, barrier: Barrier, done: Port<f32>): Promise<void> {
    // This part's slice of the chunk, kept from step to step.
    let values = new Float32Array(kSlice);
    let moments = new Float32Array(2);
    for (let chunk = 0; chunk < chunks; chunk++) {
        let count = parts(chunk);
        if (index >= count) {
            continue;
        }
        for (let i = 0; i < kSlice; i++) {
            values[i] = <f32>((chunk + index * kSlice + i) % 13);
        }
        for (let step = 0; step < kSteps; step++) {
            moments[0] = 0;
            moments[1] = 0;
            for (let i = 0; i < kSlice; i++) {
                moments[0] += values[i];
                moments[1] += values[i] * values[i];
            }
            // Rounds count on over every chunk, and moments then holds the
            // totals over every part.
            let met = await barrier.sum(chunk * kSteps + step, count, index, moments, moments);
            if (!met) {
                return;
            }
            let n = <f32>(count * kSlice);
            let mean = moments[0] / n;
            let deviation = Mathf.sqrt(max<f32>(moments[1] / n - mean * mean, 1e-6));
            for (let i = 0; i < kSlice; i++) {
                values[i] = (values[i] - mean) / deviation;
            }
        }
    }
    done.post(values[0]);
}

export class Normalize extends Layout {
    barrier: Barrier = Barrier.create(kWorkers, 2);
    done: Port<f32> = Port.create<f32>();
    workers: Array<Worker> = new Array<Worker>();
    first: f32 = 0;

    override init(context: Context): bool {
        for (let i = 0; i < kWorkers; i++) {
            this.workers.push(Worker.spawn(part, i, 6, this.barrier, this.done));
        }
        return true;
    }

    override advance(seconds: f64): bool {
        for (let i = 0; i < this.workers.length; i++) {
            // The other parts would wait for a failed one forever.
            if (this.workers[i].failed != null) {
                this.barrier.break();
            }
        }
        let self = this;
        this.done.drain((value: f32): void => {
            self.first = value;
        });
        return true;
    }
}
```

A call settles false once the barrier is broken or released, and inside a
worker being stopped. A participant that fails or is stopped, or whose call
is cancelled, leaves the others waiting for it. A call is cancelled, for
example, when it is one of the promises given to `Promise.all` and another of
them rejects. So stop every participant together, or call `break()`, which
settles every wait on the barrier false, and every call from then on.

A round ends only when its slowest part arrives, so give the parts equal
work, and split the computation into no more parts than can run at once.
Natively that is the worker pool's size: one thread fewer than the device has
cores, and at most 4, unless the host sizes it otherwise, as rive-cli's
`--worker-threads` does. Parts that meet more often than every 20 ms never
get a thread of their own, so a part past the pool's size waits for a thread
every round, and a round then takes at least twice as long as one part's
work. In a browser with threads each worker keeps a thread of its own, up to
about 8, as [Platform differences](#platform-differences) says.

A round also costs a few hundredths of a millisecond, mostly to wake the
parts that wait for it. Natively on an Apple M4 Pro, on a pool of 8 threads
and with a fifth of a millisecond of work in each part between rounds,
meeting costs about 0.02 ms a round with 2 or 4 parts and 0.04 ms with 8, and
a sum of 1024 values from each part about 0.02, 0.03 and 0.06 ms. With much
less work between rounds a round costs up to twice that, since a part that
reaches the next round first waits there for the others to leave the last
one.

A barrier built by hand from a region and a signal is easy to get wrong in
two ways, both of which `Barrier` avoids:

- An arrival counted toward the wrong round. When the participant count
  changes, a worker that sat rounds out can arrive at a later round while an
  earlier one is still open, so that round ends early or waits forever.
  `Barrier` holds each arrival until the rounds before it are over.
- A share overwritten before a slower worker has read it. A worker that
  leaves a round early can write its next share while another still reads
  the last one. `Barrier` opens the next round only once every participant
  has copied the last round's result, so one set of shares is enough.

### Audio processors

An audio processor is a class extending `AudioProcessor<A>`, exported under
its own name.
`Audio.start` builds one in its own instance and mixes what its `process`
writes into the audio output. `process` runs on the audio thread, which plays
every sound, so it must never wait and should never allocate: read rings with
`receiveInto` and snapshots with `latestInto`, into values made in `init`.

```as
import { Layout, Context } from "rive/host";
import { Audio, AudioHandle, AudioProcessor } from "rive/audio";
import { Snapshot } from "rive/shared";

export class Level {
    gain: f64 = 0.1;
}

export class Hum extends AudioProcessor<Snapshot<Level>> {
    level: Snapshot<Level>? = null;
    current: Level = new Level();
    channels: i32 = 2;
    phase: f64 = 0;
    step: f64 = 0;

    override init(sampleRate: f64, maxFrames: i32, channels: i32, level: Snapshot<Level>): void {
        this.level = level;
        this.channels = channels;
        this.step = 2 * Math.PI * 110 / sampleRate;
    }

    override process(out: StaticArray<f32>, frames: i32, startFrame: f64): void {
        this.level!.latestInto(this.current);
        let channels = this.channels;
        for (let i = 0; i < frames; i++) {
            let sample = <f32>(Math.sin(this.phase) * this.current.gain);
            for (let c = 0; c < channels; c++) {
                out[i * channels + c] = sample;
            }
            this.phase += this.step;
        }
    }
}

export class Humming extends Layout {
    level: Snapshot<Level> = Snapshot.create<Level>();
    hum: AudioHandle? = null;

    override init(context: Context): bool {
        this.level.publish(new Level());
        this.hum = Audio.start(() => new Hum(), this.level);
        return true;
    }
}
```

`rive <dir> --render-audio` runs the project with no window and no audio
device and writes what its processors render as a float wav, for as long as
the `--advance` steps add up to. The same run always writes the same file, so
a processor can be checked against a reference:

```sh
rive . --render-audio=out.wav --advance=5s
```

`--audio-rate=<Hz>` and `--audio-channels=<N>` pick the format, 48000 Hz and
2 channels by default. Sounds played from audio assets are not in the file.
`Audio.timeFrame`, `Audio.time` and `Audio.sampleRate` follow the capture
instead of a device, which is the same clock a processor's `startFrame`
reads, so a note the main lane stamps with a frame from `Audio.timeFrame`
plays on that frame. A render has all the time it wants, so no block is ever
dropped for running long.

#### When a processor fails

A throw, a trap or a block past the hard limit ends a processor for good. It
leaves the mix and plays silence from then on, and the log says so once,
naming its class, as in `processor Chorus failed: integer overflow`. A
worker that fails is named the same way, by its function. `failed` on the
handle says why: the message a throw carried, or for a trap a text from the
engine, which differs between hosts. A float cast out of range traps as
`integer overflow` natively, as `float unrepresentable in integer range` in
Chrome and as `Out of bounds Trunc operation` in Safari, so check whether
`failed` is null rather than matching its text.

To keep playing, check `failed` in `advance` and call `Audio.start` again,
which makes a new processor and runs its `init` from scratch. A cause that
lasts, such as a bad value in a snapshot, fails each new processor on its
first block, and every start logs another failure line, so restart only a
few times.

```as
import { Layout, Context } from "rive/host";
import { Audio, AudioHandle, AudioProcessor } from "rive/audio";

export class Tone extends AudioProcessor<f64> {
    channels: i32 = 2;
    phase: f64 = 0;
    step: f64 = 0;

    override init(sampleRate: f64, maxFrames: i32, channels: i32, pitch: f64): void {
        this.channels = channels;
        this.step = 2 * Math.PI * pitch / sampleRate;
    }

    override process(out: StaticArray<f32>, frames: i32, startFrame: f64): void {
        let channels = this.channels;
        for (let i = 0; i < frames; i++) {
            let sample = <f32>(Math.sin(this.phase) * 0.1);
            for (let c = 0; c < channels; c++) {
                out[i * channels + c] = sample;
            }
            this.phase += this.step;
        }
    }
}

export class Player extends Layout {
    tone: AudioHandle? = null;
    restarts: i32 = 0;

    override init(context: Context): bool {
        this.tone = Audio.start(() => new Tone(), 220.0);
        return true;
    }

    override advance(seconds: f64): bool {
        let tone = this.tone!;
        let failed = tone.failed;
        if (failed != null && this.restarts < 3) {
            console.warn("tone failed, restarting: " + failed);
            this.restarts++;
            tone.release();
            this.tone = Audio.start(() => new Tone(), 220.0);
        }
        return true;
    }
}
```

#### Writing a real instrument

A processor that does real work needs compiled code. The log names the tier
each lane module runs on, such as `processors module tier: interp`. On the
interpreter DSP runs many times slower and soon overruns its blocks, which
silences it; pass `--aot` or set `RIVE_WAMRC` to compile it. As a measure, a
physical model piano holding a ten note chord takes about 3 percent of a core
compiled and about half a core interpreted, without fuel. Lane modules are
optimized in every build, but a debug bake also gives every lane fuel, the
checks that let a browser end a lane, as
[Platform differences](#platform-differences) says, while `--optimize` gives
lanes fuel only when the file sets `wasmFuel`. Fuel makes a processor's
blocks about a fifth to a third slower, compiled or interpreted.

- Mark the hot functions `@unchecked`, and give the inner loops a `v128`
  path. Guard it with `ASC_FEATURE_SIMD` and keep a scalar path beside it
  that sums in the same order, so both render the same samples.
- Our compiler has only part of wasm SIMD: `v128` loads, stores, bitwise
  operations, shuffles and `any_true`; splats and lane reads and writes on
  `f32x4` and `i32x4`; arithmetic, comparisons, `min`, `max`, `pmin`,
  `pmax` and `sqrt` on `f32x4`; and `add`, `sub`, `mul`, `eq`, `ne`,
  `all_true` and `bitmask` on `i32x4`. It has no shifts, no rounding, no
  conversions between float and integer lanes, no `lt`, `gt`, `le` or `ge`
  on `i32x4`, no loads that splat or widen, and no `f64x2` or `i64x2`. On
  `i16x8` it has only shuffles, and on `i8x16` only shuffles and swizzles.
- A processor renders the same samples on every native tier and in the
  audio worklets of Chrome, Firefox and WebKit, the engine of Safari, with
  SIMD or without, which makes a rendered file a dependable reference for a
  test. One that calls the fused multiply-adds that `wasmSimd: relaxed`
  allows is the exception: they can round differently by platform, and
  natively it then runs only compiled; see `wasmSimd` in
  [../project/rive-yaml.md](../project/rive-yaml.md).
- A cast from a float to an integer, such as `<u32>x`, traps when `x` is
  NaN or out of range, and the trap fails the processor. A cast to an 8 or
  16 bit type checks the range of the 32 bit type of the same sign, then
  wraps, so `<u16>x` still traps when `x` is -1 or less. A delay line is the
  usual case, since its read position, the write position less the delay,
  goes negative. For a line whose length is a power of two,
  `<i32>Mathf.floor(pos) & (length - 1)` wraps a negative position instead,
  though a NaN or infinite delay still traps. Bring such values into range
  with a comparison before the cast, since `min` and `max` pass a NaN
  through.
- A raw pointer is good for one call only. Objects may move between calls, so
  take `changetype<usize>(array)` at the top of `process` and never keep it
  in a field.
- The block size is the host's. `frames` changes from call to call, up to the
  `maxFrames` that `init` was given. A core that wants fixed blocks renders
  whole blocks of its own and hands out what each call asks for.
- The sample rate is the output's, usually the device's own. Most devices run
  at 44100 or 48000 Hz, but a headset during a call can drop to 8000 and an
  audio interface can run at 192000. Read it from `init`'s `sampleRate`, or
  natively from `Audio.sampleRate()` on the main lane, rather than assuming one.
- A heavy processor on a loaded machine wants a bigger device buffer, at the
  cost of latency: `rive <dir> --audio-buffer=2048`, or `audioBuffer: 2048` in
  `rive.yaml`. Events stamped against `Audio.timeFrame` then need to be sent
  more than a buffer ahead.
- Make everything in the constructor or in `init`, and nothing in `process`.
- Pass large data, such as a sample bank or a model, as a shared `Blob` from
  `rive/shared`. It crosses by id, where an `ArrayBuffer` in the start
  argument is copied. A blob asset is not one yet, and
  [Large data](#large-data) says how to load a large one.

Wasm has no instructions for sines, exponentials or logarithms, so
`Mathf.sin`, `exp`, `log`, `pow` and `tanh`, and their `Math` versions, run
full precision code inside the module. Compiled, `Mathf.sin` takes about 3 ns
on an Apple M4 Pro and `pow` and `tanh` about twice that; on the interpreter
each takes about 15 to 20 times as long. One call per sample costs little,
but a bank of voices, or a curve worked out for every sample, adds up. Keep
oscillator phases in turns and use a polynomial such as the one below, work
out smoothing coefficients when a knob changes rather than on every block,
and skip a compressor's `log` and `pow` while the signal stays under its
threshold. `Mathf.sqrt`, `abs`, `floor`, `min` and `max`, by contrast, are
single instructions.

<!-- as:file dsp.as -->
```as
// A sine of a phase in turns, where 1 is a whole cycle, within 7.4e-7 of
// Math.sin for about a quarter of what Mathf.sin costs compiled.
export function sinTurn(turns: f32): f32 {
    let x = turns - floor<f32>(turns + 0.5);
    let a = abs<f32>(x);
    x = copysign<f32>(min<f32>(a, 0.5 - a), x);
    let x2 = x * x;
    return x * (6.28316402 + x2 * (-41.3371429 + x2 * (81.3407669 + x2 * -70.9933929)));
}
```

A processor that is silent most of the time, such as an instrument between
notes, still has `process` called for every block, and runs its whole loop
unless it puts itself to sleep:

- While asleep, return from `process` at once. `out` arrives zeroed, so the
  block plays silence.
- Wake when the ring has records, which its `used` shows without taking
  them, or when the snapshot's `seq` has moved and its values differ from the
  ones in use. `seq` moves on every publish, even of the same values, so a
  main lane that publishes every frame would otherwise wake the processor
  after each publish. If the main lane publishes only when a knob changes, a
  moved `seq` is enough.
- Go to sleep once the tail is too quiet to hear.
- Publish meters as zero before going to sleep, or the main lane keeps
  showing the last level.
- `process` is still called while the processor sleeps, with the right
  `startFrame`, so a processor that keeps its own clock, such as a
  sequencer, takes its time from `startFrame` and wakes when its next event
  is due.

Asleep, a block reads `used` and `seq`, and decodes the knobs to compare them
only after a publish, so it costs close to what an empty processor does.

```as
import { Layout, Context } from "rive/host";
import { Audio, AudioHandle, AudioProcessor } from "rive/audio";
import { Ring, Snapshot } from "rive/shared";
import { sinTurn } from "./dsp";

export class Note {
    gain: f32 = 0;
}

export class Knobs {
    decay: f32 = 0.9998;
}

export class Meter {
    level: f32 = 0;
}

export class Inputs {
    notes: Ring<Note> = Ring.create<Note>(256);
    knobs: Snapshot<Knobs> = Snapshot.create<Knobs>();
    meter: Snapshot<Meter> = Snapshot.create<Meter>();
}

export class Pluck extends AudioProcessor<Inputs> {
    inputs: Inputs? = null;
    note: Note = new Note();
    knobs: Knobs = new Knobs();
    next: Knobs = new Knobs();
    meter: Meter = new Meter();
    knobsSeq: f64 = -1;
    asleep: bool = false;
    level: f32 = 0;
    phase: f32 = 0;
    step: f32 = 0;
    channels: i32 = 2;

    override init(sampleRate: f64, maxFrames: i32, channels: i32, inputs: Inputs): void {
        this.inputs = inputs;
        this.channels = channels;
        this.step = <f32>(220 / sampleRate);
    }

    woken(inputs: Inputs): bool {
        if (inputs.notes.used != 0) {
            return true;
        }
        let seq = inputs.knobs.seq;
        if (seq == this.knobsSeq) {
            return false;
        }
        this.knobsSeq = seq;
        inputs.knobs.latestInto(this.next);
        return this.next.decay != this.knobs.decay;
    }

    override process(out: StaticArray<f32>, frames: i32, startFrame: f64): void {
        let inputs = this.inputs!;
        if (this.asleep && !this.woken(inputs)) {
            return;
        }
        this.asleep = false;
        inputs.knobs.latestInto(this.knobs);
        while (inputs.notes.receiveInto(this.note)) {
            this.level = this.note.gain;
        }
        let channels = this.channels;
        for (let i = 0; i < frames; i++) {
            let sample = sinTurn(this.phase) * this.level;
            for (let c = 0; c < channels; c++) {
                out[i * channels + c] = sample;
            }
            this.phase += this.step;
            this.phase -= floor<f32>(this.phase);
            this.level *= this.knobs.decay;
        }
        this.asleep = this.level < 1e-5;
        this.meter.level = this.asleep ? 0 : this.level;
        inputs.meter.publish(this.meter);
    }
}

export class Plucking extends Layout {
    inputs: Inputs = new Inputs();
    knobs: Knobs = new Knobs();
    pluck: AudioHandle? = null;
    level: f32 = 0;
    frame: i32 = 0;

    override init(context: Context): bool {
        this.pluck = Audio.start(() => new Pluck(), this.inputs);
        return true;
    }

    override advance(seconds: f64): bool {
        // Published every frame, as a tuning panel might.
        this.inputs.knobs.publish(this.knobs);
        this.frame++;
        if (this.frame % 200 == 2) {
            let note = new Note();
            note.gain = 0.3;
            this.inputs.notes.send(note);
        }
        let meter = this.inputs.meter.latest();
        if (meter != null) {
            this.level = meter.value.level;
        }
        return true;
    }
}
```

## What each lane can reach

A lane module is compiled from the same files as the main module, but only
the code the lane's function or class reaches goes into it, and none of the
files' top level code runs there. A global the lane reads keeps its
initializer, so give state its value where it is declared. A top level
statement that changes such a global fails the build, in any script, whether
or not the script holds lane code. So does an initializer that changes one
when the lane never reads the global or static field it initializes, as the
main module runs it at start, or for a `@lazy` global once its code reads it.
The check follows the calls that code makes: into functions, methods,
constructors and field initializers, default arguments, getters and setters,
operators, and through a base class or an interface into every override, as
well as into a callback it passes straight to a call that runs it. It also
follows the global's object when code reaches it another way: through a cast,
`!`, a comma or either side of `?:`, a cascade, a local or another global set
from it, a loop over an array that holds it, a `ref` parameter, or a view over
its buffer. A standard library method counts as a change unless it only reads,
like `includes` or `slice`. When a function that code calls makes the change,
the error names it. A change made through an object a function returns gets
past the check, and so does one made through a function value, such as a
callback kept in a variable or an array and called later, or inside your code
that the standard library calls on its own, such as a map key's `hash`.

| Lane | Can reach |
|---|---|
| main | everything: the host, the artboard, other lanes |
| job | its arguments, shared memory, pure std code, and console logs and timers |
| worker | the same as a job, plus awaits on signals, ports and sleeps |
| audio processor | its argument, shared memory without locks, pure std code and console logs, but no timers |

No lane but the main one reaches the host: no paths, paints, artboards, view
models, randomness or clocks, and no other lanes. A lane that would reach one
fails the build at the call that reaches it, naming the chain of functions
from the lane's function to that call.

A lane's console lines show where the main lane's do, but not at once. They
are handed over at the host's next poll, which runtimes make before each
advance, or sooner when the main lane joins the lane, releases it, or reads
its state once it is over, as `running` and `peek` do. `rive <dir> --test`
hands them over as each case ends, so a line a lane writes after its case has
ended prints after a later case, or not at all after the last one. A line
longer than 1024 bytes is cut. Between two handovers a worker keeps about
64 KB of lines and a job or an audio processor about 8 KB; a lane that writes
more loses the rest, and the next handover says how many lines it dropped.

What each lane may create:

| Lane | May create |
|---|---|
| main | any shared object, and start jobs, workers and processors |
| job | blobs only, such as a large result |
| worker | any shared object; it belongs to the script that spawned the worker |
| audio processor | nothing |

## What crosses between lanes

The arguments of `Jobs.run`, `Worker.spawn` and `Audio.start`, a job's result,
a worker's resolved value, and every message through a ring, snapshot or port
cross as deep copies. These types can cross:

- numbers, bools and strings
- `ArrayBuffer`, typed arrays, `Array` and `StaticArray` of crossing types
- your own classes whose fields all cross, field by field
- the shared memory handles below, which cross as the id of the same object
  rather than a copy

Your own classes need no decorator. An object crosses as the class its type
names, so sending a subclass where its base is declared throws; send it as its
own type. Functions, host objects and values nested too deep cannot cross,
and the build says which field is at fault.

The decorators:

- `@job` marks a function `Jobs.run` may run. It must be exported under its
  own name, not generic, not a generator, and return a value.
- `@worker` marks an async function `Worker.spawn` may spawn. It must be
  exported under its own name and not a generator.
- `@sendable` marks the std types that cross by id, such as `Ring`, `Blob`
  and `Port`. You do not write it on your own classes.

## Shared memory

Shared objects live outside every lane's memory, in the host, and each lane
reaches them by id. None of them ever makes a lane wait, except a region's
lock, which audio processors cannot take, and the two bounded waits only
the main lane has.

| Type | What it holds | Who waits |
|---|---|---|
| `Blob` | bytes fixed once made | nobody |
| `SharedRegion` | bytes behind one lock, plus atomic words | a lane taking the lock |
| `Ring<T>` | values in arrival order, up to a byte capacity (4096 by default) | nobody: a full ring refuses the send |
| `Snapshot<T>` | the latest value, up to a byte capacity (1024 by default) | nobody |
| `Signal` | a counter that wakes awaits when it is notified | an await, or the main lane in `waitWithin` |
| `Port<T>` | typed messages over a ring, with awaits for a message or for room | an await, or the main lane in `receiveWithin` |
| `Barrier` | the rounds where workers splitting one computation meet, with a share of floats from each | an await, until the round's last participant arrives |

A lane holds at most one region's lock at a time, and can neither join a
job nor block on a signal while it holds one, so locks can never deadlock. A shared object holds at most
256 MB. Each handle on the main lane keeps its object alive until the handle
is collected or released; a value in flight through a ring or snapshot keeps
what it names alive until it is read or replaced.

A ring or port takes its byte capacity from the file's shared memory when it
is made, and a snapshot twice its capacity, since it keeps two copies, so a
snapshot's capacity is at most 128 MB. A value counts its encoded size
against the capacity. Today that is its encoded bytes, plus 4 for each shared
object it names and 4 more when it names any, and in a ring or port 4 more for
its length, so an `f64` needs a ring of 12 bytes. The encoding belongs to the
bake that made the file, and a later bake may size values differently, so
leave a capacity some room rather than sizing it to the byte. A value that
needs more than the capacity never fits: a ring's `send` answers false, a
snapshot keeps its last value, a port's `post` throws, and the console warns
the first time it happens, except on an audio processor. Send such data as a
blob instead, as [Large data](#large-data) shows.

A blob, or a region under its lock, moves bytes in and out by range, so
nothing needs a slice or a staging buffer first:

- `Blob.from(buffer, byteOffset, byteLength)` copies part of a buffer. The
  length defaults to the rest of the buffer.
- `Blob.fromArray(values, offset, count)` copies part of a typed array, or of
  an `Array` or `StaticArray` of numbers, counted in values, so what a job
  builds becomes a blob in one copy, or two on the web, which stages the
  bytes first.
- `blob.readInto(srcOffset, out, dstOffset, count)` copies into part of `out`,
  which is an `ArrayBuffer` or one of the arrays `Blob.fromArray` takes, and
  answers how much it copied, fewer where the blob ends first. `srcOffset`
  counts bytes in the blob, while `dstOffset`, the count and the answer count
  bytes in a buffer and values in an array. The count defaults to the rest of
  `out`.
- `view.readInto(offset, out, dstOffset, count)` and
  `view.writeFrom(offset, values, srcOffset, count)` copy between a region
  and the same buffers and arrays. `offset` counts bytes in the region, while
  the other offset and the count count bytes in a buffer and values in an
  array. The copies allocate nothing, though each `exclusive` still makes its
  view.
- `buffer.updateFromBlob(dstOffset, blob, byteCount, srcOffset)` uploads a
  blob's bytes to a `GPUBuffer`. The host copies them straight from shared
  memory, so they never pass through the script's own memory, and the blob
  may be released as soon as the call returns.
- `GPUBuffer.fromBlob(usage, blob, immutable, byteCount, srcOffset)` makes a
  buffer from a blob's bytes the same way, so a mesh that never changes can
  be an `immutable` buffer. Updating a mutable buffer while a draw still
  uses it is safe, since that draw keeps the bytes it was given.

```as
import { Layout, Context } from "rive/host";
import { GPUBuffer } from "rive/gpu";
import { BufferUsage } from "rive/gpu_enums";
import { Job, Jobs } from "rive/jobs";
import { Blob } from "rive/shared";

const kVertexBytes: i32 = 4096;

@job export function skin(pose: Float32Array): Blob {
    // Sized for the worst case; only what was written is sent.
    let vertices = new Float32Array(2 * kVertexBytes / 4);
    for (let i = 0; i < kVertexBytes / 4; i++) {
        vertices[i] = pose[i % pose.length];
    }
    return Blob.from(vertices.buffer, 0, kVertexBytes);
}

export class Skinned extends Layout {
    vertices: GPUBuffer? = null;
    skinning: Job<Blob>? = null;

    override init(context: Context): bool {
        this.vertices = new GPUBuffer(BufferUsage.vertex, <u32>kVertexBytes);
        this.skinning = Jobs.run(skin, new Float32Array(16));
        return true;
    }

    override advance(seconds: f64): bool {
        let skinning = this.skinning;
        if (skinning != null && !skinning.running) {
            this.skinning = null;
            let skinned = skinning.peek()!.value;
            skinning.release();
            this.vertices!.updateFromBlob(0, skinned);
            skinned.release();
        }
        return true;
    }
}
```

## What a job costs

A job pays for its start, for copying its arguments in and its result out,
and for the wait if it finishes after the main lane needs it. On a desktop,
natively, an empty job run and joined costs about a hundredth of a
millisecond, and a megabyte crossing in or out about a few tenths. In a
browser each is a few times more. The main lane encodes the arguments inside
`Jobs.run` and decodes the result inside the call that reads it, so those
copies cost its frame; [Large data](#large-data) says how much, and how to
avoid them.

So a job that runs every frame pays off when its work is clearly larger than
what crosses. Half a millisecond of work that returns two megabytes is slower
on a job than on the main lane, while several milliseconds of work returning
the same amount gains. Two habits make the most of one:

- start it early and join it late: start the job as soon as its inputs are
  ready, do the frame's other work, and join just before the result is used
- send less: pass shared memory or a `Blob` rather than large arrays, and
  decode into a value you keep with `joinInto`

What crosses cheaply:

- a typed array, an `Array` of numbers or a `StaticArray` of numbers crosses
  as one block of bytes, never copied element by element, though a
  `StaticArray` always sends its whole length (see [Large data](#large-data))
- a `subarray` view sends only its own bytes, which splits work across jobs
  without copying the whole array
- a `Blob` crosses by id with no copy, and a job that returns one skips the
  copy into the main lane; read it in place with `readInto` or hand it to
  `updateFromBlob`

Keep a `Job`, `Worker` or processor handle in a field for as long as the lane
should run. A handle that is collected stops its lane, as releasing it does.

## Large data

A value that crosses is copied by the lanes at both ends. The lane that sends
it encodes it inside the call that sends it: `Jobs.run`, `Worker.spawn` and
`Audio.start` for their arguments, and `post`, `send` and `publish` for a
message. The lane that reads it decodes it inside the call that reads it:

- a job's or worker's result in the first `peek`, `join` or `joinWithin`
  that finds the lane over, or for `promise()` at the host's next poll, which
  runtimes make before each advance
- the same result again in every `joinInto` or `peekInto` that answers true
- a message in the `receive`, `drain`, `latest` or other read that takes it

So a large result costs the frame that reads it. Numbers are copied as
blocks, but every other object is made on its own:

- a typed array, or an `Array` or `StaticArray` of numbers, is one block:
  4 MB decodes in under half a millisecond
- every object, string and nested array is made one at a time: 350,000
  objects of three numbers take about 4 ms to decode compiled and about 25 ms
  interpreted
- awaited results are paced by bytes, not objects, so a few megabytes of
  small objects can still cost several milliseconds in one poll
- the first large result also grows the memory of the lane that reads it,
  which costs several times more, once
- what the main lane keeps of a result made of many objects is moved by the
  collector at the next frame, which can cost more than the decode itself

Encoding works the same way, so a large argument or message made of many
objects also costs the lane that sends it.

A `Blob` crosses by id whatever its size, so reading one decodes nothing.
For large data:

- make the blob where the data is computed, in a job or a worker: build the
  numbers in a typed array, an `Array` or a `StaticArray`, then return or
  send `Blob.fromArray(values)`, which copies them once, or twice on the web
- hand a fetched body to a job as the `Blob` that `response.blob()` resolves
  with, awaited into a local first since an await cannot sit inside a call's
  arguments, rather than as an `ArrayBuffer` from `arrayBuffer()`, which
  first copies it into the lane
- publish data that every job reads, such as a style, once to a `Snapshot`
  large enough for it, and pass the snapshot, whose handle crosses by id;
  each job then decodes the data on its own thread
- read a blob without decoding it: `updateFromBlob` and `GPUBuffer.fromBlob`
  upload its bytes straight from shared memory, as the skinning example under
  [Shared memory](#shared-memory) does, and `readInto` copies just the range
  you need into a buffer you keep

A blob asset reaches the lanes through the main lane, since only the main
lane reaches the host. `context.blob(name)` copies the asset's bytes into the
main lane's memory, and `Blob.from` copies them again into shared memory. The
main lane's memory never shrinks, and a buffer it drops during a call is
reclaimed only at the next frame, so a large asset loaded whole leaves the
main lane that much bigger for good. Until the host can make a blob straight
from an asset, split a large asset into several blob assets and load one per
advance with `context.blob` and `Blob.from`, so the main lane grows by about
one part, and release each `Blob` once the workers that read it have
unpacked it.

An `Array` sends its length and a typed array view only its own bytes, but a
`StaticArray` always sends its whole length, so one kept as a buffer with a
count of its own sends its capacity. Keep such a buffer as a typed array and
send `subarray(0, count)`, push into an `Array` instead, or for a large result
hand over `Blob.fromArray(buffer, 0, count)`.

Since a ring, snapshot or port holds only what fits its byte capacity, keep
messages small and send large data, such as a tile's geometry, as a blob the
message names. Post the message and release your own handle on the blob:
the message holds the blob until it is read, and the reader then holds it
until it releases it. A worker holds what it made until it releases it or
is gone, so a long lived worker releases each blob once it has posted it. A
large message also leaves the lane that sent or read it holding a buffer of
that size.

## Limits

The host that plays a file sets its limits, and content cannot change them:

- each call the host makes into the main lane, `init`, `advance`, `draw` and
  the rest, has a budget, 200 ms by default
- an audio processor has a hard limit in blocks of audio, 2 by default; a
  block past it takes that processor out of the mix, and a limit of 0 turns
  it off
- a file and its lanes hold at most 512 MB of shared memory at once by
  default, and at most 65536 live shared objects

Natively the job pool and the worker pool size themselves to the device: one
thread fewer than it has cores, at most 6 for jobs and 4 for workers. In a
browser with threads the job pool sizes itself the same way, and workers get
threads as [Platform differences](#platform-differences) says. rive-cli takes
`--job-threads=<N>` and `--worker-threads=<N>` to run a project on pools of
another size.

A file's top level code runs once, when the file loads, and it is bounded
like any call into the main lane. It has the same budget, and code that runs
past it fails the file. A join or wait there gives up when the budget runs
out, as it does in `init`, and a join then answers null while its job keeps
running. So start lanes at the top level if you like, and read their results
in `init` or later.

Jobs and workers have no time limit. A job runs until it returns or is
stopped, and a worker until its promise settles or it is stopped. The one
exception is a browser build without threads, which runs every job and steps
every worker on the page's own thread: there a job run or a worker step that
has fuel fails once it passes the main lane's call budget, as a call into the
main lane does, so it cannot freeze the page. `stop()` on a job or worker
handle always works natively, and in a browser wherever the lane has fuel, as
[Platform differences](#platform-differences) says. On a processor handle it
takes the processor out of the mix once its current block returns, fuel or
not. Releasing the handle stops the lane too.

A join never waits past the main lane's budget. It answers null while the
job is still running, and the job keeps running on the pool. Only a call
without a budget runs a job no thread has started on its own thread, to its
end.

A join or wait gives up about 20 ms before the budget ends, so the script
has time to act on the answer. One begun inside those last 20 ms only tries,
and a region lock begun there waits at most half of what the call has left.
So a loop that keeps retrying a join, a wait or a lock still runs out of the
budget, and fails the call.

## Captures

Jobs and workers run on wall time, while a headless capture steps its frames
as fast as the machine allows. Left alone, a job's result would land at a
different frame on every run. So rive-cli's `--screenshot`, `--semantics`,
`--data-dump` and `--render-audio` wait, after the load and after every frame,
until each job the scripts started has finished, their workers are idle and
their audio processors have started. What a frame starts is then always there
in the next one. `--render-audio` pulls a frame's audio only once its lanes
have settled, then waits again for any workers its processors woke while they
rendered, so what those workers send also lands in the next frame.

The capture counts the workers as idle when none of them is running a step
and none has a wait that has fired. A wait fires when its signal is notified
or its timeout passes, and a ring or port notifies its signals on every write
and every read. So:

- Workers that meet at a barrier settle together. The last one to arrive
  notifies the others during its step, so their waits have already fired by
  the time it awaits again, and the capture waits for them too.
- Stalled workers count as idle. A worker awaiting an event that never comes
  looks like one with nothing to do, so a capture cannot tell a stall from a
  finished frame.
- A worker waiting on `Worker.sleep`, or on a timed wait nothing has notified,
  counts as idle.

Timed waits follow the wall clock on both lanes, not the capture's frames.
That covers `Worker.sleep` and every await with a timeout, in a worker or on
the main lane, the main lane's own `Worker.sleep` included. A capture can step
many frames in the time a short sleep takes, so in a capture, pace lanes with
signals, ports and rings rather than with time.

A worker that fills a ring for a processor should await the ring's
`spaceSignal` when the ring is full, rather than poll it with a sleep. A
capture renders a frame's audio in one go, 800 samples per channel at 48000
Hz, so the ring should hold more than that much audio plus one record, since
a worker that waits for room can leave nearly a record of the ring empty. A
smaller ring, or a worker that polls, leaves gaps of silence that change from
run to run.

A single wait that lasts 60 seconds ends the waiting for the rest of the run.
After about 5 seconds of one wait, the log says which frame is still waiting
and on which lanes, counting the load as frame 0. When the capture gives up,
the log names the frame, and the end of the run repeats the warning, even with
`--quiet`, and exits with failure. The capture still writes its files, but
another run may not match them.

- `--no-settle-lanes` turns the waiting off.
- `--bench` never waits, and it reports what the frames cost, not what the
  lanes cost. Its jobs and workers run beside the frames it times, while its
  processors start but render nothing, since a bench plays no audio.

When a capture gives up, and when any headless run ends, the log also names
each worker still parked on an await, what it awaits and for how long, as in
`worker phase is still waiting for signal 2147487744 after 1.25 s`. A port's
messages queue in a ring, so a worker awaiting a port's `receive` waits for a
write to that ring and one awaiting `writable` for a read from it; a script
reads the ring's id as `port.ring.id`. Nothing checks whether anything could
still wake a worker, so a service waiting for its next request is named too.
The end of a run whose capture gave up repeats the workers named then after
its warning, even with `--quiet`.

## Platform differences

**Native** (desktop, mobile, consoles): modules run on WAMR. Jobs and workers
run on pool threads. A stopped job is interrupted at once, and a stopped
worker that never awaits again is interrupted after a short grace. These
interrupts reach every lane, with fuel or without, so there a lane's fuel only
costs speed. Processors run on the engine's audio thread; their `init` runs
off it. A host with no pool threads runs each queued job on the main lane's
thread at the next advance, at least one per advance and more while they are
quick, and a job run that way runs to its end.

**Web**: modules run on the browser's own wasm engine. A build with threads
loads only on a page served with cross origin isolation, the two headers a
browser needs before it shares memory between threads, so a page without them
needs a build without threads. A build with threads
runs jobs and workers on web workers. Each worker keeps the web worker it
started on for its whole life, awaits included, so up to 8 or so of a file's
workers alive at once each hold one. Past that, workers share threads, and a
step that runs long holds up the other workers on its thread. These threads
come from the pool of web workers the build starts with, and a thread past the
pool starts only once the page's thread returns to the browser. So a host
sizes that pool, emscripten's `PTHREAD_POOL_SIZE`, to hold up to 6 job
threads, one thread that schedules workers and 8 threads for each file's
workers. That makes 15 for a page with one file, besides any threads of the
host's own. A build without
threads steps workers between frames and runs each job on the page's thread at
the next advance, unless a join from a call without a budget runs it there
first, to its end.

A browser cannot interrupt a running call, so a lane ends early only at a
check of its own. A module baked with fuel asks, every so often as its loops
and calls run, whether it must end. A bake gives its job, worker and processor
modules fuel exactly when it gives its main module fuel: every debug bake
does, the web editor's previews among them, and so does a release bake with
`wasmFuel`; see `wasmFuel` in
[../project/rive-yaml.md](../project/rive-yaml.md). With fuel:

- a call into the main lane that passes its budget fails, as natively
- a stopped job ends at its next check, whether or not it polls
  `Lanes.stopping()`
- a stopped worker that awaits again ends at that await, and one that never
  does ends at its first check once a 50 ms grace has passed, as natively
- releasing the file ends its jobs and workers the same way, so each gives
  back the web worker it held
- without threads, a job run or a worker step that passes the main lane's
  call budget fails, as a call into the main lane would, and the page goes on
- a processor block past its hard limit ends at its next check, and only that
  processor fails; an `init` still running after a second fails the same way

Without fuel, as in a release bake without `wasmFuel`:

- a call into the main lane that runs past its budget is never stopped, so a
  runaway loop hangs the page
- a stopped job sees `Lanes.stopping()` turn true, and stops only once it
  polls that; one that never polls runs to its end, and without threads it
  holds the page until it returns
- a job run on the page's thread runs to its end, as the main lane's own
  code does
- a stopped worker ends at its next await, never in the middle of a step
- a processor block cannot be cut short: one past its hard limit is dropped
  once it returns, and one that stalls the audio thread for a second fails
  every processor and drops the output

Processors play in real time only in a build with threads, in an audio
worklet. Without threads a processor fails as it starts, and `failed` on its
handle says why. A processor's `init` runs in the worklet too, on the audio
render thread, so heavy setup delays the mix. A processor's `startFrame` and
the sample rate its `init` gets come from the page's audio output, whose frames
and rate `Audio.timeFrame` and `Audio.sampleRate` do not report, so a note
the main lane stamps with a frame from `Audio.timeFrame` does not play on
that frame. A browser cannot put its
page thread to sleep, so a `join`, `receiveWithin` or `waitWithin` there
spins until it is answered, for at most a tenth of a second, taking a core
the pool could use. Where the result can wait a frame, poll `running` or
await `promise()` instead. Without threads `receiveWithin` and `waitWithin`
never wait, since a worker only steps between advances. A file baked with SIMD the browser
lacks runs none of its scripts and says so on the console; see `wasmSimd` in
[../project/rive-yaml.md](../project/rive-yaml.md).

**NRDP**: as the web, except that a build with threads needs no cross origin
isolation there, and processors run on NRDP's own audio worklet thread, which
the page starts for them. A block that stalls that thread for a tenth of a
second fails every processor and ends the thread. With fuel, a block past its
hard limit ends at its next check, which at the default limit comes long
before that, so only its own processor fails. A processor's first block is
the exception: it is allowed a tenth of a second, so it can still stall the
thread.
