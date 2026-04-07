import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // KONFIGURASI API (PASTIKAN IP SESUAI DENGAN LAPTOP)
  final String apiUrl = "http://192.168.100.69/papua_api/register_user.php";

  final _nameController = TextEditingController();
  final _originController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;

  Future<void> _handleRegister() async {
    if (_emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _nameController.text.isEmpty) {
      _showSnackBar("Semua kolom wajib diisi!", Colors.red);
      return;
    }

    setState(() => _isLoading = true);

    String? uid; // Simpan UID di luar blok try

    // TAHAP 1: FIREBASE
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      uid = credential.user?.uid;
    } catch (e) {
      // Jika error karena 'Pigeon' tapi user sebenarnya sudah login
      if (e.toString().contains('PigeonUserDetails')) {
        uid = _auth.currentUser?.uid; // Ambil UID dari user yang sudah login
      } else {
        _showSnackBar("Firebase Error: $e", Colors.red);
        setState(() => _isLoading = false);
        return;
      }
    }

    // TAHAP 2: MYSQL (Hanya jalan jika UID berhasil didapat)
    if (uid != null) {
      try {
        print("--- Mencoba Sinkronisasi MySQL ---");
        final response = await http.post(
          Uri.parse(apiUrl),
          body: {
            "uid": uid,
            "full_name": _nameController.text.trim(),
            "origin": _originController.text.trim(),
            "email": _emailController.text.trim(),
          },
        );

        print("Respon PHP: ${response.body}");

        if (response.statusCode == 200) {
          _showSnackBar(
            "Registrasi Berhasil ke Firebase & MySQL!",
            Colors.green,
          );
          if (mounted) Navigator.pop(context);
        }
      } catch (e) {
        print("Kesalahan MySQL: $e");
        _showSnackBar(
          "Registrasi Firebase Berhasil, tapi MySQL Gagal",
          Colors.orange,
        );
      }
    }

    if (mounted) setState(() => _isLoading = false);
  }

  void _showSnackBar(String pesan, Color warna) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(pesan),
        backgroundColor: warna,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Akun Papua Career"),
        backgroundColor: Colors.blue.shade900,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Icon(
              Icons.person_add_alt_1_rounded,
              size: 80,
              color: Colors.blue,
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "Nama Lengkap",
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _originController,
              decoration: const InputDecoration(
                labelText: "Asal Kabupaten (Papua)",
                prefixIcon: Icon(Icons.location_city),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: "Email",
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Password",
                prefixIcon: Icon(Icons.lock),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),
            _isLoading
                ? const CircularProgressIndicator()
                : SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: _handleRegister,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade900,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "DAFTAR SEKARANG",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
