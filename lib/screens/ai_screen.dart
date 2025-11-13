import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AiScreen extends StatefulWidget {
  const AiScreen({super.key});

  @override
  State<AiScreen> createState() => _AiScreenState();
}

class _AiScreenState extends State<AiScreen> {
  final TextEditingController _controller = TextEditingController();
  String _response = '';
  bool _isLoading = false;

  final String _geminiApiKey = "AIzaSyCyPV-0VMBEHCLKWH7xLlZ4vTTs6I5qqLQ";

  Future<void> _askAI(String question) async {
    if (question.trim().isEmpty) return;

    setState(() {
      _isLoading = true;
      _response = "Sedang memproses pertanyaan kamu...";
    });

    try {
      final result = await _callGeminiAPI(question);
      setState(() {
        _response = result;
      });
    } catch (e) {
      setState(() {
        _response = "Terjadi kesalahan: $e";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<String> _callGeminiAPI(String question) async {
    final url = Uri.parse(
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$_geminiApiKey",
    );

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {"text": question},
              ],
            },
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["candidates"][0]["content"]["parts"][0]["text"];
      } else {
        return "Error ${response.statusCode}: ${response.body}";
      }
    } on TimeoutException {
      return "⏱️ Timeout: Server terlalu lama merespons.";
    } catch (e) {
      return "Error tak terduga: $e";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFE0D9D9),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Text(
                    _response.isEmpty
                        ? "Halo! Saya asisten AI Gemini. Tanyakan apa saja!"
                        : _response,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: 'Tulis pertanyaan Anda...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 16,
                    ),
                  ),
                  onSubmitted: (_) {
                    if (!_isLoading && _controller.text.trim().isNotEmpty) {
                      _askAI(_controller.text.trim());
                    }
                  },
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: (_isLoading || _controller.text.trim().isEmpty)
                    ? null
                    : () {
                        _askAI(_controller.text.trim());
                        FocusScope.of(context).unfocus();
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF432323),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(16),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.send_rounded, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
