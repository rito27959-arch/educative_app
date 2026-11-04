import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/data/curriculum_data.dart';
import '../../core/models/curriculum_models.dart';
import '../../core/providers/auth_provider.dart';
import 'progression.dart';

/// Les matières de la série de l'élève (BAC D par défaut).
final matieresProvider = Provider<List<SubjectCurriculum>>((ref) {
  final serie = ref.watch(authProvider.select((a) => a.user?.bacSeries)) ?? 'D';
  final liste = CurriculumData.forSeries(serie);
  return liste.isNotEmpty ? liste : CurriculumData.forSeries('D');
});

/// La matière affichée sur le parcours.
final matiereActiveProvider = Provider<SubjectCurriculum?>((ref) {
  final liste = ref.watch(matieresProvider);
  if (liste.isEmpty) return null;
  final id = ref.watch(progressionProvider.select((p) => p.matiere));
  return liste.firstWhere((s) => s.id == id, orElse: () => liste.first);
});

/// Le nom court d'une série, pour l'affichage.
String nomSerie(String s) => 'BAC ${s.replaceAll('BAC ', '').trim().toUpperCase()}';
