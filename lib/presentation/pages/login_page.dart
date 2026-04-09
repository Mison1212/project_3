import 'package:flutter/material.dart';
import '../../data/repositories/auth_repository.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authRepo = AuthRepository();

  bool _isLoading = false;
  bool _isObscure = true;

  // Fungsi Helper untuk menampilkan SnackBar
  void _showNotif(String pesan, Color warna, IconData icon) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(pesan, style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
        backgroundColor: warna,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _handleLogin() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    // 1. Validasi Input (Tetap perlu agar tidak mengirim data kosong ke Firebase)
    if (email.isEmpty || password.isEmpty) {
      _showNotif(
        "Email dan Password harus diisi kaka!",
        Colors.orange,
        Icons.warning_amber_rounded,
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 2. Proses Login ke Firebase
      // Jika ini berhasil, StreamBuilder di main.dart akan langsung
      // memindahkan user ke HomePage secara otomatis.
      await _authRepo.signIn(email, password);

      // KITA KOSONGKAN DI SINI
      // Tidak ada _showNotif sukses agar tidak tabrakan dengan transisi halaman.
    } catch (e) {
      // 3. Logika Gagal
      // Jika kamu ingin benar-benar TIDAK ADA notifikasi merah sama sekali,
      // kamu bisa mengosongkan bagian catch ini atau cukup print di console untuk debug.
      debugPrint("Login gagal: $e");

      // Jika ingin tetap ada notifikasi HANYA saat gagal (salah password/email),
      // gunakan kode di bawah. Tapi jika ingin bersih total, hapus baris _showNotif ini:
    } finally {
      // 4. Matikan loading jika gagal
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo dengan Shadow
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'assets/icon/image.png',
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.business_center,
                      size: 80,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Pusat Karir Papua",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),

              // Field Email
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                  prefixIcon: Icon(Icons.email_outlined),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),

              // Field Password
              TextField(
                controller: _passwordController,
                obscureText: _isObscure,
                decoration: InputDecoration(
                  labelText: "Password",
                  prefixIcon: const Icon(Icons.lock_outline),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isObscure ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () => setState(() => _isObscure = !_isObscure),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Tombol Login / Loading
              _isLoading
                  ? const CircularProgressIndicator()
                  : Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _handleLogin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[900],
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              "MASUK",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (c) => const RegisterPage(),
                              ),
                            );
                          },
                          child: const Text("Belum punya akun? Daftar di sini"),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
