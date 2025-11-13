import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hive/hive.dart';
import 'package:latlong2/latlong.dart';

import 'more_screen.dart';
import 'search_screen.dart';
import 'suggestion_screen.dart';
import 'profile_screen.dart';
import 'login_screen.dart';
import 'ai_screen.dart'; // ✅ Tambahan halaman AI Chat
import '../widgets/bottom_navbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  // ✅ Tambah halaman AiScreen di daftar _pages
  final List<Widget> _pages = const [
    HomeContent(),
    MoreScreen(),
    SearchScreen(),
    SuggestionScreen(),
    AiScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> logout(BuildContext context) async {
    var session = Hive.box('session');
    await session.clear();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Judul berdasarkan tab aktif
    final List<String> titles = [
      'Beranda',
      'Lainnya',
      'Cari Hewan',
      'Saran',
      'Profil',
      'AI Chat', // ✅ Tambahan
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFE0D9D9),
      appBar: AppBar(
        title: Text(titles[_selectedIndex]),
        backgroundColor: const Color(0xFF432323),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => logout(context),
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavbar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

// 🟢 Halaman Beranda
class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> topImages = [
      "https://images.unsplash.com/photo-1595363530143-b913b4ea30dd?auto=format&fit=crop&q=60&w=600",
      "https://images.unsplash.com/photo-1616869736815-3362745ab32d?auto=format&fit=crop&q=60&w=600",
      "https://images.unsplash.com/photo-1717507717678-fe8ec2485c02?auto=format&fit=crop&q=60&w=600",
      "https://images.unsplash.com/photo-1619989172648-7040c767e73a?auto=format&fit=crop&q=60&w=600",
    ];

    final List<Map<String, dynamic>> zooLocations = [
      {
        "name": "Gembira Loka Zoo (WIB)",
        "point": LatLng(-7.801389, 110.396389),
        "color": Colors.red,
      },
      {
        "name": "Bali Zoo (WITA)",
        "point": LatLng(-8.5889, 115.2794),
        "color": Colors.orange,
      },
      {
        "name": "Ambon City Park Zoo (WIT)",
        "point": LatLng(-3.695, 128.1814),
        "color": Colors.green,
      },
      {
        "name": "London Zoo (GMT)",
        "point": LatLng(51.5353, -0.1534),
        "color": Colors.blue,
      },
    ];

    return SingleChildScrollView(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE0D9D9), Color(0xFF5A9690)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),

            // 🐯 Hero Image
            SizedBox(
              height: 220,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: topImages.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      topImages[index],
                      fit: BoxFit.cover,
                      width: 300,
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 30),

            // 🌿 Discover Section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  Text(
                    "DISCOVER YOUR WILD SIDE",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF432323),
                      letterSpacing: 1.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Explore Indonesia’s incredible wildlife, meet rare animals, and learn about conservation efforts that protect our natural world.",
                    style: TextStyle(
                      fontSize: 15,
                      color: Color(0xFF2F5755),
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // 🦓 Our Work Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Card(
                elevation: 4,
                color: const Color(0xFFE0D9D9),
                shadowColor: const Color(0xFF432323).withOpacity(0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        "Our Work",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2F5755),
                        ),
                      ),
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          "https://media.istockphoto.com/id/2217349524/id/foto/guru-muda-berjalan-dan-berbicara-dengan-siswa-selama-kunjungan-lapangan-di-kebun-binatang.webp?a=1&b=1&s=612x612&w=0&k=20&c=DdJmIAJjbqgfsGTP8rEzN5IqCfTvqRfm4d6EsKUxOCY=",
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        "We dedicate our mission to wildlife preservation, education, and inspiring visitors to care for nature. Every visit supports conservation programs that make a difference.",
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 14.5,
                          color: Color(0xFF432323),
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),

            // 📍 Location Section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Location",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2F5755),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: SizedBox(
                  height: 300,
                  child: FlutterMap(
                    options: const MapOptions(
                      initialCenter: LatLng(0.0, 110.0),
                      initialZoom: 3.5,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                        subdomains: ['a', 'b', 'c'],
                      ),
                      MarkerLayer(
                        markers: zooLocations.map((zoo) {
                          return Marker(
                            point: zoo["point"],
                            width: 80,
                            height: 80,
                            child: Tooltip(
                              message: zoo["name"],
                              child: Icon(
                                Icons.location_on,
                                color: zoo["color"],
                                size: 45,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
