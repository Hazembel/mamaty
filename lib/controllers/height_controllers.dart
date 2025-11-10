class HeightController {
  /// Returns an error message if height is abnormal, null otherwise
  static String? validateHeight({
    required double height,
    required int ageInDays,
    required String gender, // 'male' or 'female'
  }) {
    // Validate inputs
    if (gender != 'male' && gender != 'female') {
      throw ArgumentError.value(gender, 'gender', 'Must be "male" or "female"');
    }
    if (ageInDays < 0) {
      return 'Âge invalide';
    }
    if (height <= 0) {
      return 'Hauteur invalide';
    }
 
  final heightRanges = [
  // 0 (0–30 days)
  {'minMale': 46.0, 'maxMale': 55.0, 'minFemale': 45.0, 'maxFemale': 54.0, 'startDay': 0, 'endDay': 30},

  // 1 month (31–60 days)
  {'minMale': 50.0, 'maxMale': 59.0, 'minFemale': 49.0, 'maxFemale': 58.0, 'startDay': 31, 'endDay': 60},

  // 2 months (61–90 days)
  {'minMale': 53.0, 'maxMale': 63.0, 'minFemale': 52.0, 'maxFemale': 62.0, 'startDay': 61, 'endDay': 90},

  // 3 months (91–120 days)
  {'minMale': 56.0, 'maxMale': 66.0, 'minFemale': 54.0, 'maxFemale': 65.0, 'startDay': 91, 'endDay': 120},

  // 4 months (121–150 days)
  {'minMale': 58.0, 'maxMale': 68.0, 'minFemale': 56.0, 'maxFemale': 67.0, 'startDay': 121, 'endDay': 150},

  // 5 months (151–180 days)
  {'minMale': 60.0, 'maxMale': 70.0, 'minFemale': 58.0, 'maxFemale': 69.0, 'startDay': 151, 'endDay': 180},

  // 6 months (181–210 days)
  {'minMale': 62.0, 'maxMale': 72.0, 'minFemale': 60.0, 'maxFemale': 71.0, 'startDay': 181, 'endDay': 210},

  // 7 months (211–240 days)
  {'minMale': 63.0, 'maxMale': 73.5, 'minFemale': 61.0, 'maxFemale': 72.0, 'startDay': 211, 'endDay': 240},

  // 8 months (241–270 days)
  {'minMale': 64.0, 'maxMale': 75.0, 'minFemale': 62.0, 'maxFemale': 73.0, 'startDay': 241, 'endDay': 270},

  // 9 months (271–300 days)
  {'minMale': 65.0, 'maxMale': 76.0, 'minFemale': 63.0, 'maxFemale': 74.0, 'startDay': 271, 'endDay': 300},

  // 10 months (301–330 days)
  {'minMale': 66.0, 'maxMale': 77.0, 'minFemale': 64.0, 'maxFemale': 75.0, 'startDay': 301, 'endDay': 330},

  // 11 months (331–360 days)
  {'minMale': 67.0, 'maxMale': 78.0, 'minFemale': 65.0, 'maxFemale': 76.0, 'startDay': 331, 'endDay': 360},

  // 12 months (361–390 days)
  {'minMale': 68.0, 'maxMale': 79.0, 'minFemale': 66.0, 'maxFemale': 77.0, 'startDay': 361, 'endDay': 390},

  // 13 months
  {'minMale': 69.0, 'maxMale': 80.0, 'minFemale': 67.0, 'maxFemale': 78.0, 'startDay': 391, 'endDay': 420},

  // 14 months
  {'minMale': 70.0, 'maxMale': 81.0, 'minFemale': 68.0, 'maxFemale': 79.0, 'startDay': 421, 'endDay': 450},

  // 15 months
  {'minMale': 71.0, 'maxMale': 82.0, 'minFemale': 69.0, 'maxFemale': 80.0, 'startDay': 451, 'endDay': 480},

  // 16 months
  {'minMale': 72.0, 'maxMale': 83.0, 'minFemale': 70.0, 'maxFemale': 81.0, 'startDay': 481, 'endDay': 510},

  // 17 months
  {'minMale': 73.0, 'maxMale': 84.0, 'minFemale': 71.0, 'maxFemale': 82.0, 'startDay': 511, 'endDay': 540},

  // 18 months
  {'minMale': 74.0, 'maxMale': 85.0, 'minFemale': 72.0, 'maxFemale': 83.0, 'startDay': 541, 'endDay': 570},

  // 19 months
  {'minMale': 75.0, 'maxMale': 86.0, 'minFemale': 73.0, 'maxFemale': 84.0, 'startDay': 571, 'endDay': 600},

  // 20 months
  {'minMale': 76.0, 'maxMale': 87.0, 'minFemale': 74.0, 'maxFemale': 85.0, 'startDay': 601, 'endDay': 630},

  // 21 months
  {'minMale': 77.0, 'maxMale': 88.0, 'minFemale': 75.0, 'maxFemale': 86.0, 'startDay': 631, 'endDay': 660},

  // 22 months
  {'minMale': 78.0, 'maxMale': 89.0, 'minFemale': 76.0, 'maxFemale': 87.0, 'startDay': 661, 'endDay': 690},

  // 23 months
  {'minMale': 79.0, 'maxMale': 90.0, 'minFemale': 77.0, 'maxFemale': 88.0, 'startDay': 691, 'endDay': 720},

  // 24 months
  {'minMale': 80.0, 'maxMale': 91.0, 'minFemale': 78.0, 'maxFemale': 89.0, 'startDay': 721, 'endDay': 750},
];


    // Find the correct range for the age
    final range = heightRanges.firstWhere(
      (r) => ageInDays >= r['startDay']! && ageInDays <= r['endDay']!,
      orElse: () => {},
    );

    if (range.isEmpty) {
      return 'Âge non pris en charge (doit être ≤ 24 mois)';
    }

    final min = (gender == 'male') ? range['minMale']! : range['minFemale']!;
    final max = (gender == 'male') ? range['maxMale']! : range['maxFemale']!;

    if (height < min) return 'Taille trop faible pour cet âge et sexe';
    if (height > max) return 'Taille trop élevée pour cet âge et sexe';

    return null; // ✅ Normal
  }
}