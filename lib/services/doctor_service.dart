// lib/services/doctor_service.dart
import 'dart:async';
import '../data/doctors_data.dart';

class DoctorService {
  /// Simulate an API call (in the future, replace with a real one)
  Future<List<Map<String, dynamic>>> fetchDoctors() async {
    await Future.delayed(const Duration(milliseconds: 500)); // simulate network delay
    return doctorsData;
  }
}
