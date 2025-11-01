// lib/services/hive_service.dart
import 'dart:io';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class HiveService {
  static late Box usersBox;
  static late Box sessionBox;
  static late Box profileBox;

  /// 🔹 Inisialisasi Hive dan buka semua box
  static Future<void> initHive() async {
    final dir = await getApplicationDocumentsDirectory();
    if (!Hive.isBoxOpen('users')) {
      Hive.init(dir.path);
    }

    usersBox = await Hive.openBox('users');
    sessionBox = await Hive.openBox('session');
    profileBox = await Hive.openBox('profile');
  }

  /// 🔹 Simpan user baru
  static Future<void> saveUser(String username, String passwordHash) async {
    await usersBox.put(username, {
      'username': username,
      'password': passwordHash,
      'createdAt': DateTime.now().toIso8601String(),
    });
  }

  /// 🔹 Ambil user berdasarkan username (untuk multi-user login)
  static Map<String, dynamic>? getUserByUsername(String username) {
    final data = usersBox.get(username);
    if (data == null) return null;
    return Map<String, dynamic>.from(data);
  }

  /// 🔹 Ambil user pertama (untuk kasus hanya 1 akun, kompatibilitas lama)
  static Map<String, dynamic>? getUser() {
    if (usersBox.isEmpty) return null;
    final firstKey = usersBox.keys.first;
    final data = usersBox.get(firstKey);
    return Map<String, dynamic>.from(data);
  }

  /// 🔹 Simpan status login
  static Future<void> saveSession(bool isLoggedIn) async {
    await sessionBox.put('isLoggedIn', isLoggedIn);
  }

  /// 🔹 Simpan data tambahan ke session (misal username, email)
  static Future<void> saveToSession(String key, dynamic value) async {
    await sessionBox.put(key, value);
  }

  /// 🔹 Ambil nilai dari session
  static dynamic getSessionValue(String key) {
    return sessionBox.get(key);
  }

  /// 🔹 Cek status login
  static bool isLoggedIn() {
    return sessionBox.get('isLoggedIn', defaultValue: false);
  }

  /// 🔹 Ambil username aktif dari session
  static String getActiveUsername() {
    return sessionBox.get('username', defaultValue: '');
  }

  /// 🔹 Logout user (hapus session)
  static Future<void> logout() async {
    await sessionBox.clear();
  }

  /// 🔹 Reset semua data Hive (users, session, profile)
  static Future<void> clearAll() async {
    await usersBox.clear();
    await sessionBox.clear();
    await profileBox.clear();
  }

  /// 🔹 Simpan data profil user
  static Future<void> saveProfile(
    String username,
    Map<String, dynamic> profileData,
  ) async {
    await profileBox.put(username, profileData);
  }

  /// 🔹 Ambil data profil user
  static Map<String, dynamic>? getProfile(String username) {
    final data = profileBox.get(username);
    if (data == null) return null;
    return Map<String, dynamic>.from(data);
  }
}
