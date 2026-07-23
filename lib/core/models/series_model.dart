class SeriesModel {
  final String id;
  final String name;
  final String description;
  final List<String> courseIds;

  const SeriesModel({
    required this.id,
    required this.name,
    required this.description,
    required this.courseIds,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'courseIds': courseIds,
  };

  factory SeriesModel.fromJson(Map<String, dynamic> json) => SeriesModel(
    id: json['id'] as String,
    name: json['name'] as String,
    description: json['description'] as String,
    courseIds: (json['courseIds'] as List<dynamic>).cast<String>(),
  );

  static List<SeriesModel> get all => [
    SeriesModel(
      id: 'c',
      name: 'Série C — Mathématiques et Sciences Physiques',
      description: 'Mathématiques (coef 7), Physique (coef 5), Chimie (coef 2), SVTEEHB (coef 2)',
      courseIds: ['c_maths', 'c_physique', 'c_chimie', 'c_svt'],
    ),
    SeriesModel(
      id: 'd',
      name: 'Série D — Mathématiques et SVTEEHB',
      description: 'SVTEEHB (coef 6), Mathématiques (coef 4), Physique (coef 2), Chimie (coef 2)',
      courseIds: ['d_svt', 'd_maths', 'd_physique', 'c_chimie'],
    ),
    SeriesModel(
      id: 'ti',
      name: 'Série TI — Technologies de l\'Information',
      description: 'Informatique (coef 5), Mathématiques (coef 4), Physique (coef 2), Chimie (coef 2)',
      courseIds: ['ti_info', 'd_maths', 'd_physique', 'c_chimie'],
    ),
    SeriesModel(
      id: 'a',
      name: 'Série A — Lettres et Philosophie',
      description: 'Littérature (coef 3), Philosophie (coef 2-3), Histoire (coef 3), Français (coef 2)',
      courseIds: ['a_litterature', 'a_philosophie', 'a_histoire', 'a_francais'],
    ),
  ];
}
