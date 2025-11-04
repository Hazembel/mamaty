import 'package:flutter/material.dart';
import '../models/advice_model.dart';
import '../widgets/app_day_item.dart';
import '../widgets/app_babycard_item.dart';
import '../pages/advice_detail_page.dart'; // ✅ Create this page

class BabyDayPicker extends StatefulWidget {
  final List<Advice> advices;
  final int babyAgeInDays;

  const BabyDayPicker({
    super.key,
    required this.advices,
    required this.babyAgeInDays,
  });

  @override
  State<BabyDayPicker> createState() => _BabyDayPickerState();
}

class _BabyDayPickerState extends State<BabyDayPicker> {
  int selectedIndex = 0;

  List<Advice> get visibleAdvices {
    return widget.advices.where((advice) {
      final minDay = advice.minDay ?? 0;
      final maxDay = advice.maxDay ?? 9999;
      return widget.babyAgeInDays >= minDay &&
             widget.babyAgeInDays <= maxDay;
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    final advices = visibleAdvices;
    for (int i = 0; i < advices.length; i++) {
      if (advices[i].day != null && advices[i].day == widget.babyAgeInDays) {
        selectedIndex = i;
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final advices = visibleAdvices;
    if (advices.isEmpty) return const Text('Aucun conseil disponible');

    final selectedAdvice = advices[selectedIndex];

    return Column(
      children: [
        // ✅ Wrap BabyDayCard with GestureDetector
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AdviceDetailPage(advice: selectedAdvice),
              ),
            );
          },
          child: BabyDayCard(
            title: selectedAdvice.title,
            imageUrl: selectedAdvice.imageUrl,
          ),
        ),
        const SizedBox(height: 20),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(advices.length, (i) {
              final isSelected = i == selectedIndex;
              final dayNumber = advices[i].day ?? widget.babyAgeInDays.toString();
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: DayItem(
                  day: 'Jour',
                  number: dayNumber.toString(),
                  isSelected: isSelected,
                  onTap: () => setState(() => selectedIndex = i),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
