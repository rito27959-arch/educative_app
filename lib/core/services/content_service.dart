import 'dart:convert';
import 'package:flutter/services.dart';

class ContentService {
  static Map<String, dynamic>? _cache;
  static Map<String, dynamic>? get cache => _cache;

  static Future<Map<String, dynamic>> load() async {
    if (_cache != null) return _cache!;
    final raw = await rootBundle.loadString('assets/course_content.json');
    _cache = json.decode(raw) as Map<String, dynamic>;
    return _cache!;
  }

  static Future<List<Map<String, dynamic>>> getChapters(String courseId) async {
    final data = await load();
    final course = data[courseId] as Map<String, dynamic>?;
    if (course == null) return [];
    return (course['chapters'] as List<dynamic>).cast<Map<String, dynamic>>();
  }

  static Future<Map<String, dynamic>?> getChapter(String courseId, String chapterId) async {
    final chapters = await getChapters(courseId);
    try {
      return chapters.firstWhere((c) => c['id'] == chapterId);
    } catch (_) {
      return null;
    }
  }
}
