import 'package:flutter_test/flutter_test.dart';
import 'package:ouro_prep/core/data/curriculum_data.dart';
import 'package:ouro_prep/kunfox/epreuves/modele.dart';
import 'package:ouro_prep/kunfox/epreuves/sujets.dart';
import 'package:ouro_prep/kunfox/riche/graphe.dart';
import 'package:ouro_prep/kunfox/riche/illustrations.dart';

Iterable<String> _blocs(String texte, String genre) sync* {
  final m = RegExp('```$genre\\n(.*?)```', dotAll: true);
  for (final x in m.allMatches(texte)) {
    yield x[1]!;
  }
}

void main() {
  for (final e in toutesLesEpreuves) {
    group(e.id, () {
      test('noté sur 20', () => expect(e.bareMax, closeTo(20, 1e-9)));

      test('matière et chapitres connus', () {
        expect(CurriculumData.findById(e.matiere), isNotNull, reason: e.matiere);
        for (final x in e.exercices) {
          for (final q in x.questions) {
            if (q.chapitre != null) expect(CurriculumData.findChapterById(q.chapitre!), isNotNull, reason: '${q.numero} ${q.chapitre}');
          }
        }
      });

      test('chaque réponse attendue est acceptée par le correcteur', () {
        for (final x in e.exercices) {
          for (final q in x.questions) {
            final r = switch (q.genre) {
              GenreQuestion.qcm || GenreQuestion.vraiFaux => q.corriger(q.bonne),
              GenreQuestion.nombre => q.corriger(q.valeur!.toString()),
              GenreQuestion.expression => q.corriger(q.expression),
              GenreQuestion.courte => q.corriger(q.acceptees.first),
              GenreQuestion.redaction => true,
            };
            expect(r, isTrue, reason: '${x.titre} ${q.numero}');
            if (q.genre == GenreQuestion.qcm) expect(q.corriger((q.bonne + 1) % q.options.length), isFalse);
          }
        }
      });

      test('les courbes se lisent', () {
        final textes = [
          for (final x in e.exercices) ...[x.enonce, for (final q in x.questions) q.corrige],
        ];
        for (final t in textes) {
          for (final src in _blocs(t, 'graphe')) {
            final s = SpecGraphe.lire(src);
            expect(s.courbes, isNotEmpty, reason: src);
          }
        }
      });
    });
  }

  test('illustrations des leçons : leçons connues et courbes lisibles', () {
    illustrationsLecons.forEach((id, texte) {
      expect(CurriculumData.findLessonById(id), isNotNull, reason: id);
      for (final src in _blocs(texte, 'graphe')) {
        final s = SpecGraphe.lire(src);
        expect(s.courbes, isNotEmpty, reason: '$id : $src');
        final f = s.courbes.first.f;
        final milieu = f((s.xMin + s.xMax) / 2 + 0.013);
        expect(milieu.isFinite, isTrue, reason: '$id : valeur au milieu');
      }
    });
  });

  test('virgule décimale et unités dans les nombres', () {
    final q = epreuvePremiereNombreAvecUnite();
    if (q != null) {
      expect(q.corriger('${q.valeur.toString().replaceAll('.', ',')} ${q.unite}'), isTrue);
    }
  });
}

QuestionEpreuve? epreuvePremiereNombreAvecUnite() {
  for (final e in toutesLesEpreuves) {
    for (final x in e.exercices) {
      for (final q in x.questions) {
        if (q.genre == GenreQuestion.nombre && q.unite != null) return q;
      }
    }
  }
  return null;
}
