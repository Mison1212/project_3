// Contoh isi lib/data/models/master/user_model.dart
class UserModel {
  final String id;
  final String nama;
  final String asalPapua;

  UserModel({required this.id, required this.nama, required this.asalPapua});

  // Untuk konversi data dari Firestore (Map) ke Object Flutter
  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      id: data['id'] ?? '',
      nama: data['nama'] ?? '',
      asalPapua: data['asal_papua'] ?? '',
    );
  }
}