import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';
import '../widgets/app_button.dart';
import '../widgets/filter_chip_box.dart'; // ✅ new reusable chip widget

class FilterModalResult {
  final List<String> city;
  final double rating;
  final List<String> specialties;

  FilterModalResult({
    required this.city,
    required this.rating,
    required this.specialties,
  });
}

class FilterModal extends StatefulWidget {
  final List<String> allcity;
  final List<String> allSpecialties;
  final List<String>? initialcity;
  final double? initialRating;
  final List<String>? initialSpecialties;

  const FilterModal({
    super.key,
    required this.allcity,
    required this.allSpecialties,
    this.initialcity,
    this.initialRating,
    this.initialSpecialties,
  });

  static Future<FilterModalResult?> show(
    BuildContext context, {
    required List<String> allcity,
    required List<String> allSpecialties,
    List<String>? initialcity,
    double? initialRating,
    List<String>? initialSpecialties,
  }) {
    return showModalBottomSheet<FilterModalResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.3),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: FilterModal(
            allcity: allcity,
            allSpecialties: allSpecialties,
            initialcity: initialcity,
            initialRating: initialRating,
            initialSpecialties: initialSpecialties,
          ),
        );
      },
    );
  }

  @override
  State<FilterModal> createState() => _FilterModalState();
}

class _FilterModalState extends State<FilterModal> {
  late List<String> selectedcity;
  late double selectedRating;
  late List<String> selectedSpecialties;

  @override
  void initState() {
    super.initState();
    selectedcity = List.from(widget.initialcity ?? []);
    selectedRating = widget.initialRating ?? 0.0;
    selectedSpecialties = List.from(widget.initialSpecialties ?? []);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 6),
              Center(
                child: Text(
                  'Filtrer La Recherche',
                  style: AppTextStyles.inter16SemiBold.copyWith(fontSize: 16),
                ),
              ),
              const SizedBox(height: 16),

              // 🌍 city
              Text(
                'Pays',
                style: AppTextStyles.inter14Med.copyWith(color: AppColors.black),
              ),
              const SizedBox(height: 8),
              Wrap(
                children: widget.allcity.map((country) {
                  final selected = selectedcity.contains(country);
                  return FilterChipBox(
                    label: country,
                    selected: selected,
                    onTap: () {
                      setState(() {
                        if (selected){
                          selectedcity.remove(country);
                        }
                        else
                        {
                          selectedcity.add(country);
                        }
                      });
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: 12),

              // ⭐ Rating
              Text(
                'Taux',
                style: AppTextStyles.inter14Med.copyWith(color: AppColors.black),
              ),
              const SizedBox(height: 8),
              Wrap(
                children: [1, 2, 3, 4, 5].map((r) {
                  final double value = r.toDouble();
                  return FilterChipBox(
                    label: value.toStringAsFixed(1),
                    selected: selectedRating == value,
                    isRating: true,
                    onTap: () => setState(() => selectedRating = value),
                  );
                }).toList(),
              ),

              const SizedBox(height: 12),

              // 🩺 Specialties
              Text(
                'Spécialité',
                style: AppTextStyles.inter14Med.copyWith(color: AppColors.black),
              ),
              const SizedBox(height: 8),
              Wrap(
                children: widget.allSpecialties.map((s) {
                  final selected = selectedSpecialties.contains(s);
                  return FilterChipBox(
                    label: s,
                    selected: selected,
                    onTap: () {
                      setState(() {
                        if (selected)
                        {
                          selectedSpecialties.remove(s); 
                          }
                        else
                        {
                          selectedSpecialties.add(s); 
                          }
                      });
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: 18),

              Center(
                child: AppButton(
                  title: 'Filtrer',
                  fullWidth: false,
                  size: ButtonSize.md,
                  onPressed: () {
                    Navigator.of(context).pop(
                      FilterModalResult(
                        city: selectedcity,
                        rating: selectedRating,
                        specialties: selectedSpecialties,
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
