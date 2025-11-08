 
import '../models/doctor.dart';
import '../services/doctor_service.dart';
import 'package:flutter/widgets.dart';
class DoctorProvider extends ChangeNotifier {
  final List<Doctor> _doctors = [];
  bool _isLoading = false;
  String? _error;

  List<Doctor> get doctors => _doctors;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// ✅ Load all doctors (optionally filtered)
 Future<void> loadDoctors({
  String? city,
  String? specialty,
  double? rating,
}) async {
  if (_isLoading) return; // avoid duplicate fetch
  _isLoading = true;
  _error = null;

  // ❌ Avoid calling notifyListeners synchronously during build
  WidgetsBinding.instance.addPostFrameCallback((_) {
    notifyListeners();
  });

  try {
    final fetchedDoctors = await DoctorService.getDoctors(
      city: city,
      specialty: specialty,
      rating: rating,
    );

    debugPrint('🔹 Fetched ${fetchedDoctors.length} doctors from API');

    _doctors
      ..clear()
      ..addAll(fetchedDoctors);

    debugPrint('✅ Doctors loaded into provider: ${_doctors.length}');
  } catch (e) {
    _error = e.toString();
    debugPrint('❌ Error fetching doctors: $e');
  } finally {
    _isLoading = false;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }
}

  /// ✅ Refresh doctors manually (e.g. pull-to-refresh)
  Future<void> refreshDoctors() async {
    debugPrint('🔁 Refreshing doctors...');
    _doctors.clear();
    await loadDoctors();
  }

  /// ✅ Get doctor by ID
  Future<Doctor?> getDoctorById(String id) async {
    try {
      return await DoctorService.getDoctorById(id);
    } catch (e) {
      debugPrint('❌ Error fetching doctor by ID: $e');
      return null;
    }
  }

  /// ✅ Add new doctor
  Future<void> addDoctor(Doctor doctor) async {
    try {
      final newDoctor = await DoctorService.createDoctor(doctor);
      _doctors.insert(0, newDoctor); // newest first
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Error adding doctor: $e');
    }
  }

  /// ✅ Update doctor
  Future<void> updateDoctor(String doctorId, Map<String, dynamic> updates) async {
    try {
      final updatedDoctor = await DoctorService.updateDoctor(doctorId, updates);
      final index = _doctors.indexWhere((d) => d.id == updatedDoctor.id);
      if (index != -1) {
        _doctors[index] = updatedDoctor;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('❌ Error updating doctor: $e');
    }
  }

  /// ✅ Delete doctor
  Future<void> deleteDoctor(String doctorId) async {
    try {
      await DoctorService.deleteDoctor(doctorId);
      _doctors.removeWhere((d) => d.id == doctorId);
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Error deleting doctor: $e');
    }
  }

  /// ✅ Clear doctors (optional for logout or reset)
  void clear() {
    _doctors.clear();
    notifyListeners();
  }
}
