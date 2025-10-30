import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/app_doctor_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  // A simple list to hold data for 6 doctor cards
  // This is a minimal representation to pass data to DoctorCard
  final List<Map<String, dynamic>> _doctorsData = [
    {
      "name": "Dr. Salma Ahmed",
      "specialty": "Gynécologie",
      "rating": 4.1,
      "distance": "4.2km away",
      "imageUrl": "https://via.placeholder.com/150/FF5733/FFFFFF?text=Dr1", // Placeholder
    },
    {
      "name": "Dr. Karim Zaki",
      "specialty": "Cardiologie",
      "rating": 4.5,
      "distance": "2.1km away",
      "imageUrl": "https://via.placeholder.com/150/33FF57/FFFFFF?text=Dr2", // Placeholder
    },
    {
      "name": "Dr. Layla Khan",
      "specialty": "Pédiatrie",
      "rating": 3.9,
      "distance": "6.8km away",
      "imageUrl": "https://via.placeholder.com/150/3357FF/FFFFFF?text=Dr3", // Placeholder
    },
    {
      "name": "Dr. Omar Farid",
      "specialty": "Dermatologie",
      "rating": 4.8,
      "distance": "1.5km away",
      "imageUrl": "https://via.placeholder.com/150/FF33A1/FFFFFF?text=Dr4", // Placeholder
    },
    {
      "name": "Dr. Nora Hassan",
      "specialty": "Neurologie",
      "rating": 4.2,
      "distance": "3.0km away",
      "imageUrl": "https://via.placeholder.com/150/A133FF/FFFFFF?text=Dr5", // Placeholder
    },
    {
      "name": "Dr. Tarek Youssef",
      "specialty": "Ophtalmologie",
      "rating": 4.0,
      "distance": "5.5km away",
      "imageUrl": "https://via.placeholder.com/150/33A1FF/FFFFFF?text=Dr6", // Placeholder
    },
  ];

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('login_token');
    await prefs.remove('login_phone');

    // Check if widget is still mounted before using context
    if (!mounted) return;

    Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
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
      appBar: AppBar(
        title: const Text('Accueil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Se déconnecter',
            onPressed: _logout,
          ),
        ],
      ),
      body: Padding( // Added padding for the grid
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 columns
            crossAxisSpacing: 15.0, // Spacing between columns
            mainAxisSpacing: 10.0, // Spacing between rows
            childAspectRatio: 160 / 180
          ),
          itemCount: _doctorsData.length, // Number of doctor cards
          itemBuilder: (context, index) {
            final doctor = _doctorsData[index];
            return GestureDetector(
              onTap: () => _showDoctorMessage(doctor['name'] as String),
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
    );
  }
}