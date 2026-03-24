import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String id;
  final String title;
  final String message;
  final DateTime date;
  final String type; // 'job', 'course', atau 'info'

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.date,
    required this.type,
  });

  factory NotificationModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return NotificationModel(
      id: doc.id,
      title: data['title'] ?? '',
      message: data['message'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
      type: data['type'] ?? 'info',
    );
  }
}
