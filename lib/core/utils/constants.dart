import 'package:flutter/material.dart';

class AppConstants {
  AppConstants._();

  static const String appName = 'OURO PREP';
  static const String version = '1.0.0';
  static const String buildNumber = '1';

  static const String storageKey = 'ouro_prep_store';
  static const String userKey = 'user';
  static const String coursesKey = 'courses';
  static const String chaptersKey = 'chapters';
  static const String notesKey = 'notes';
  static const String messagesKey = 'messages';

  static const Duration splashDuration = Duration(seconds: 3);
  static const Duration authTimeout = Duration(seconds: 10);
  static const Duration meshTimeout = Duration(seconds: 5);
  static const Duration callTimeout = Duration(seconds: 30);

  static const int maxMessageLength = 500;
  static const int maxPseudoLength = 20;
  static const int maxNoteLength = 1000;
  static const int maxReactions = 10;
  static const int maxFileSize = 50 * 1024 * 1024;

  static const int defaultMeshPeers = 42;
  static const double defaultProgress = 0.72;
  static const double defaultLatencyMs = 42;

  static const List<String> bacSeries = ['BAC C', 'BAC D', 'BAC TI', 'BAC A'];
  static const List<String> subjectColors = ['#00A8FF', '#FF7A00', '#00E676', '#9C27B0'];

  static const Map<String, String> subjectIcons = {
    'Mathématiques': 'functions',
    'Physique': 'science',
    'Informatique': 'computer',
    'Littérature': 'menu_book',
  };

  static const List<String> courseTypes = ['PDF', 'Vidéo', 'Quiz'];
  static const List<String> forumMessageTypes = ['text', 'image', 'audio', 'file'];
  static const List<String> reactions = ['👍', '❤️', '🔥', '💡', '❓', '📚'];

  static const String expertDefaultMessage =
      'Bonjour! Je suis OURO EXPERT. Pose-moi une question sur tes cours!';
  static const String meshStatusActive = 'Passerelle Active';
  static const String meshStatusConnecting = 'Connexion au maillage...';
  static const String meshStatusOffline = 'Hors ligne';
  static const String defaultPseudo = 'Étudiant';
}

class ApiEndpoints {
  ApiEndpoints._();
  static const String baseUrl = 'https://api.ouroprep.com/v1';
  static const String auth = '/auth';
  static const String courses = '/courses';
  static const String chapters = '/chapters';
  static const String notes = '/notes';
  static const String messages = '/messages';
  static const String users = '/users';
  static const String sync = '/sync';
  static const String health = '/health';
}

class AssetPaths {
  AssetPaths._();
  static const String assets = 'assets/';
  static const String images = '${assets}images/';
  static const String icons = '${assets}icons/';
  static const String animations = '${assets}animations/';
  static const String fonts = '${assets}fonts/';
  static const String logo = '${images}logo.png';
  static const String meshIcon = '${icons}mesh.svg';
  static const String splashAnim = '${animations}splash.riv';
  static const String expertAnim = '${animations}expert.riv';
}

class AnimationConstants {
  AnimationConstants._();

  static const Duration fast = Duration(milliseconds: 200);
  static const Duration normal = Duration(milliseconds: 350);
  static const Duration slow = Duration(milliseconds: 500);
  static const Duration xSlow = Duration(milliseconds: 800);

  static const Curve defaultCurve = Curves.easeInOut;
  static const Curve emphasis = Curves.easeOutCubic;
  static const Curve spring = Curves.easeOutBack;
  static const Curve bounce = Curves.elasticOut;
}
