import 'package:flutter/material.dart';
import '../widgets/app_top_bar_text.dart';
import '../widgets/app_top_bar_search.dart';
import '../widgets/app_doctor_card.dart';
import '../theme/colors.dart';
import '../theme/dimensions.dart';
import '../services/doctor_service.dart';
import '../pages/doctor_details_page.dart';
import '../models/doctor_data.dart';
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
  final DoctorService _doctorService = DoctorService();
  List<Map<String, dynamic>> _allDoctors = [];
  List<Map<String, dynamic>> _filteredDoctors = [];

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDoctors();
  }

  Future<void> _loadDoctors() async {
    final doctors = await _doctorService.fetchDoctors();
    setState(() {
      _allDoctors = doctors;
      _filteredDoctors = doctors;
      _isLoading = false;
    });
  }

  void _filterDoctors(String query) {
    setState(() {
      _filteredDoctors = _allDoctors
          .where((doctor) =>
              doctor['name'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  /// 🩺 Navigate to doctor details page
  void _openDoctorDetails(Map<String, dynamic> doctorData) {
    final doctor = Doctor(
      name: doctorData['name'],
      specialty: doctorData['specialty'],
      rating: doctorData['rating'],
      city: doctorData['city'],
      imageUrl: doctorData['imageUrl'],
      description: doctorData['description'],
      workTime: doctorData['workTime'],
      phone: doctorData['phone'],
      address: doctorData['address'],
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DoctorDetailsPage(doctor: doctor),
      ),
    );
  }

  /// 🧩 Show filter modal
  Future<void> _openFilterModal() async {
    final result = await FilterModal.show(
      context,
        allcity: [
      'Tunis',
      'Ariana',
      'Ben Arous',
      'Manouba',
      'Nabeul',
      'Zaghouan',
      'Bizerte',
      'Béja',
      'Jendouba',
      'Kef',
      'Siliana',
      'Sousse',
      'Monastir',
      'Mahdia',
      'Sfax',
      'Kairouan',
      'Kasserine',
      'Sidi Bouzid',
      'Gabès',
      'Medenine',
      'Tataouine',
      'Tozeur',
      'Kebili',
      'Gafsa',
    ], 
      allSpecialties: [
        'Cardiologue',
        'Dentiste',
        'Dermatologue',
        'Pédiatre',
        'Chirurgien'
      ],
    );

if (result != null) {
  debugPrint("🩺 Filter applied:");
  debugPrint("City: ${result.city}");
  debugPrint("Min rating: ${result.minRating}");
  debugPrint("Specialties: ${result.specialties}");

  setState(() {
    _filteredDoctors = _allDoctors.where((doctor) {
      final matchesCity =
          result.city.isEmpty || result.city.contains(doctor['city']);
      final matchesSpecialty =
          result.specialties.isEmpty || result.specialties.contains(doctor['specialty']);
      final matchesRating =
          result.minRating == 0.0 || doctor['rating'] >= result.minRating;

      return matchesCity && matchesSpecialty && matchesRating;
    }).toList();
  });
}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: AppDimensions.pagePadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTopBarText(
                title: widget.title,
                onBack: widget.onBack ??
                    () {
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      }
                    },
              ),
              const SizedBox(height: 15),

              /// 🔍 Search input with filter button
              AppSearchInput(
                searchText: widget.searchPlaceholder,
                onChanged: _filterDoctors,
                onFilterTap: _openFilterModal, // ✅ opens the filter modal
              ),

              const SizedBox(height: 15),

              /// 🧠 Doctors grid
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : GridView.builder(
                        clipBehavior: Clip.none, // ✅ allow shadow
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
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
                              doctorName: doctor['name'],
                              specialty: doctor['specialty'],
                              rating: doctor['rating'],
                              city: doctor['city'],
                              imageUrl: doctor['imageUrl'],
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
