import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/models/master/notification_model.dart';
import 'package:intl/intl.dart'; // Pastikan sudah jalankan 'flutter pub add intl'

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // PERBAIKAN: Sebelumnya 'app_bar', seharusnya 'appBar' (A kecil, B besar)
      appBar: AppBar(title: const Text("Pusat Informasi")),
      body: StreamBuilder<QuerySnapshot>(
        // Mengambil data dari koleksi 'notifications' di Firestore
        stream: FirebaseFirestore.instance
            .collection('notifications')
            .orderBy('date', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          // 1. Cek status koneksi
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. Cek jika terjadi error (Penting untuk Bab IV)
          if (snapshot.hasError) {
            return Center(child: Text("Terjadi kesalahan: ${snapshot.error}"));
          }

          // 3. Cek jika data kosong
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_off_outlined,
                    size: 60,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 10),
                  Text("Belum ada informasi terbaru untukmu"),
                ],
              ),
            );
          }

          // 4. Tampilkan List jika data ada
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            padding: const EdgeInsets.all(12),
            itemBuilder: (context, index) {
              final info = NotificationModel.fromFirestore(
                snapshot.data!.docs[index],
              );

              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: _getIconColor(info.type).withOpacity(0.1),
                    child: Icon(
                      _getIcon(info.type),
                      color: _getIconColor(info.type),
                    ),
                  ),
                  title: Text(
                    info.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(info.message),
                  trailing: Text(
                    DateFormat('dd MMM').format(info.date),
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Fungsi pembantu untuk menentukan Icon berdasarkan tipe (Clean Code)
  IconData _getIcon(String type) {
    switch (type) {
      case 'job':
        return Icons.work_outline;
      case 'course':
        return Icons.school_outlined;
      default:
        return Icons.info_outline;
    }
  }

  // Fungsi pembantu untuk menentukan Warna berdasarkan tipe
  Color _getIconColor(String type) {
    switch (type) {
      case 'job':
        return Colors.blue.shade900;
      case 'course':
        return Colors.orange;
      default:
        return Colors.green;
    }
  }
}
