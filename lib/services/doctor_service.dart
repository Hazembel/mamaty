import 'dart:convert';
import '../api/api_helper.dart';
import '../models/doctor.dart';

class DoctorService {
  /// ✅ Get all doctors (with optional filters)
  static Future<List<Doctor>> getDoctors({
    String? city,
    String? specialty,
    double? rating,
  }) async {
    // Build query parameters dynamically
    final queryParams = <String, String>{};

    if (city != null && city.isNotEmpty) queryParams['city'] = city;
    if (specialty != null && specialty.isNotEmpty) queryParams['specialty'] = specialty;
    if (rating != null && rating > 0) queryParams['rating'] = rating.toString();

    // Build full query string
   final queryString = queryParams.isEmpty
    ? ''
    : '?${Uri(queryParameters: queryParams).query}';

    // Fetch from API
    final response = await ApiHelper.get('/doctors$queryString');

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => Doctor.fromMap(item)).toList();
    } else {
      throw Exception('Failed to fetch doctors: ${response.statusCode}');
    }
  }

static Future<Map<String, List<String>>> getFilters() async {
  final response = await ApiHelper.get('/doctors/filters');

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return {
      'cities': List<String>.from(data['cities'] ?? []),
      'specialties': List<String>.from(data['specialties'] ?? []),
    };
  } else {
    throw Exception('Failed to fetch filters');
  }
}



  /// ✅ Get doctor by ID
  static Future<Doctor> getDoctorById(String id) async {
    final encodedId = Uri.encodeComponent(id);
    final response = await ApiHelper.get('/doctors/$encodedId');

    if (response.statusCode == 200) {
      return Doctor.fromMap(jsonDecode(response.body));
    } else if (response.statusCode == 404) {
      throw Exception('Doctor not found');
    } else {
      throw Exception('Failed to fetch doctor: ${response.statusCode}');
    }
  }

  /// ✅ Create doctor
  static Future<Doctor> createDoctor(Doctor doctor) async {
    final response = await ApiHelper.post('/doctors', doctor.toMap());
    if (response.statusCode == 201) {
      return Doctor.fromMap(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create doctor');
    }
  }

  /// ✅ Update doctor
  static Future<Doctor> updateDoctor(String doctorId, Map<String, dynamic> updates) async {
    final response = await ApiHelper.put('/doctors/$doctorId', updates);
    if (response.statusCode == 200) {
      return Doctor.fromMap(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update doctor');
    }
  }

  /// ✅ Delete doctor
  static Future<void> deleteDoctor(String doctorId) async {
    final response = await ApiHelper.delete('/doctors/$doctorId');
    if (response.statusCode != 200) {
      throw Exception('Failed to delete doctor');
    }
  }


 /// ✅ favorite doctor for the current user
// doctor_service.dart
static Future<bool> toggleFavoriteDoctor(String doctorId) async {
  final response = await ApiHelper.post('/users/favorite-doctor/$doctorId', {});
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['isFavorite']; // <-- backend returns the new state
  } else {
    throw Exception('Failed to toggle favorite doctor');
  }
}





}
