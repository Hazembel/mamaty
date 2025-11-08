import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../widgets/app_top_bar_text.dart';
import '../widgets/app_top_bar_search.dart';
import '../widgets/app_doctor_card.dart';
import '../theme/colors.dart';
 
import '../services/doctor_service.dart';
import '../pages/doctor_details_page.dart';
import '../models/doctor.dart';
import '../widgets/filter_modal.dart';
 
class DoctorsPage extends StatefulWidget {
  final String title;
  final String searchPlaceholder;
  final VoidCallback? onBack;

  const DoctorsPage({
    super.key,
    this.title = 'Meilleurs médecins',
    this.searchPlaceholder = 'Rechercher un médecin',
    this.onBack,
  });

  @override
  State<DoctorsPage> createState() => _DoctorsPageState();
}

class _DoctorsPageState extends State<DoctorsPage> {
  List<Doctor> _allDoctors = [];
  List<Doctor> _filteredDoctors = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDoctors();
  }

  Future<void> _loadDoctors({String? city, String? specialty, double? rating}) async {
    setState(() => _isLoading = true);

    try {
      final doctors = await DoctorService.getDoctors(
        city: city,
        specialty: specialty,
        rating: rating,
      );

      setState(() {
        _allDoctors = doctors;
        _filteredDoctors = doctors;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('❌ Error loading doctors: $e');
      setState(() => _isLoading = false);
    }
  }

  void _filterDoctors(String query) {
    setState(() {
      _filteredDoctors = _allDoctors
          .where((doctor) => doctor.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _openDoctorDetails(Doctor doctor) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DoctorDetailsPage(doctor: doctor),
      ),
    );
  }

  /// 🧩 Open filter modal and fetch filtered data from API
  Future<void> _openFilterModal() async {
    try {
      final filters = await DoctorService.getFilters();

      if (!mounted) return;
      final result = await FilterModal.show(
        context,
        allcity: filters['cities'] ?? [],
        allSpecialties: filters['specialties'] ?? [],
      );

      if (result != null) {
        await _loadDoctors(
          city: result.city.isNotEmpty ? result.city.first : null,
          specialty: result.specialties.isNotEmpty ? result.specialties.first : null,
          rating: result.rating > 0 ? result.rating : null,
        );
      }
    } catch (e) {
      if (!mounted) return;
      debugPrint('❌ Failed to load filters: $e');
      
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding:EdgeInsets.symmetric(horizontal: 20, vertical: 0),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppTopBarText(
                      title: widget.title,
                      onBack: widget.onBack ??
                          () {
                            if (Navigator.canPop(context)) Navigator.pop(context);
                          },
                    ),
                    const SizedBox(height: 15),
                    AppSearchInput(
                      searchText: widget.searchPlaceholder,
                      onChanged: _filterDoctors,
                      onFilterTap: _openFilterModal,
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
              ),

              // 🔹 Doctors Grid or shimmer
              _isLoading
                  ? SliverPadding(
                      padding: const EdgeInsets.only(top: 10),
                      sliver: SliverGrid.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 10,
                          childAspectRatio: 160 / 180,
                        ),
                        itemCount: 6,
                        itemBuilder: (_, __) {
                          return Shimmer.fromColors(
                            baseColor: Colors.grey.shade300,
                            highlightColor: Colors.grey.shade100,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  : _filteredDoctors.isEmpty
                      ? SliverFillRemaining(
                          hasScrollBody: false,
                          child: const Center(
                            child: Text('Aucun médecin trouvé.'),
                          ),
                        )
                      : SliverPadding(
                          padding: const EdgeInsets.only(bottom: 20),
                          sliver: SliverGrid.builder(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 15,
                              mainAxisSpacing: 10,
                              childAspectRatio: 160 / 180,
                            ),
                            itemCount: _filteredDoctors.length,
                            itemBuilder: (context, index) {
                              final doctor = _filteredDoctors[index];
                              return GestureDetector(
                                onTap: () => _openDoctorDetails(doctor),
                                child: DoctorCard(
                                  doctorName: doctor.name,
                                  specialty: doctor.specialty,
                                  rating: doctor.rating,
                                  city: doctor.city,
                                  imageUrl: doctor.imageUrl,
                                ),
                              );
                            },
                          ),
                        ),
            ],
          ),
        ),
      ),
    );
  }
}
