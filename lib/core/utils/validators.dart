class Validators {
  Validators._();

  static String? required(String? value, [String field = 'Ce champ']) {
    if (value == null || value.trim().isEmpty) return '$field est requis';
    return null;
  }

  static String? pseudo(String? value) {
    if (value == null || value.trim().isEmpty) return 'Le pseudo est requis';
    if (value.length < 2) return 'Le pseudo doit contenir au moins 2 caractères';
    if (value.length > 20) return 'Le pseudo ne peut pas dépasser 20 caractères';
    if (!RegExp(r'^[a-zA-Z0-9_\-\s]+$').hasMatch(value)) return 'Caractères non autorisés';
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) return 'L\'email est requis';
    if (!value.contains('@') || !value.contains('.')) return 'Email invalide';
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.trim().isEmpty) return 'Le mot de passe est requis';
    if (value.length < 6) return 'Minimum 6 caractères';
    if (!RegExp(r'[A-Z]').hasMatch(value)) return 'Doit contenir une majuscule';
    if (!RegExp(r'[0-9]').hasMatch(value)) return 'Doit contenir un chiffre';
    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    if (!RegExp(r'^\+?[0-9]{8,15}$').hasMatch(value.replaceAll(' ', ''))) return 'Numéro invalide';
    return null;
  }

  static String? url(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    if (!value.startsWith('http://') && !value.startsWith('https://')) return 'URL doit commencer par http:// ou https://';
    return null;
  }

  static String? maxLength(String? value, int max, [String field = 'Ce champ']) {
    if (value != null && value.length > max) return '$field ne peut pas dépasser $max caractères';
    return null;
  }

  static String? minLength(String? value, int min, [String field = 'Ce champ']) {
    if (value != null && value.length < min) return '$field doit contenir au moins $min caractères';
    return null;
  }

  static String? numeric(String? value, [String field = 'Ce champ']) {
    if (value == null || value.trim().isEmpty) return null;
    if (double.tryParse(value) == null) return '$field doit être un nombre';
    return null;
  }

  static String? match(String? value, String other, [String field = 'Les champs']) {
    if (value != other) return '$field ne correspondent pas';
    return null;
  }
}

class FormValidation {
  FormValidation._();

  static bool isValid(Map<String, String?> errors) {
    return errors.values.every((e) => e == null);
  }

  static Map<String, String?> validateAll(Map<String, String?> Function() validators) {
    return validators();
  }
}
