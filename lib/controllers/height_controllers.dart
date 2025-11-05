class HeightController {
  static String? validateHeight({
    required double height,
    required int ageInDays,
    required String gender,
  }) {
    // Example rule: newborns (0–30 days)
    if (ageInDays >= 0 && ageInDays < 30) {
      if (gender == 'male') {
        if (height < 46 || height > 55) return 'Taille anormale pour un nouveau-né garçon';
      } else {
        if (height < 45 || height > 54) return 'Taille anormale pour un nouveau-né fille';
      }
    }

    // TODO Add height controller

    return null; // ✅ Normal case
  }
}
