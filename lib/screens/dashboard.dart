import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'transaksi.dart';

class DashboardPage extends StatefulWidget {
  final String accessToken;

  const DashboardPage({Key? key, required this.accessToken}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String username = '';
  String selectedShift = 'Shift 1';

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final url = Uri.parse('http://10.0.2.2:1000/me');
    try {
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer ${widget.accessToken}'},
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        setState(() {
          username = responseData['namapengguna'];
        });
      } else {
        print('Failed to fetch user data');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> fetchShiftData(String selectedShift) async {
    final shift = selectedShift == 'Shift 1' ? 1 : 2;
    final url = Uri.parse('http://10.0.2.2:1000/transaksi?shift=$shift');
    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer ${widget.accessToken}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TransactionPage(
              accessToken: widget.accessToken,
              selectedShift: selectedShift,
            ),
          ),
        );
      } else {
        print('Failed to fetch shift data');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
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
                'Welcome, $username!',
                style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold, color: Colors.deepOrange),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24.0),
              DropdownButton<String>(
                value: selectedShift,
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      selectedShift = newValue;
                    });
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
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  fetchShiftData(selectedShift);
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.deepOrange,
                  textStyle: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: Text('View Transactions'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
