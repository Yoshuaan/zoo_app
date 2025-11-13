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
                          "kepada bapak bagus yang sudah memberikan saya kesempatan untuk belajar secara mandiri "
                          "dalam mengembangkan aplikasi anti tidur ini.",
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
                          "Pesan saya kalau boleh saya berharap pak bagus bisa lebih sering live coding di depan mahasiswa, "
                          "biar kami bisa lihat secara langsung implementasi sebuah teori itu bagaimana penerapanya "
                          "sekalian biar kami bisa cerita ke teman teman kami diluar bahwa dosen mobile kami itu ngodingnya spek dewa,heheh",
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
