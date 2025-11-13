import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String apiUrl = 'https://api.api-ninjas.com/v1/animals';
  static const String apiKey = 'DpVExiLytRHJuwKC7ej7Ug==FiFy4Q6D8IUxCmBF';

  /// Fungsi untuk mencari hewan berdasarkan nama
  static Future<List<dynamic>> searchAnimal(String query) async {
    if (query.isEmpty) return [];

    final response = await http.get(
      Uri.parse('$apiUrl?name=$query'),
      headers: {'X-Api-Key': apiKey},
    );

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Gagal mengambil data (${response.statusCode})');
    }
  }
}
