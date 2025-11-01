import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import '../services/hive_service.dart';
import 'login_screen.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  String _message = '';

  ///  Fungsi hashing password biar lebih aman
  String hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }

  ///  Fungsi untuk mendaftar akun baru
  Future<void> register() async {
    String username = _usernameController.text.trim();
    String password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      setState(() => _message = "Harap isi semua kolom");
      return;
    }

    // Cek apakah username sudah ada di Hive
    final existingUser = HiveService.getUserByUsername(username);
    if (existingUser != null) {
      setState(() => _message = "Username sudah terdaftar");
      return;
    }

    // Simpan user baru ke Hive
    final hashed = hashPassword(password);
    await HiveService.saveUser(username, hashed);

    setState(() => _message = "Pendaftaran berhasil!");

    // Tunggu sebentar lalu pindah ke halaman login
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color darkColor = const Color(0xFF432323);
    final Color mediumColor = const Color(0xFF2F5755);
    final Color accentColor = const Color(0xFF5A9690);
    final Color lightColor = const Color(0xFFE0D9D9);

    return Scaffold(
      backgroundColor: darkColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ==== BAGIAN ATAS GAMBAR ====
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
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.55),
                        Colors.transparent,
                        Colors.black.withOpacity(0.35),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "Create Your Zoo Account",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.95),
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // ==== FORM REGISTER ====
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
                    "Daftar Akun",
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
                    icon: Icons.person_add_alt_1_outlined,
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
                    onPressed: register,
                    child: const Text(
                      "Daftar",
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
                        MaterialPageRoute(builder: (_) => const LoginPage()),
                      );
                    },
                    child: Text(
                      "Sudah punya akun? Login",
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

  /// 🔧 Widget untuk textfield agar tampil konsisten
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
