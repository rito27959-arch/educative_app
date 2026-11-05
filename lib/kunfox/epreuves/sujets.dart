// Le registre des épreuves type Bac : l'ultime boss de chaque matière.

import 'modele.dart';
import 'sujets_chimie.dart';
import 'sujets_info.dart';
import 'sujets_maths.dart';
import 'sujets_physique.dart';
import 'sujets_svt.dart';

const List<Epreuve> toutesLesEpreuves = [
  epreuveMathsD,
  epreuvePhysiqueD,
  epreuveChimieD,
  epreuveSvtD,
  epreuveInfoD,
  epreuveMathsC,
  epreuvePhysiqueC,
  epreuveChimieC,
  epreuveSvtC,
  epreuveInfoC,
];

Epreuve? epreuveParId(String id) {
  for (final e in toutesLesEpreuves) {
    if (e.id == id) return e;
  }
  return null;
}

/// Les épreuves d'une matière (id du curriculum).
List<Epreuve> epreuvesDe(String matiereId) => [
      for (final e in toutesLesEpreuves)
        if (e.matiere == matiereId) e,
    ];
