import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../services/hive_service.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _profileImage;
  late String username;

  @override
  void initState() {
    super.initState();
    username = HiveService.getActiveUsername();
    _loadProfileImageForUser();
  }

  /// Ambil foto berdasarkan username aktif
  Future<void> _loadProfileImageForUser() async {
    final profileData = HiveService.getProfile(username);
    final imagePath = profileData?['imagePath'];
    if (imagePath != null && File(imagePath).existsSync()) {
      setState(() => _profileImage = File(imagePath));
    } else {
      setState(() => _profileImage = null);
    }
  }

  /// Pilih gambar dan simpan ke Hive
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (pickedFile == null) return;

    final originalImage = File(pickedFile.path);
    final appDir = await getApplicationDocumentsDirectory();

    // Gunakan nama unik berdasarkan username
    final safeUsername = username.replaceAll(RegExp(r'[^\w\-]'), '_');
    final savedImagePath = '${appDir.path}/profile_$safeUsername.jpg';
    await originalImage.copy(savedImagePath);

    await HiveService.saveProfile(username, {'imagePath': savedImagePath});
    await _loadProfileImageForUser();
  }

  /// Hapus foto profil user
  Future<void> _removeProfileImage() async {
    final profileData = HiveService.getProfile(username);
    final imagePath = profileData?['imagePath'];

    if (imagePath != null) {
      final file = File(imagePath);
      if (file.existsSync()) await file.delete();
    }

    await HiveService.saveProfile(username, {'imagePath': null});
    setState(() => _profileImage = null);
  }

  /// Logout
  Future<void> _logout(BuildContext context) async {
    await HiveService.logout();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayName = HiveService.getSessionValue('username') ?? 'Guest';
    final email = HiveService.getSessionValue('email') ?? 'Tidak tersedia';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 30),

          // Foto profil
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.green[100],
                  backgroundImage: _profileImage != null
                      ? FileImage(_profileImage!)
                      : null,
                  child: _profileImage == null
                      ? const Icon(Icons.person, size: 70, color: Colors.green)
                      : null,
                ),
              ),
              if (_profileImage != null)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Row(
                    children: [
                      _smallCircleButton(
                        icon: Icons.delete,
                        color: Colors.redAccent,
                        onTap: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Hapus foto profil?'),
                              content: const Text(
                                'Apakah kamu yakin ingin menghapus foto profil ini?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: const Text('Batal'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text('Hapus'),
                                ),
                              ],
                            ),
                          );
                          if (confirm == true) await _removeProfileImage();
                        },
                      ),
                      const SizedBox(width: 8),
                      _smallCircleButton(
                        icon: Icons.camera_alt,
                        color: Colors.green,
                        onTap: _pickImage,
                      ),
                    ],
                  ),
                ),
            ],
          ),

          const SizedBox(height: 8),
          const Text(
            "Ketuk foto untuk mengubah",
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 20),

          // Username dan email
          Text(
            displayName,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Text(email, style: const TextStyle(fontSize: 16, color: Colors.grey)),

          const SizedBox(height: 30),

          // Info akun
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "📋 Informasi Akun",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text("Status: Pengguna Aktif"),
                  Text("Tipe Akun: Standard User"),
                  Text("Akses: Semua fitur aplikasi"),
                ],
              ),
            ),
          ),

          const SizedBox(height: 40),

          // Tombol Logout
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.logout, color: Colors.white),
              label: const Text(
                "Logout",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              onPressed: () => _logout(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _smallCircleButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        child: Icon(icon, color: Colors.white, size: 18),
      ),
    );
  }
}
