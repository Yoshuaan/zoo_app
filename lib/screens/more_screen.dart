import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  late Timer _timer;

  // controller untuk konversi uang
  final TextEditingController _amountController = TextEditingController();
  String _selectedCurrency = 'IDR';
  String _convertedCurrencyResult = '';

  // daftar kebun binatang dengan data yang benar
  final List<Map<String, dynamic>> _zoos = [
    {
      'name': 'Gembira Loka Zoo',
      'open': '08:00',
      'close': '16:30',
      'zone': 'WIB',
      'ticket': 'Rp 50.000 (Weekday) / Rp 60.000 (Weekend)',
      'location': 'Yogyakarta (WIB)',
      'image':
          'https://images.unsplash.com/photo-1750286602520-31f92bdfca62?ixlib=rb-4.1.0&auto=format&fit=crop&q=60&w=600',
    },
    {
      'name': 'Bali Zoo',
      'open': '09:30',
      'close': '17:00',
      'zone': 'WITA',
      'ticket': 'Rp 70.000',
      'location': 'Bali (WITA)',
      'image':
          'https://images.unsplash.com/photo-1658456769466-ceb22082ffd0?ixlib=rb-4.1.0&auto=format&fit=crop&q=60&w=600',
    },
    {
      'name': 'Ambon City Park Zoo',
      'open': '08:30',
      'close': '16:30',
      'zone': 'WIT',
      'ticket': 'Rp 55.000',
      'location': 'Ambon (WIT)',
      'image':
          'https://images.unsplash.com/photo-1660482409552-066c98ef2c3d?ixlib=rb-4.1.0&auto=format&fit=crop&q=60&w=600',
    },
    {
      'name': 'London Zoo',
      'open': '09:00',
      'close': '17:30',
      'zone': 'GMT',
      'ticket': '£25.00',
      'location': 'London (GMT)',
      'image':
          'https://images.unsplash.com/photo-1738429938346-6920452b63f0?ixlib=rb-4.1.0&auto=format&fit=crop&q=60&w=600',
    },
  ];

  final Map<String, int> _timeOffsets = {
    'GMT': 0,
    'WIB': 7,
    'WITA': 8,
    'WIT': 9,
  };

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {}); // update waktu tiap detik
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _getLocalTime(Map<String, dynamic> zoo) {
    try {
      // Waktu UTC sekarang
      final nowUtc = DateTime.now().toUtc();

      // Offset zona waktu kebun binatang
      final zooOffset = _timeOffsets[zoo['zone']] ?? 7;

      // Waktu lokal di kebun binatang (UTC + offset)
      final zooTime = nowUtc.add(Duration(hours: zooOffset));

      // Format waktu lokal kebun binatang
      return DateFormat('HH:mm').format(zooTime);
    } catch (e) {
      return 'Error';
    }
  }

  void _convertCurrency() {
    try {
      double amount = double.parse(_amountController.text);
      final Map<String, double> currencyRates = {
        'IDR': 1,
        'USD': 15500,
        'GBP': 20000,
      };

      double baseRate = currencyRates[_selectedCurrency] ?? 1;

      String result = '';
      currencyRates.forEach((currency, rate) {
        double converted = amount * (baseRate / rate);
        if (currency == 'IDR') {
          result += "$currency: Rp${converted.toStringAsFixed(0)}\n";
        } else if (currency == 'USD') {
          result += "$currency: \$${converted.toStringAsFixed(2)}\n";
        } else {
          result += "$currency: £${converted.toStringAsFixed(2)}\n";
        }
      });

      setState(() => _convertedCurrencyResult = result);
    } catch (e) {
      setState(() => _convertedCurrencyResult = "Masukkan angka valid!");
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color darkRed = Color(0xFF432323);
    const Color tealDark = Color(0xFF2F5755);
    const Color tealLight = Color(0xFF5A9690);
    const Color cream = Color(0xFFE0D9D9);

    return Scaffold(
      backgroundColor: cream,
      appBar: AppBar(
        backgroundColor: darkRed,
        title: const Text(
          "Informasi & Konversi",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "🐾 Daftar Kebun Binatang",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: darkRed,
              ),
            ),
            const SizedBox(height: 12),

            // daftar kebun binatang
            ..._zoos.map((zoo) => _buildZooCard(zoo, tealDark, darkRed)),

            const SizedBox(height: 25),
            _buildSectionTitle("Konversi Mata Uang", darkRed),
            _buildCurrencyConverter(tealLight, tealDark),
          ],
        ),
      ),
    );
  }

  Widget _buildZooCard(
    Map<String, dynamic> zoo,
    Color tealDark,
    Color darkRed,
  ) {
    final localTime = _getLocalTime(zoo);

    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.network(
              zoo['image']!,
              height: 160,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 160,
                  color: Colors.grey[300],
                  child: const Icon(Icons.image, size: 50, color: Colors.grey),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  zoo['name']!,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: tealDark,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Jam Operasional: ${zoo['open']} - ${zoo['close']} ${zoo['zone']}",
                ),
                Text("Tiket: ${zoo['ticket']}"),
                Text("Lokasi: ${zoo['location']}"),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: tealDark.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: tealDark),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.access_time, color: tealDark, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        "Waktu ${zoo['zone']}: $localTime",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: tealDark,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, Color color) {
    return Text(
      title,
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
    );
  }

  Widget _buildCurrencyConverter(Color buttonColor, Color textColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        TextField(
          controller: _amountController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: "Masukkan jumlah uang",
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedCurrency,
          items: const [
            DropdownMenuItem(value: 'IDR', child: Text('IDR')),
            DropdownMenuItem(value: 'USD', child: Text('USD')),
            DropdownMenuItem(value: 'GBP', child: Text('GBP')),
          ],
          onChanged: (v) => setState(() => _selectedCurrency = v!),
          decoration: const InputDecoration(
            labelText: "Mata uang asal",
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: _convertCurrency,
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text("Konversi Mata Uang"),
        ),
        const SizedBox(height: 8),
        Text(
          _convertedCurrencyResult,
          style: TextStyle(fontSize: 16, color: textColor, height: 1.4),
        ),
      ],
    );
  }
}
