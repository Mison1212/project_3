import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/transaction/job_model.dart';

class JobRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<JobModel>> getJobs({int limit = 10, String searchQuery = ""}) async {
    try {
      Query query = _firestore.collection('jobs').orderBy('created_at', descending: true).limit(limit);

      // Logika pencarian sederhana
      if (searchQuery.isNotEmpty) {
        query = _firestore.collection('jobs')
            .where('title', isGreaterThanOrEqualTo: searchQuery)
            .where('title', isLessThanOrEqualTo: '$searchQuery\uf8ff')
            .limit(limit);
      }

      final snapshot = await query.get();
      return snapshot.docs.map((doc) => JobModel.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception("Gagal mengambil data lowongan: $e");
    }
  }
}