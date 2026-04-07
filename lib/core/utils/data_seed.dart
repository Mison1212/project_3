import 'package:cloud_firestore/cloud_firestore.dart';

class DataSeed {
  static Future<void> uploadDummyData() async {
    final db = FirebaseFirestore.instance;

    // 1. Isi Data Lowongan (Tabel Jobs)
    await db.collection('jobs').add({
      'title': 'Junior Flutter Developer',
      'location': 'Jayapura, Papua',
      'salary': '7.500.000',
      'created_at': FieldValue.serverTimestamp(),
    });

    // 2. Isi Data Komunitas (Tabel Communities)
    await db.collection('communities').add({
      'name': 'Papua Tech Community',
      'description': 'Wadah belajar IT anak muda Jayapura.',
      'category': 'Teknologi',
      'member_count': 150,
    });

    // 3. Isi Data Pelatihan (Tabel Courses)
    await db.collection('courses').add({
      'title': 'Pelatihan Digital Marketing',
      'provider': 'BLK Provinsi Papua',
      'duration': '2 Minggu',
      'level': 'Pemula',
    });

    print("Data Master Berhasil Diupload!");
  }
}
