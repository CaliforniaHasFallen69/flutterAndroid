import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Implementasi desain D1 (Form Login)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Username',
                  icon: Icon(Icons.person),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  icon: Icon(Icons.lock),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Logika untuk verifikasi login E4 (D2 - Validasi Login)
                if (validateLogin()) {
                  // Jika berhasil, pindah ke halaman berikutnya
                  Navigator.pushReplacementNamed(context, '/dashboard');
                } else {
                  // Tampilkan pesan kesalahan jika login tidak valid
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Login failed. Please check your credentials.')),
                  );
                }
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }

  // Fungsi untuk validasi login (contoh sederhana)
  bool validateLogin() {
    // Implementasi validasi login sesuai kebutuhan
    // Misalnya, cek username dan password dari database atau sumber data lainnya
    return true; // Ganti dengan logika validasi sebenarnya
  }
}