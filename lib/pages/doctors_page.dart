import 'package:flutter/material.dart';
import '../widgets/app_top_bar_text.dart';
import '../widgets/app_top_bar_search.dart';
import '../widgets/app_doctor_card.dart';
import '../theme/colors.dart';
import '../theme/dimensions.dart';
import '../services/doctor_service.dart';

class DoctorsPage extends StatefulWidget {
  final String title;
  final String searchPlaceholder;
  final VoidCallback? onBack;
  final VoidCallback? onFilterTap;

  const DoctorsPage({
    super.key,
    this.title = 'Meilleurs médecins',
    this.searchPlaceholder = 'Rechercher un médecin',
    this.onBack,
    this.onFilterTap,
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

  void _showDoctorMessage(String doctorName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Doctor $doctorName was clicked!'),
        duration: const Duration(seconds: 2),
      ),
    );
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
                onBack: widget.onBack,
              ),
              const SizedBox(height: 15),
              AppSearchInput(
                searchText: widget.searchPlaceholder,
                onChanged: _filterDoctors,
                onFilterTap: widget.onFilterTap,
              ),
              const SizedBox(height: 15),

              // 🔄 Loading indicator or content
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : GridView.builder(
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
                            onTap: () =>
                                _showDoctorMessage(doctor['name'] as String),
                            child: DoctorCard(
                              doctorName: doctor['name'] as String,
                              specialty: doctor['specialty'] as String,
                              rating: doctor['rating'] as double,
                              distance: doctor['distance'] as String,
                              imageUrl: doctor['imageUrl'] as String,
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
