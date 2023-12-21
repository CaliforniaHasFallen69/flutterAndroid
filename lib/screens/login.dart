import 'package:flutter/material.dart';
import 'dashboard.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

Future<void> loginUser(
    String username, String password, BuildContext context) async {
  final url = Uri.parse('http://10.0.2.2:1000/login');

  try {
    final response = await http.post(
      url,
      body: json.encode({'username': username, 'password': password}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final accessToken = responseData['accessToken'];
      // Lakukan sesuatu dengan token, seperti menyimpannya ke SharedPreferences
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DashboardPage(
            accessToken: accessToken,
          ),
        ),
      );
    } else {
      final errorMessage = json.decode(response.body)['message'];
      print(errorMessage);
    }
  } catch (error) {
    print('Error: $error');
  }
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.orange[200],
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Warmindo Inspirasi Indonesia',
                style: TextStyle(
                  fontSize: 36.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange, 
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40.0),
              Image.asset(
                'assets/Warmindo.jpg',
                height: 100.0,
                width: 100.0,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 40.0),
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: () {
                  loginUser(
                    _usernameController.text,
                    _passwordController.text,
                    context,
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.deepOrange,
                  textStyle: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: Text('LOGIN'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
