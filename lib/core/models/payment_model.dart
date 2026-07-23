/// 20 façons dont l'App récompense l'utilisateur.
///
/// Chaque action positive = des coins, utilisables pour
/// des gels de série, essais Premium, etc.
enum RewardType {
  streakFreeze,       // Gel de série — protège ta série d'étude
  dailyLogin,         // Connexion quotidienne — 1er lancement du jour
  streakMilestone,    // Palier de série — 7j / 30j / 60j consécutifs
  achievement,        // Succès débloqué — trophée spécial
  referral,           // Parrainage — un ami s'inscrit via ton code
  p2pChallenge,       // Défi P2P gagné — victoire en quiz pair-à-pair
  perfectLesson,      // Leçon parfaite — 100% à une leçon
  contentShare,       // Partage de contenu — ressource partagée
  communityHelp,      // Entraide — réponse acceptée sur le forum
  examPass,           // Examen réussi — note ≥ 80%
  earlyAdopter,       // Early adopter — parmi les 1000 premiers
  meshContribution,   // Nœud actif — relais mesh super-peer
  courseReview,       // Avis laissé — feedback sur un cours
  groupStudy,         // Session groupe — étude P2P collaborative
  comebackBonus,      // Retour gagnant — revenu après ≥ 7j d'absence
  subjectExplorer,    // Explorateur — étudié dans 5+ matières
  quizStreak,         // Série quiz — 5 quiz parfaits consécutifs
  speedAnswer,        // Réponse éclair — bonne réponse en < 5s
  offlineStudy,       // Hors-ligne — 10h d'étude sans connexion
  milestone,          // Jalon — 100 leçons complétées
}

/// Une récompense obtenue par l'utilisateur.
class Reward {
  final String id;
  final RewardType type;
  final int coinAmount;
  final DateTime earnedAt;
  final bool isClaimed;

  const Reward({
    required this.id,
    required this.type,
    required this.coinAmount,
    required this.earnedAt,
    this.isClaimed = false,
  });

  Reward copyWith({bool? isClaimed}) => Reward(
    id: id,
    type: type,
    coinAmount: coinAmount,
    earnedAt: earnedAt,
    isClaimed: isClaimed ?? this.isClaimed,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type.name,
    'coinAmount': coinAmount,
    'earnedAt': earnedAt.toIso8601String(),
    'isClaimed': isClaimed,
  };

  factory Reward.fromJson(Map<String, dynamic> json) => Reward(
    id: json['id'] as String,
    type: RewardType.values.firstWhere((r) => r.name == json['type']),
    coinAmount: json['coinAmount'] as int,
    earnedAt: DateTime.parse(json['earnedAt'] as String),
    isClaimed: json['isClaimed'] as bool? ?? false,
  );
}

/// Info statique sur un type de récompense (affichage).
class RewardInfo {
  final RewardType type;
  final String title;
  final String description;
  final int coinAmount;
  final String emoji;

  const RewardInfo({
    required this.type,
    required this.title,
    required this.description,
    required this.coinAmount,
    required this.emoji,
  });

  static const all = [
    RewardInfo(
      type: RewardType.streakFreeze,
      title: 'Gel de série',
      description: 'Protège ta série d\'étude',
      coinAmount: 50,
      emoji: '🧊',
    ),
    RewardInfo(
      type: RewardType.dailyLogin,
      title: 'Connexion quotidienne',
      description: 'Première connexion du jour',
      coinAmount: 10,
      emoji: '☀️',
    ),
    RewardInfo(
      type: RewardType.streakMilestone,
      title: 'Palier de série',
      description: '7j / 30j / 60j consécutifs',
      coinAmount: 100,
      emoji: '🔥',
    ),
    RewardInfo(
      type: RewardType.achievement,
      title: 'Succès débloqué',
      description: 'Trophée ou accomplissement spécial',
      coinAmount: 200,
      emoji: '🏆',
    ),
    RewardInfo(
      type: RewardType.referral,
      title: 'Parrainage',
      description: 'Un ami s\'inscrit via ton code',
      coinAmount: 500,
      emoji: '👥',
    ),
    RewardInfo(
      type: RewardType.p2pChallenge,
      title: 'Défi P2P gagné',
      description: 'Victoire en quiz pair-à-pair',
      coinAmount: 30,
      emoji: '⚔️',
    ),
    RewardInfo(
      type: RewardType.perfectLesson,
      title: 'Leçon parfaite',
      description: '100% à une leçon ou chapitre',
      coinAmount: 25,
      emoji: '💯',
    ),
    RewardInfo(
      type: RewardType.contentShare,
      title: 'Partage de contenu',
      description: 'Ressource partagée avec la communauté',
      coinAmount: 15,
      emoji: '📤',
    ),
    RewardInfo(
      type: RewardType.communityHelp,
      title: 'Entraide',
      description: 'Réponse acceptée sur le forum',
      coinAmount: 40,
      emoji: '🤝',
    ),
    RewardInfo(
      type: RewardType.examPass,
      title: 'Examen réussi',
      description: 'Note ≥ 80% à un examen blanc',
      coinAmount: 75,
      emoji: '🎓',
    ),
    RewardInfo(
      type: RewardType.earlyAdopter,
      title: 'Early Adopter',
      description: 'Parmi les 1000 premiers utilisateurs',
      coinAmount: 1000,
      emoji: '🚀',
    ),
    RewardInfo(
      type: RewardType.meshContribution,
      title: 'Nœud actif',
      description: 'Relais mesh super-peer actif',
      coinAmount: 60,
      emoji: '📡',
    ),
    RewardInfo(
      type: RewardType.courseReview,
      title: 'Avis laissé',
      description: 'Feedback sur un cours terminé',
      coinAmount: 20,
      emoji: '⭐',
    ),
    RewardInfo(
      type: RewardType.groupStudy,
      title: 'Session groupe',
      description: 'Étude collaborative P2P',
      coinAmount: 35,
      emoji: '👨‍🎓',
    ),
    RewardInfo(
      type: RewardType.comebackBonus,
      title: 'Retour gagnant',
      description: 'Revenu après ≥ 7 jours d\'absence',
      coinAmount: 150,
      emoji: '🔄',
    ),
    RewardInfo(
      type: RewardType.subjectExplorer,
      title: 'Explorateur',
      description: 'Étudié dans 5 matières différentes',
      coinAmount: 80,
      emoji: '🧭',
    ),
    RewardInfo(
      type: RewardType.quizStreak,
      title: 'Série quiz',
      description: '5 quiz parfaits consécutifs',
      coinAmount: 45,
      emoji: '🎯',
    ),
    RewardInfo(
      type: RewardType.speedAnswer,
      title: 'Réponse éclair',
      description: 'Bonne réponse en moins de 5 secondes',
      coinAmount: 12,
      emoji: '⚡',
    ),
    RewardInfo(
      type: RewardType.offlineStudy,
      title: 'Hors-ligne',
      description: '10 heures d\'étude sans connexion',
      coinAmount: 90,
      emoji: '📴',
    ),
    RewardInfo(
      type: RewardType.milestone,
      title: 'Jalon',
      description: '100 leçons complétées',
      coinAmount: 300,
      emoji: '🎯',
    ),
  ];

  static RewardInfo fromType(RewardType type) =>
      all.firstWhere((r) => r.type == type);
}

/// Statut d'une transaction financière.
enum TransactionStatus { pending, processing, completed, failed, refunded }

/// Transaction de wallet (top-up, paiement, abonnement).
class Transaction {
  final String id;
  final String description;
  final double amountFcfa;
  final double feeFcfa;
  final TransactionStatus status;
  final DateTime timestamp;
  final String? reference;
  final bool isCredit;

  const Transaction({
    required this.id,
    required this.description,
    required this.amountFcfa,
    this.feeFcfa = 0,
    this.status = TransactionStatus.pending,
    required this.timestamp,
    this.reference,
    this.isCredit = false,
  });

  double get totalFcfa => amountFcfa + feeFcfa;

  Map<String, dynamic> toJson() => {
    'id': id,
    'description': description,
    'amountFcfa': amountFcfa,
    'feeFcfa': feeFcfa,
    'status': status.name,
    'timestamp': timestamp.toIso8601String(),
    'reference': reference,
    'isCredit': isCredit,
  };

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
    id: json['id'] as String,
    description: json['description'] as String,
    amountFcfa: (json['amountFcfa'] as num).toDouble(),
    feeFcfa: (json['feeFcfa'] as num?)?.toDouble() ?? 0,
    status: TransactionStatus.values.firstWhere((s) => s.name == json['status']),
    timestamp: DateTime.parse(json['timestamp'] as String),
    reference: json['reference'] as String?,
    isCredit: json['isCredit'] as bool? ?? false,
  );
}

/// Wallet local (FCFA + Coins récompense).
class Wallet {
  final double balanceFcfa;
  final int coinBalance;
  final List<Transaction> recentTransactions;
  final List<Reward> recentRewards;
  final bool hasPin;
  final double monthlySpendFcfa;
  final double monthlyLimitFcfa;
  final int streakFreezesAvailable;

  const Wallet({
    this.balanceFcfa = 0,
    this.coinBalance = 0,
    this.recentTransactions = const [],
    this.recentRewards = const [],
    this.hasPin = false,
    this.monthlySpendFcfa = 0,
    this.monthlyLimitFcfa = 50000,
    this.streakFreezesAvailable = 0,
  });

  Wallet copyWith({
    double? balanceFcfa,
    int? coinBalance,
    List<Transaction>? recentTransactions,
    List<Reward>? recentRewards,
    bool? hasPin,
    double? monthlySpendFcfa,
    double? monthlyLimitFcfa,
    int? streakFreezesAvailable,
  }) {
    return Wallet(
      balanceFcfa: balanceFcfa ?? this.balanceFcfa,
      coinBalance: coinBalance ?? this.coinBalance,
      recentTransactions: recentTransactions ?? this.recentTransactions,
      recentRewards: recentRewards ?? this.recentRewards,
      hasPin: hasPin ?? this.hasPin,
      monthlySpendFcfa: monthlySpendFcfa ?? this.monthlySpendFcfa,
      monthlyLimitFcfa: monthlyLimitFcfa ?? this.monthlyLimitFcfa,
      streakFreezesAvailable: streakFreezesAvailable ?? this.streakFreezesAvailable,
    );
  }
}
