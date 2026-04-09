import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Fungsi Login dengan pengembalian error code
  Future<void> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      // WAJIB PAKAI THROW supaya ditangkap oleh 'catch' di LoginPage
      throw e.code;
    }
  }

  // Fungsi Logout untuk digunakan di HomePage nanti
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
