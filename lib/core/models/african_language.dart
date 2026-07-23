import 'package:flutter/material.dart';

class AfricanLanguage {
  final String code;
  final String name;
  final String nativeName;
  final String region;
  final IconData icon;
  final Color color;

  const AfricanLanguage({
    required this.code,
    required this.name,
    required this.nativeName,
    required this.region,
    required this.icon,
    required this.color,
  });

  static const List<AfricanLanguage> all = [
    AfricanLanguage(
      code: 'fr',
      name: 'Français',
      nativeName: 'Français',
      region: 'Afrique francophone',
      icon: Icons.language,
      color: Color(0xFF2563FF),
    ),
    AfricanLanguage(
      code: 'wo',
      name: 'Wolof',
      nativeName: 'Wolof',
      region: 'Sénégal, Gambie',
      icon: Icons.forum,
      color: Color(0xFFFF6B2B),
    ),
    AfricanLanguage(
      code: 'bm',
      name: 'Bambara',
      nativeName: 'Bamanankan',
      region: 'Mali',
      icon: Icons.forum,
      color: Color(0xFF00E676),
    ),
    AfricanLanguage(
      code: 'ha',
      name: 'Hausa',
      nativeName: 'Hausa',
      region: 'Niger, Nigeria, Tchad',
      icon: Icons.forum,
      color: Color(0xFF8B5CF6),
    ),
    AfricanLanguage(
      code: 'sw',
      name: 'Swahili',
      nativeName: 'Kiswahili',
      region: 'Tanzanie, Kenya, RDC',
      icon: Icons.forum,
      color: Color(0xFFEC4899),
    ),
    AfricanLanguage(
      code: 'ff',
      name: 'Peul',
      nativeName: 'Fulfulde',
      region: 'Sahel, Afrique de l\'Ouest',
      icon: Icons.forum,
      color: Color(0xFF06D6A0),
    ),
    AfricanLanguage(
      code: 'ln',
      name: 'Lingala',
      nativeName: 'Lingala',
      region: 'RDC, Congo',
      icon: Icons.forum,
      color: Color(0xFFFFB400),
    ),
    AfricanLanguage(
      code: 'en',
      name: 'English',
      nativeName: 'English',
      region: 'Afrique anglophone',
      icon: Icons.language,
      color: Color(0xFF4D8AFF),
    ),
  ];

  static AfricanLanguage fromCode(String code) =>
      all.firstWhere((l) => l.code == code, orElse: () => all.first);
}
