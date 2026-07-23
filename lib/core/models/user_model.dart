class UserModel {
  final String pseudo;
  final String bacSeries;
  final String cryptoIdentity;
  final String avatarUrl;
  final bool isGatewayActive;
  final int meshPeers;
  final String bio;

  const UserModel({
    required this.pseudo,
    required this.bacSeries,
    required this.cryptoIdentity,
    this.avatarUrl = '',
    this.isGatewayActive = true,
    this.meshPeers = 42,
    this.bio = '',
  });

  UserModel copyWith({
    String? pseudo,
    String? bacSeries,
    String? cryptoIdentity,
    String? avatarUrl,
    bool? isGatewayActive,
    int? meshPeers,
    String? bio,
  }) {
    return UserModel(
      pseudo: pseudo ?? this.pseudo,
      bacSeries: bacSeries ?? this.bacSeries,
      cryptoIdentity: cryptoIdentity ?? this.cryptoIdentity,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isGatewayActive: isGatewayActive ?? this.isGatewayActive,
      meshPeers: meshPeers ?? this.meshPeers,
      bio: bio ?? this.bio,
    );
  }

  Map<String, dynamic> toJson() => {
    'pseudo': pseudo,
    'bacSeries': bacSeries,
    'cryptoIdentity': cryptoIdentity,
    'avatarUrl': avatarUrl,
    'isGatewayActive': isGatewayActive,
    'meshPeers': meshPeers,
    'bio': bio,
  };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    pseudo: json['pseudo'] as String,
    bacSeries: json['bacSeries'] as String,
    cryptoIdentity: json['cryptoIdentity'] as String,
    avatarUrl: json['avatarUrl'] as String? ?? '',
    isGatewayActive: json['isGatewayActive'] as bool? ?? true,
    meshPeers: json['meshPeers'] as int? ?? 42,
    bio: json['bio'] as String? ?? '',
  );
}
