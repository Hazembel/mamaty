class WeightController {
  /// Validates baby's weight according to age and gender.
  /// Returns a string error message if invalid, or `null` if OK.
  static String? validateWeight({
    required double weight,
    required int ageInDays,
    required String gender,
  }) {
    final g = gender.toLowerCase();

    // Check only for babies < 30 days
    if (ageInDays < 30) {
      if (g == 'male' && (weight < 2.4 || weight > 4.4)) {
        return "Le poids du garçon est en dehors de la plage normale (2.4 – 4.4 kg).";
      }
      if (g == 'female' && (weight < 2.3 || weight > 4.2)) {
        return "Le poids de la fille est en dehors de la plage normale (2.3 – 4.2 kg).";
      }
    }
// TODO Add weight controller
    // ✅ If everything is OK
    return null;
  }
}
