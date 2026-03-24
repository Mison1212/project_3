import 'package:cloud_firestore/cloud_firestore.dart';

class JobModel {
  final String id;
  final String providerId;    // Relasi ke Master Provider
  final String categoryId;    // Relasi ke Master Category untuk fitur Search
  final String title;         // Judul Loker (Target Search)
  final String description;
  final String location;      // Lokasi di Papua
  final DateTime createdAt;
  final int salary;

  JobModel({
    required this.id,
    required this.providerId,
    required this.categoryId,
    required this.title,
    required this.description,
    required this.location,
    required this.createdAt,
    required this.salary,
  });

  // Untuk konversi data dari Firestore (Map) ke Object Flutter
  factory JobModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return JobModel(
      id: doc.id,
      providerId: data['provider_id'] ?? '',
      categoryId: data['category_id'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      location: data['location'] ?? '',
      createdAt: (data['created_at'] as Timestamp).toDate(),
      salary: data['salary'] ?? 0,
    );
  }

  // Untuk menyimpan/update ke Firestore
  Map<String, dynamic> toMap() {
    return {
      'provider_id': providerId,
      'category_id': categoryId,
      'title': title,
      'description': description,
      'location': location,
      'created_at': Timestamp.fromDate(createdAt),
      'salary': salary,
    };
  }
}