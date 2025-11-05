import 'package:flutter/foundation.dart';
import '../models/doctor.dart';
import '../services/doctor_service.dart';

class DoctorProvider extends ChangeNotifier {
  List<Doctor> _doctors = [];
  bool _isLoading = false;
  String? _error;

  List<Doctor> get doctors => _doctors;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// ✅ Load doctors (with optional filters)
  Future<void> fetchDoctors({
    String? city,
    String? specialty,
    double? rating,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await DoctorService.getDoctors(
        city: city,
        specialty: specialty,
        rating: rating,
      );
      _doctors = data;
    } catch (e) {
      _error = e.toString();
      debugPrint('❌ Error fetching doctors: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// ✅ Get a specific doctor (by ID)
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
      _doctors.add(newDoctor);
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Error adding doctor: $e');
    }
  }

  /// ✅ Update doctor
  Future<void> updateDoctor(String doctorId, Map<String, dynamic> updates) async {
    try {
      final updated = await DoctorService.updateDoctor(doctorId, updates);
      final index = _doctors.indexWhere((d) => d.name == updated.name);
      if (index != -1) {
        _doctors[index] = updated;
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
      _doctors.removeWhere((d) => d.name == doctorId);
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Error deleting doctor: $e');
    }
  }

  /// ✅ Clear doctors (optional for logout or refresh)
  void clear() {
    _doctors.clear();
    notifyListeners();
  }
}
