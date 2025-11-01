import 'package:flutter/material.dart';
import 'services/hive_service.dart';
import 'services/notification_service.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //  Inisialisasi Hive
  await HiveService.initHive();

  //  Inisialisasi Notifikasi
  await NotificationService.initNotifications();

  //  Jadwalkan notifikasi harian (misalnya jam 18:35 WIB)
  await NotificationService.scheduleDailyNotification(hour: 18, minute: 35);

  //  Cek status login
  bool isLoggedIn = HiveService.isLoggedIn();

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Zoo App',
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
      home: isLoggedIn ? const HomePage() : const LoginPage(),
    );
  }
}
