// Démarre les animations Rive de la page quand elles arrivent à l'écran,
// les met en pause quand elles en sortent (batterie), et les rend
// interactives : survol et clic changent l'humeur de Kunfox.
import { Rive, Layout, Fit, Alignment, RuntimeLoader } from '@rive-app/canvas';

// Le moteur Rive est servi par le site lui-même, pas par un CDN.
RuntimeLoader.setWasmUrl('/rive/rive.wasm');

const reduit = matchMedia('(prefers-reduced-motion: reduce)').matches;
const vivantes = new Map<HTMLCanvasElement, Rive>();

function nombre(v: string | undefined) {
  return v === undefined || v === '' ? undefined : Number(v);
}

function demarrer(c: HTMLCanvasElement) {
  const d = c.dataset;
  const r: Rive = new Rive({
    src: `/rive/${d.rive}.riv`,
    canvas: c,
    stateMachines: d.machine!,
    autoplay: !reduit,
    layout: new Layout({ fit: Fit.Contain, alignment: Alignment.Center }),
    onLoad: () => {
      r.resizeDrawingSurfaceToCanvas();
      const entree = d.entree ? r.stateMachineInputs(d.machine!)?.find((i) => i.name === d.entree) : undefined;
      const regler = (v: number | undefined) => { if (entree && v !== undefined) entree.value = v; };
      regler(nombre(d.valeur));
      // l'état « à l'écran » arrive un instant après, pour qu'on voie la transition
      if (nombre(d.vue) !== undefined) setTimeout(() => regler(nombre(d.vue)), 350);
      const repos = nombre(d.vue) ?? nombre(d.valeur);
      let minuteur: number | undefined;
      if (nombre(d.survol) !== undefined) {
        c.addEventListener('pointerenter', () => { if (!minuteur) regler(nombre(d.survol)); });
        c.addEventListener('pointerleave', () => { if (!minuteur) regler(repos); });
      }
      if (nombre(d.clic) !== undefined) {
        c.style.cursor = 'pointer';
        c.addEventListener('click', () => {
          regler(nombre(d.clic));
          clearTimeout(minuteur);
          minuteur = window.setTimeout(() => { minuteur = undefined; regler(repos); }, 2400);
        });
      }
      if (reduit) r.pause();
    },
  });
  vivantes.set(c, r);
}

const obs = new IntersectionObserver((entrees) => {
  for (const e of entrees) {
    const c = e.target as HTMLCanvasElement;
    const r = vivantes.get(c);
    if (e.isIntersecting) {
      if (!r) demarrer(c);
      else if (!reduit) r.play();
    } else if (r) {
      r.pause();
    }
  }
}, { rootMargin: '120px 0px' });

document.querySelectorAll<HTMLCanvasElement>('canvas[data-rive]').forEach((c) => obs.observe(c));
addEventListener('resize', () => vivantes.forEach((r) => r.resizeDrawingSurfaceToCanvas()));
