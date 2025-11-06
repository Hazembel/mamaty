import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../models/doctor.dart';
import '../services/doctor_service.dart';
import '../widgets/app_doctor_card.dart';
import '../widgets/row_see_more.dart';
import '../pages/doctor_details_page.dart';
import '../pages/doctors_page.dart';
import '../widgets/app_category_chip.dart';

class DoctorRow extends StatefulWidget {
  const DoctorRow({super.key});

  @override
  State<DoctorRow> createState() => _DoctorRowState();
}

class _DoctorRowState extends State<DoctorRow> {
  List<Doctor> _doctors = [];
  List<String> _specialties = [];
  String? _selectedSpecialty;
  bool _isLoading = true;
  bool _isLoadingFilters = true;

  @override
  void initState() {
    super.initState();
    _loadFilters();
    _loadDoctors();
  }

  /// 🩺 Load doctors (best or by specialty)
  Future<void> _loadDoctors({String? specialty}) async {
    setState(() => _isLoading = true);
    try {
      final doctors = await DoctorService.getDoctors(
        specialty: specialty,
        rating: specialty == null ? 4.0 : null, // ✅ only filter by rating when no specialty
      );
      setState(() {
        _doctors = doctors.take(10).toList();
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('❌ Error loading doctors: $e');
      setState(() => _isLoading = false);
    }
  }

  /// 🧠 Load specialties from filters
  Future<void> _loadFilters() async {
    try {
      final filters = await DoctorService.getFilters();
      setState(() {
        _specialties = List<String>.from(filters['specialties'] ?? []);
        _isLoadingFilters = false;
      });
    } catch (e) {
      debugPrint('❌ Error loading filters: $e');
      setState(() => _isLoadingFilters = false);
    }
  }

  void _openDoctorDetails(Doctor doctor) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DoctorDetailsPage(doctor: doctor)),
    );
  }

  void _openAllDoctors() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const DoctorsPage(title: 'Tous les médecins'),
      ),
    );
  }

  /// 💫 Shimmer skeleton for category chips
  Widget _buildChipSkeleton() {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemCount: 6,
        itemBuilder: (_, __) => Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            width: 80,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ),
    );
  }

  /// 💫 Shimmer skeleton for doctor cards
  Widget _buildSkeletonLoader() {
    return SizedBox(
      height: 200,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 4,
        separatorBuilder: (_, __) => const SizedBox(width: 15),
        itemBuilder: (context, index) => Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            width: 160,
            height: 190,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image placeholder
                Container(
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(18),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(height: 14, width: 80, color: Colors.grey.shade300),
                      const SizedBox(height: 6),
                      Container(height: 12, width: 60, color: Colors.grey.shade300),
                      const SizedBox(height: 6),
                      Container(height: 12, width: 40, color: Colors.grey.shade300),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔹 Title + "Tout voir"
          AppRowSeeMore(
            title: 'Meilleurs médecins',
            onSeeMore: _openAllDoctors,
          ),
          const SizedBox(height: 10),

          /// 🔹 Chips + doctor shimmer combined while loading
          if (_isLoadingFilters)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildChipSkeleton(),
                const SizedBox(height: 15),
                _buildSkeletonLoader(),
              ],
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 38,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemCount: _specialties.length,
                    itemBuilder: (context, index) {
                      final specialty = _specialties[index];
                      return AppCategoryChip(
                        label: specialty,
                        isSelected: _selectedSpecialty == specialty,
                        onTap: () {
                          setState(() {
                            if (_selectedSpecialty == specialty) {
                              _selectedSpecialty = null;
                              _loadDoctors(); // Show best doctors again
                            } else {
                              _selectedSpecialty = specialty;
                              _loadDoctors(specialty: specialty);
                            }
                          });
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 15),

                /// 🔹 Horizontal doctor cards
                if (_isLoading)
                  _buildSkeletonLoader()
                else if (_doctors.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text('Aucun médecin trouvé.'),
                  )
                else
                  SizedBox(
                    height: 200,
                    child: ListView.separated(
                      clipBehavior: Clip.none,
                      scrollDirection: Axis.horizontal,
                      itemCount: _doctors.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 15),
                      itemBuilder: (context, index) {
                        final doctor = _doctors[index];
                        return GestureDetector(
                          onTap: () => _openDoctorDetails(doctor),
                          child: SizedBox(
                            width: 160,
                            child: DoctorCard(
                              doctorName: doctor.name,
                              specialty: doctor.specialty,
                              rating: doctor.rating,
                              city: doctor.city,
                              imageUrl: doctor.imageUrl,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}
