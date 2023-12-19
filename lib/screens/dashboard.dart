import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  final String username; // Menggunakan informasi yang diperoleh setelah login
  String selectedShift = 'Shift 1'; // Nilai default untuk dropdown

  DashboardPage({Key? key, required this.username}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Welcome, $username', // Menampilkan nama petugas atau informasi lainnya
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            DropdownButton<String>(
              value: selectedShift,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  // Saat nilai dropdown berubah
                  // Lakukan sesuatu di sini, contohnya simpan nilai shift yang dipilih
                  selectedShift = newValue;
                }
              },
              items: <String>['Shift 1', 'Shift 2']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
