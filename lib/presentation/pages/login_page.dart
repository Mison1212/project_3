import 'package:flutter/material.dart';
import '../../data/repositories/auth_repository.dart';
import 'home_page.dart';
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
  bool _isObscure = true; // 👁 toggle password

  void _handleLogin() async {
    // 1. Validasi Input Kosong
    if (_emailController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Email dan Password harus diisi kaka!"),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _authRepo.signIn(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (mounted) {
        // 2. Notifikasi Berhasil (Hijau)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Mantap! Login Berhasil."),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 2),
          ),
        );

        // Pindah ke Halaman Home
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (c) => const HomePage()),
        );
      }
    } catch (e) {
      if (mounted) {
        // 3. Notifikasi Gagal (Merah)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Login Gagal: Periksa kembali email dan password ko.",
            ),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
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
              // 🔥 LOGO + SHADOW
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: const Offset(0, 5),
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
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // 🔥 TITLE
              const Text(
                "Pusat Karir Papua",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 40),

              // 🔹 EMAIL
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

              // 🔹 PASSWORD + ICON MATA 👁
              TextField(
                controller: _passwordController,
                obscureText: _isObscure,
                decoration: InputDecoration(
                  labelText: "Password",
                  prefixIcon: const Icon(Icons.lock),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isObscure ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // 🔹 BUTTON / LOADING
              _isLoading
                  ? const CircularProgressIndicator()
                  : Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _handleLogin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue, // Warna tombol
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

                        // 🔹 REGISTER
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
