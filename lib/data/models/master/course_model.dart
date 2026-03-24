import 'package:cloud_firestore/cloud_firestore.dart';

class CourseModel {
  final String id;
  final String title;
  final String provider; // Penyelenggara (misal: Balai Latihan Kerja Jayapura)
  final String duration;
  final String level; // Pemula, Menengah, Mahir
  final String imageUrl;

  CourseModel({
    required this.id,
    required this.title,
    required this.provider,
    required this.duration,
    required this.level,
    required this.imageUrl,
  });

  factory CourseModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return CourseModel(
      id: doc.id,
      title: data['title'] ?? '',
      provider: data['provider'] ?? '',
      duration: data['duration'] ?? '',
      level: data['level'] ?? 'Pemula',
      imageUrl: data['image_url'] ?? 'https://via.placeholder.com/150',
    );
  }
}