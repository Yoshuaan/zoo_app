// lib/screens/search_screen.dart
import 'package:flutter/material.dart';
import '../services/api_service.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;
  List<dynamic> _results = [];

  Future<void> searchAnimal(String query) async {
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
      _results = [];
    });

    try {
      final data = await ApiService.searchAnimal(query);
      setState(() {
        _results = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal mengambil data: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF432323), Color(0xFF2F5755)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Text(
                "Zoo Explorer Search 🐾",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE0D9D9),
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 20),

              // Search bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0D9D9).withOpacity(0.95),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          style: const TextStyle(color: Color(0xFF432323)),
                          decoration: const InputDecoration(
                            hintText:
                                'Cari hewan (misal: cheetah, lion, tiger)',
                            hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 15,
                            ),
                            prefixIcon: Icon(Icons.search, color: Colors.grey),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(right: 8),
                        child: ElevatedButton(
                          onPressed: () =>
                              searchAnimal(_controller.text.trim()),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF5A9690),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 14,
                            ),
                          ),
                          child: const Text(
                            "Cari",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Loading indicator
              if (_isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(40),
                    child: CircularProgressIndicator(color: Color(0xFFE0D9D9)),
                  ),
                ),

              // Hasil pencarian
              if (!_isLoading)
                Expanded(
                  child: _results.isNotEmpty
                      ? ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: _results.length,
                          itemBuilder: (context, index) {
                            final animal = _results[index];
                            final taxonomy = animal['taxonomy'] ?? {};
                            final characteristics =
                                animal['characteristics'] ?? {};

                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFFE0D9D9,
                                ).withOpacity(0.95),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.15),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      animal['name'] ?? 'Tidak diketahui',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF2F5755),
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      taxonomy['scientific_name'] ??
                                          'Nama ilmiah tidak diketahui',
                                      style: const TextStyle(
                                        fontStyle: FontStyle.italic,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      " Habitat: ${characteristics['habitat'] ?? '-'}",
                                      style: const TextStyle(
                                        color: Color(0xFF432323),
                                      ),
                                    ),
                                    Text(
                                      " Diet: ${characteristics['diet'] ?? '-'}",
                                      style: const TextStyle(
                                        color: Color(0xFF432323),
                                      ),
                                    ),
                                    Text(
                                      " Umur: ${characteristics['lifespan'] ?? '-'}",
                                      style: const TextStyle(
                                        color: Color(0xFF432323),
                                      ),
                                    ),
                                    Text(
                                      " Berat: ${characteristics['weight'] ?? '-'}",
                                      style: const TextStyle(
                                        color: Color(0xFF432323),
                                      ),
                                    ),
                                    Text(
                                      " Kecepatan: ${characteristics['top_speed'] ?? '-'}",
                                      style: const TextStyle(
                                        color: Color(0xFF432323),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    if (characteristics['slogan'] != null)
                                      Text(
                                        " \"${characteristics['slogan']}\"",
                                        style: const TextStyle(
                                          fontStyle: FontStyle.italic,
                                          color: Colors.grey,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        )
                      : const Center(
                          child: Text(
                            "Masukkan nama hewan untuk mencari informasi",
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFFE0D9D9),
                              fontFamily: 'Nunito',
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
