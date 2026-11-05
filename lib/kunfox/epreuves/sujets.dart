// Le registre des épreuves type Bac : l'ultime boss de chaque matière.

import 'modele.dart';
import 'sujets_2_maths_phys.dart';
import 'sujets_2_sciences.dart';
import 'sujets_a.dart';
import 'sujets_chimie.dart';
import 'sujets_info.dart';
import 'sujets_maths.dart';
import 'sujets_physique.dart';
import 'sujets_svt.dart';
import 'sujets_ti.dart';

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
  epreuveMathsD2,
  epreuvePhysiqueD2,
  epreuveChimieD2,
  epreuveSvtD2,
  epreuveInfoD2,
  epreuveMathsC2,
  epreuvePhysiqueC2,
  epreuveChimieC2,
  epreuveSvtC2,
  epreuveInfoC2,
  epreuveFrancaisA,
  epreuveAnglaisA,
  epreuvePhilosophieA,
  epreuveHistoireGeoA,
  epreuveMathsA,
  epreuveInfoTi,
  epreuveMathsTi,
  epreuvePhysiqueTi,
  epreuveAnglaisTi,
  epreuveFrancaisTi,
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
