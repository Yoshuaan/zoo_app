// lib/screens/login_screen.dart
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import '../services/hive_service.dart';
import 'home_screen.dart';
import 'register_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  String _message = '';

  ///  Fungsi hashing password
  String hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }

  ///  Fungsi login
  Future<void> login() async {
    String username = _usernameController.text.trim();
    String password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      setState(() => _message = "Username dan password tidak boleh kosong");
      return;
    }

    // Ambil user berdasarkan username
    final user = HiveService.getUserByUsername(username);

    if (user == null) {
      setState(() => _message = "Username tidak ditemukan");
      return;
    }

    // Cek password hash
    String hashed = hashPassword(password);
    if (user['password'] == hashed) {
      // Simpan session login
      await HiveService.saveSession(true);
      await HiveService.saveToSession('username', username);

      // Jika user punya email, simpan juga ke session
      if (user.containsKey('email')) {
        await HiveService.saveToSession('email', user['email']);
      } else {
        await HiveService.saveToSession('email', 'Tidak tersedia');
      }

      // Debug: cek session
      print('Login berhasil untuk $username');
      print('Session username: ${HiveService.getSessionValue('username')}');
      print('Session email: ${HiveService.getSessionValue('email')}');

      // Navigasi ke HomePage
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    } else {
      setState(() => _message = "Password salah");
    }
  }

  @override
  Widget build(BuildContext context) {
    final darkColor = const Color(0xFF432323);
    final mediumColor = const Color(0xFF2F5755);
    final accentColor = const Color(0xFF5A9690);
    final lightColor = const Color(0xFFE0D9D9);

    return Scaffold(
      backgroundColor: darkColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ==== HEADER GAMBAR ====
            ClipPath(
              clipper: _CurvedClipper(),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.45,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      'https://images.unsplash.com/photo-1538099130811-745e64318258?auto=format&fit=crop&q=60&w=600',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  color: Colors.black.withOpacity(0.4),
                  child: Center(
                    child: Text(
                      "Welcome to Zoo App",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // ==== FORM LOGIN ====
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
              decoration: BoxDecoration(
                color: mediumColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(40),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Login",
                    style: TextStyle(
                      color: lightColor,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 25),
                  _buildTextField(
                    controller: _usernameController,
                    label: "Username",
                    icon: Icons.person_outline,
                    color: accentColor,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _passwordController,
                    label: "Password",
                    icon: Icons.lock_outline,
                    color: accentColor,
                    obscure: true,
                  ),
                  const SizedBox(height: 25),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentColor,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      shadowColor: Colors.black45,
                      elevation: 6,
                    ),
                    onPressed: login,
                    child: const Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const RegisterPage()),
                      );
                    },
                    child: Text(
                      "Belum punya akun? Daftar",
                      style: TextStyle(
                        color: lightColor.withOpacity(0.9),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (_message.isNotEmpty)
                    Text(
                      _message,
                      style: const TextStyle(color: Colors.redAccent),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔧 Widget untuk TextField konsisten
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required Color color,
    bool obscure = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
        prefixIcon: Icon(icon, color: color),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: color.withOpacity(0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: color, width: 2),
        ),
      ),
    );
  }
}

/// ==== CLIPPER UNTUK POTONGAN ELEGAN GAMBAR ====
class _CurvedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 60);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 60,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
