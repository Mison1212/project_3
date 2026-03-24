import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Mendapatkan status user saat ini (untuk cek login/tidak)
  Stream<User?> get userStatus => _auth.authStateChanges();

  // Fungsi Login
  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return result.user;
    } on FirebaseAuthException catch (e) {
      // Menghasilkan error spesifik untuk ditampilkan di UI
      throw e.message ?? "Terjadi kesalahan saat login";
    }
  }

  // Fungsi Logout
  Future<void> signOut() async {
    await _auth.signOut();
  }
}