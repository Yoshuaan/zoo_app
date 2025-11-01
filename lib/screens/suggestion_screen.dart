import 'package:flutter/material.dart';

class SuggestionScreen extends StatelessWidget {
  const SuggestionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF432323), Color(0xFF2F5755)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Hero Image Zoo
              ClipPath(
                clipper: _WaveClipper(),
                child: Image.network(
                  "https://images.unsplash.com/photo-1538099130811-745e64318258?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTB8fHpvb3xlbnwwfHwwfHx8MA%3D%3D&auto=format&fit=crop&q=60&w=600",
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                ),
              ),

              // Konten utama dalam card
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Card(
                  color: const Color(0xFFE0D9D9).withOpacity(0.9),
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Center(
                          child: Text(
                            " Kesan & Pesan",
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2F5755),
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          "Sebagai pengembang aplikasi ini, saya ingin menyampaikan rasa terima kasih "
                          "kepada dosen dan rekan-rekan yang telah memberikan kesempatan untuk belajar "
                          "dan mengembangkan aplikasi berbasis Flutter.",
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            fontSize: 16,
                            height: 1.6,
                            color: Color(0xFF432323),
                            fontFamily: 'Nunito',
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          "Melalui proyek aplikasi kebun binatang ini, saya belajar banyak tentang cara "
                          "mengintegrasikan API, menyimpan data lokal menggunakan Hive, serta menerapkan sistem login "
                          "dengan enkripsi sederhana menggunakan SHA256.",
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            fontSize: 16,
                            height: 1.6,
                            color: Color(0xFF432323),
                            fontFamily: 'Nunito',
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          "Harapan saya, aplikasi ini dapat menjadi contoh sederhana bagaimana teknologi dapat digunakan "
                          "untuk memberikan edukasi tentang satwa dan konservasi alam kepada masyarakat luas. ",
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            fontSize: 16,
                            height: 1.6,
                            color: Color(0xFF432323),
                            fontFamily: 'Nunito',
                          ),
                        ),
                        SizedBox(height: 30),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "— Pengembang Aplikasi Zoo Explorer 🦁",
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontSize: 16,
                              color: Color(0xFF5A9690),
                              fontFamily: 'Poppins',
                            ),
                          ),
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
      ),
    );
  }
}

// Bentuk wave elegan untuk gambar header
class _WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 40);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 40,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
