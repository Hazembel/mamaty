import 'package:flutter/material.dart';
import '../models/advice.dart';
import '../widgets/app_day_item.dart';
import '../widgets/app_babycard_item.dart';
import '../pages/advice_detail_page.dart';
import 'package:intl/intl.dart';

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
  int selectedIndex = 3; // middle = today

  // Whenever babyAgeInDays changes, recalc visible advices
  List<Advice> get visibleAdvices {
    
    final filtered = widget.advices
        .where((advice) =>
            widget.babyAgeInDays >= (advice.minDay ?? 0) &&
            widget.babyAgeInDays <= (advice.maxDay ?? 9999))
        .toList();
  
    return filtered;
  }

  // 7-day offsets around today
  List<int> get dayOffsets => List.generate(7, (i) => i - 3);

  // Map each offset to a distinct advice in visibleAdvices
  Advice adviceForIndex(int index) {
    final advices = visibleAdvices;
    if (advices.isEmpty) {
      throw Exception('No advices available');
    }
    // Cycle through advices if less than 7
    return advices[index % advices.length];
  }

  @override
  void didUpdateWidget(covariant BabyDayPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reset selectedIndex when babyAgeInDays changes
    if (oldWidget.babyAgeInDays != widget.babyAgeInDays) {
      debugPrint('🔹 Baby age changed from ${oldWidget.babyAgeInDays} to ${widget.babyAgeInDays}');
      setState(() {
        selectedIndex = 3; // reset to middle (today)
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final advices = visibleAdvices;
    if (advices.isEmpty) return const Text('Aucun conseil disponible');

    final selectedAdvice = adviceForIndex(selectedIndex);

    return Column(
      children: [
        // Advice card
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
            imageUrl: selectedAdvice.imageUrl.isNotEmpty
                ? selectedAdvice.imageUrl.first
                : '',
          ),
        ),
        const SizedBox(height: 20),

        // Horizontal calendar
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(dayOffsets.length, (i) {
              final offset = dayOffsets[i];
              final dayDate = DateTime.now().add(Duration(days: offset));

              // Day name "Lun", "Mar"...
              String dayLabel = DateFormat.E('fr_FR').format(dayDate);
              dayLabel = dayLabel.replaceAll('.', '');
              dayLabel = dayLabel[0].toUpperCase() + dayLabel.substring(1);

              final dateLabel = DateFormat('dd').format(dayDate);

              final isSelected = i == selectedIndex;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1),
                child: DayItem(
                  day: dayLabel,
                  number: dateLabel,
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
