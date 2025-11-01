import 'package:flutter/material.dart';
import '../widgets/app_day_item.dart';
import '../widgets/app_babycard_item.dart';  

class BabyDayPicker extends StatefulWidget {
  const BabyDayPicker({super.key});

  @override
  State<BabyDayPicker> createState() => _BabyDayPickerState();
}

class _BabyDayPickerState extends State<BabyDayPicker> {
  int selectedIndex = 0;

  final List<DayData> daysData = [
    DayData(title: "L’importance du lait maternel les premiers mois", imageUrl: "https://cdn.pixabay.com/photo/2023/06/11/14/38/baby-8056153_640.jpg"),
    DayData(title: "Lundi 19 - Baby Nutrition", imageUrl: "https://cdn.pixabay.com/photo/2016/03/05/13/06/bebe-1237704_1280.jpg"),
    DayData(title: "Mardi 20 - Baby Sleep", imageUrl: "https://cdn.pixabay.com/photo/2024/05/26/10/15/bird-8788491_1280.jpg"),
    DayData(title: "Mercredi 21 - L’importance Du Lait Maternel", imageUrl: "https://img.freepik.com/free-photo/woman-beach-with-her-baby-enjoying-sunset_52683-144131.jpg?size=626&ext=jpg"),
    DayData(title: "Jeudi 22 - Baby Care Tips", imageUrl: "https://cdn.pixabay.com/photo/2016/01/20/11/11/baby-1151351_1280.jpg"),
    DayData(title: "Vendredi 23 - Baby Health", imageUrl: "https://wordtracker-swoop-uploads.s3.amazonaws.com/uploads/ckeditor/pictures/2090/content_beach.jpg"),
    DayData(title: "Samedi 24 - Baby Games", imageUrl: "https://static.vecteezy.com/system/resources/thumbnails/026/311/776/small/cheerful-baby-in-white-clothes-lying-on-bed-and-looking-at-camera-ai-generate-free-photo.jpg"),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Use the new BabyDayCard
        BabyDayCard(
          title: daysData[selectedIndex].title,
          imageUrl: daysData[selectedIndex].imageUrl,
        ),
  const SizedBox(height: 20),
        // Horizontal day picker
// Horizontal day picker, fully centered
SingleChildScrollView(
  scrollDirection: Axis.horizontal,
  child: Row(
    mainAxisAlignment: MainAxisAlignment.center, // <-- center items horizontally
    children: List.generate(daysData.length, (index) {
      final isSelected = selectedIndex == index;
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 1),
        child: DayItem(
          day: getDayName(index),
          number: getDayNumber(index),
          isSelected: isSelected,
          onTap: () => setState(() => selectedIndex = index),
        ),
      );
    }),
  ),
),

      ],
    );
  }

  String getDayName(int index) {
    const names = ["Dim", "Lun", "Mar", "Mer", "Jeu", "Ven", "Sam"];
    return names[index % names.length];
  }

  String getDayNumber(int index) {
    const numbers = ["18", "19", "20", "21", "22", "23", "24"];
    return numbers[index % numbers.length];
  }
}

class DayData {
  final String title;
  final String imageUrl;
  DayData({required this.title, required this.imageUrl});
}
