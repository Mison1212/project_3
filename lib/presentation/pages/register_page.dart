import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;
  
  // Controller untuk input data
  final _nameController = TextEditingController();
  final _originController = TextEditingController(); // Asal Kabupaten di Papua
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  bool _isLoading = false;

  void _handleRegister() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email dan Password tidak boleh kosong")),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      // 1. Daftarkan akun ke Firebase Auth
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // 2. Simpan detail profil ke Firestore (Tabel Master Users)
      await _db.collection('users').doc(credential.user!.uid).set({
        'uid': credential.user!.uid,
        'full_name': _nameController.text.trim(),
        'origin': _originController.text.trim(),
        'email': _emailController.text.trim(),
        'role': 'user',
        'created_at': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Registrasi Berhasil! Silakan Login.")),
        );
        Navigator.pop(context); // Kembali ke halaman Login
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "Gagal mendaftar")),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Daftar Akun Baru")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Icon(Icons.person_add_alt_1_rounded, size: 80, color: Colors.blue),
            const SizedBox(height: 20),
            
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Nama Lengkap", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            
            TextField(
              controller: _originController,
              decoration: const InputDecoration(labelText: "Asal Kabupaten (Papua)", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Email", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Password", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 24),
            
            _isLoading
                ? const CircularProgressIndicator()
                : SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _handleRegister,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade900, foregroundColor: Colors.white),
                      child: const Text("DAFTAR SEKARANG"),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}