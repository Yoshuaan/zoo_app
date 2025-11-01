import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  String _selectedTimeZone = 'WIB';
  String _selectedCurrency = 'IDR';
  String _convertedTimeResult = '';
  String _convertedCurrencyResult = '';

  //  Daftar kebun binatang
  final List<Map<String, String>> _zoos = [
    {
      'name': 'Gembira Loka Zoo',
      'time': '08.00 - 16.30 WIB',
      'ticket': 'Rp 50.000 (Weekday) / Rp 60.000 (Weekend)',
      'location': 'Yogyakarta (WIB)',
      'image':
          'https://images.unsplash.com/photo-1750286602520-31f92bdfca62?ixlib=rb-4.1.0&auto=format&fit=crop&q=60&w=600',
    },
    {
      'name': 'Bali Zoo',
      'time': '09.00 - 17.00 WITA',
      'ticket': 'Rp 70.000',
      'location': 'Bali (WITA)',
      'image':
          'https://images.unsplash.com/photo-1658456769466-ceb22082ffd0?ixlib=rb-4.1.0&auto=format&fit=crop&q=60&w=600',
    },
    {
      'name': 'Ambon City Park Zoo',
      'time': '08.30 - 16.30 WIT',
      'ticket': 'Rp 55.000',
      'location': 'Ambon (WIT)',
      'image':
          'https://images.unsplash.com/photo-1660482409552-066c98ef2c3d?ixlib=rb-4.1.0&auto=format&fit=crop&q=60&w=600',
    },
    {
      'name': 'London Zoo',
      'time': '09.00 - 17.30 GMT',
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

  final Map<String, double> _currencyRates = {
    'IDR': 1,
    'USD': 15500,
    'GBP': 20000,
  };

  void _convertTime() {
    try {
      final inputFormat = DateFormat("HH:mm");
      final inputTime = inputFormat.parse(_timeController.text);
      final baseOffset = _timeOffsets[_selectedTimeZone] ?? 7;

      String result = '';
      _timeOffsets.forEach((zone, offset) {
        final diff = offset - baseOffset;
        final converted = inputTime.add(Duration(hours: diff));
        result += "$zone: ${inputFormat.format(converted)}\n";
      });

      setState(() => _convertedTimeResult = result);
    } catch (e) {
      setState(
        () => _convertedTimeResult =
            " Format salah! Gunakan HH:mm (contoh: 14:30)",
      );
    }
  }

  void _convertCurrency() {
    try {
      double amount = double.parse(_amountController.text);
      double baseRate = _currencyRates[_selectedCurrency] ?? 1;

      String result = '';
      _currencyRates.forEach((currency, rate) {
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
      setState(() => _convertedCurrencyResult = " Masukkan angka valid!");
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

            //  List Zoo Cards
            ..._zoos.map(
              (zoo) => Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 5,
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                      child: Image.network(
                        zoo['image']!,
                        height: 160,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            zoo['name']!,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: tealDark,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            " ${zoo['time']}",
                            style: const TextStyle(color: Colors.black87),
                          ),
                          Text(
                            " ${zoo['ticket']}",
                            style: const TextStyle(color: Colors.black87),
                          ),
                          Text(
                            " ${zoo['location']}",
                            style: const TextStyle(color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),
            _buildSectionTitle("Konversi Waktu Antar Zona", darkRed),
            _buildTimeConverter(tealLight, tealDark),

            const SizedBox(height: 25),
            _buildSectionTitle("Konversi Mata Uang", darkRed),
            _buildCurrencyConverter(tealLight, tealDark),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, Color color) {
    return Text(
      title,
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
    );
  }

  Widget _buildTimeConverter(Color buttonColor, Color textColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        TextField(
          controller: _timeController,
          keyboardType: TextInputType.datetime,
          decoration: const InputDecoration(
            labelText: "Masukkan waktu (HH:mm)",
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedTimeZone,
          items: _timeOffsets.keys
              .map((zone) => DropdownMenuItem(value: zone, child: Text(zone)))
              .toList(),
          onChanged: (v) => setState(() => _selectedTimeZone = v!),
          decoration: const InputDecoration(
            labelText: "Zona waktu asal",
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: _convertTime,
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text("Konversi Waktu"),
        ),
        const SizedBox(height: 8),
        Text(
          _convertedTimeResult,
          style: TextStyle(fontSize: 16, color: textColor, height: 1.4),
        ),
      ],
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
          items: _currencyRates.keys
              .map((curr) => DropdownMenuItem(value: curr, child: Text(curr)))
              .toList(),
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
