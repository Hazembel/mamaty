class WeightController {
  /// Returns an error message if weight is abnormal, null otherwise
  static String? validateWeight({
    required double weight,
    required int ageInDays,
    required String gender, // 'male' or 'female'
  }) {
    // Define all ranges in a list
  final weightRanges = [
  // 0 days
  {'minMale': 2.4, 'maxMale': 4.4, 'minFemale': 2.3, 'maxFemale': 4.2, 'startDay': 0, 'endDay': 30},
  // 30 days
  {'minMale': 3.5, 'maxMale': 5.8, 'minFemale': 3.2, 'maxFemale': 5.4, 'startDay': 31, 'endDay': 60},
  // 60 days
  {'minMale': 4.3, 'maxMale': 7.1, 'minFemale': 4.0, 'maxFemale': 6.5, 'startDay': 61, 'endDay': 90},
  // 3 months (~91–120 days)
  {'minMale': 5.0, 'maxMale': 8.0, 'minFemale': 4.6, 'maxFemale': 7.4, 'startDay': 91, 'endDay': 120},
  // 4 months (~121–150 days)
  {'minMale': 5.5, 'maxMale': 8.8, 'minFemale': 5.0, 'maxFemale': 8.1, 'startDay': 121, 'endDay': 150},
  // 5 months (~151–180 days)
  {'minMale': 5.8, 'maxMale': 9.3, 'minFemale': 5.3, 'maxFemale': 8.7, 'startDay': 151, 'endDay': 180},
  // 6 months (~181–210 days)
  {'minMale': 6.1, 'maxMale': 9.8, 'minFemale': 5.6, 'maxFemale': 9.2, 'startDay': 181, 'endDay': 210},
  // 7 months (~211–240 days)
  {'minMale': 6.3, 'maxMale': 10.2, 'minFemale': 5.8, 'maxFemale': 9.6, 'startDay': 211, 'endDay': 240},
  // 8 months (~241–270 days)
  {'minMale': 6.5, 'maxMale': 10.6, 'minFemale': 6.0, 'maxFemale': 10.0, 'startDay': 241, 'endDay': 270},
  // 9 months (~271–300 days)
  {'minMale': 6.7, 'maxMale': 10.9, 'minFemale': 6.2, 'maxFemale': 10.4, 'startDay': 271, 'endDay': 300},
  // 10 months (~301–330 days)
  {'minMale': 6.9, 'maxMale': 11.2, 'minFemale': 6.4, 'maxFemale': 10.7, 'startDay': 301, 'endDay': 330},
  // 11 months (~331–360 days)
{'minMale': 7.0, 'maxMale': 11.5, 'minFemale': 6.5, 'maxFemale': 11.0, 'startDay': 331, 'endDay': 360},
// 12 months (~361–390 days)
{'minMale': 7.1, 'maxMale': 11.8, 'minFemale': 6.6, 'maxFemale': 11.3, 'startDay': 361, 'endDay': 390},
// 13 months (~391–420 days)
{'minMale': 7.3, 'maxMale': 12.0, 'minFemale': 6.8, 'maxFemale': 11.6, 'startDay': 391, 'endDay': 420},
// 14 months (~421–450 days)
{'minMale': 7.4, 'maxMale': 12.3, 'minFemale': 6.9, 'maxFemale': 11.8, 'startDay': 421, 'endDay': 450},
// 15 months (~451–480 days)
{'minMale': 7.5, 'maxMale': 12.7, 'minFemale': 7.0, 'maxFemale': 12.0, 'startDay': 451, 'endDay': 480},
// 16 months (~481–510 days)
{'minMale': 7.7, 'maxMale': 12.9, 'minFemale': 7.1, 'maxFemale': 12.3, 'startDay': 481, 'endDay': 510},
// 17 months (~511–540 days)
{'minMale': 7.8, 'maxMale': 13.2, 'minFemale': 7.2, 'maxFemale': 12.5, 'startDay': 511, 'endDay': 540},
// 18 months (~541–570 days)
{'minMale': 7.9, 'maxMale': 13.5, 'minFemale': 7.4, 'maxFemale': 12.7, 'startDay': 541, 'endDay': 570},
// 19 months (~571–600 days)
{'minMale': 8.0, 'maxMale': 13.7, 'minFemale': 7.5, 'maxFemale': 12.9, 'startDay': 571, 'endDay': 600},
// 20 months (~601–630 days)
{'minMale': 8.2, 'maxMale': 13.9, 'minFemale': 7.6, 'maxFemale': 13.1, 'startDay': 601, 'endDay': 630},
// 21 months (~631–660 days)
{'minMale': 8.3, 'maxMale': 14.2, 'minFemale': 7.8, 'maxFemale': 13.4, 'startDay': 631, 'endDay': 660},
// 22 months (~661–690 days)
{'minMale': 8.5, 'maxMale': 14.5, 'minFemale': 7.9, 'maxFemale': 13.6, 'startDay': 661, 'endDay': 690},
// 23 months (~691–720 days)
{'minMale': 8.6, 'maxMale': 14.7, 'minFemale': 8.0, 'maxFemale': 13.8, 'startDay': 691, 'endDay': 720},
// 24 months (~721–750 days)
{'minMale': 8.7, 'maxMale': 14.9, 'minFemale': 8.1, 'maxFemale': 14.1, 'startDay': 721, 'endDay': 750},
];


    // Find the correct range for the age
    final range = weightRanges.firstWhere(
      (r) => ageInDays >= r['startDay']! && ageInDays <= r['endDay']!,
      orElse: () => {},
    );

    if (range.isEmpty) return null; // No rules for this age

    final min = (gender == 'male') ? range['minMale']! : range['minFemale']!;
    final max = (gender == 'male') ? range['maxMale']! : range['maxFemale']!;

    if (weight < min) return 'Poids trop faible pour cet âge et sexe';
    if (weight > max) return 'Poids trop élevé pour cet âge et sexe';

    return null; // ✅ Normal
  }
}
