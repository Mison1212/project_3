import 'package:cloud_firestore/cloud_firestore.dart';

class CommunityModel {
  final String id;
  final String name;
  final String description;
  final String category;
  final int memberCount;

  CommunityModel({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.memberCount,
  });

  factory CommunityModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return CommunityModel(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      category: data['category'] ?? 'Umum',
      memberCount: data['member_count'] ?? 0,
    );
  }
}