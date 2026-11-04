# Site de Kunfox

Site vitrine en [Astro](https://astro.build), destiné à `kunfox.dropletmesh.app`.

- Deux thèmes : « Aube » (clair) et « Nuit de renard » (sombre). Le site suit le
  réglage du système ; le bouton soleil / lune fixe un choix.
- Animation d'entrée : le renard apparaît, sa toque tombe sur l'oreille, il cligne
  des yeux, puis « Kunfox » glisse de derrière lui (une fois par visite, passable
  d'un clic, désactivée si « réduire les animations » est demandé).
- Sections qui apparaissent au défilement, téléphone dont l'écran suit le récit.

```sh
cd site
npm install
npm run dev      # http://localhost:4321
npm run build    # le site final dans dist/
```
