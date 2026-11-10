// Démarre les animations Rive de la page quand elles arrivent à l'écran,
// les met en pause quand elles en sortent (batterie), et les rend
// interactives : survol et clic changent l'humeur de Kunfox.
import { Rive, Layout, Fit, Alignment, RuntimeLoader } from '@rive-app/canvas';

Rive.suppressDeprecationWarnings = ['state-machines-param', 'state-machine-inputs'];

// Le moteur Rive est servi par le site lui-même, pas par un CDN.
RuntimeLoader.setWasmUrl('/rive/rive.wasm');

// La couleur de Kabi, choisie sur la page (pastilles) et gardée dans le navigateur.
const kabis = new Set<Rive>();
function couleurKabi(): number {
  try { const v = Number(localStorage.getItem('kabi-couleur')); return Number.isInteger(v) && v >= 0 && v < 8 && localStorage.getItem('kabi-couleur') !== null ? v : 6; } catch { return 6; }
}
function choisirCouleurKabi(c: number) {
  try { localStorage.setItem('kabi-couleur', String(c)); } catch { /* navigation privée */ }
  kabis.forEach((r) => { const i = r.stateMachineInputs('Kabi')?.find((x) => x.name === 'color'); if (i) i.value = c; });
  document.querySelectorAll<HTMLButtonElement>('[data-couleur-kabi]').forEach((b) => b.setAttribute('aria-pressed', String(Number(b.dataset.couleurKabi) === c)));
}
document.querySelectorAll<HTMLButtonElement>('[data-couleur-kabi]').forEach((b) => {
  b.setAttribute('aria-pressed', String(Number(b.dataset.couleurKabi) === couleurKabi()));
  b.addEventListener('click', () => choisirCouleurKabi(Number(b.dataset.couleurKabi)));
});

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
    onLoadError: () => c.closest('.rive-cadre')?.classList.remove('pret'),
    autoplay: !reduit,
    layout: new Layout({ fit: Fit.Contain, alignment: Alignment.Center }),
    onLoad: () => {
      r.resizeDrawingSurfaceToCanvas();
      // l'animation a dessiné : l'image fixe s'efface
      requestAnimationFrame(() => c.closest('.rive-cadre')?.classList.add('pret'));
      const entrees = r.stateMachineInputs(d.machine!) ?? [];
      const trouver = (nom: string) => entrees.find((i) => i.name === nom);
      // Entrées fixes (Kabi : sans lunettes, sa couleur…).
      const fixes: Record<string, number | boolean> = d.fixes ? JSON.parse(d.fixes) : {};
      if (d.kabi) fixes.color = couleurKabi();
      for (const [nom, v] of Object.entries(fixes)) { const i = trouver(nom); if (i) i.value = v as never; }
      if (d.kabi) kabis.add(r);
      // Une valeur peut régler plusieurs entrées (Kabi : une humeur = une pose + une expression).
      const table: Record<string, Record<string, number>> | undefined = d.table ? JSON.parse(d.table) : undefined;
      const entree = d.entree ? trouver(d.entree) : undefined;
      const regler = (v: number | undefined) => {
        if (v === undefined) return;
        if (table) {
          for (const [nom, x] of Object.entries(table[String(v)] ?? {})) { const i = trouver(nom); if (i) i.value = x; }
        } else if (entree) entree.value = v;
      };
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
