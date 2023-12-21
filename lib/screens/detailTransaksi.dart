import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'transaksi.dart';

class detailTransaksi extends StatefulWidget {
  final int idTransaksi;
  final String accessToken;
  final String selectedShift;

  const detailTransaksi({
    Key? key,
    required this.idTransaksi,
    required this.accessToken,
    required this.selectedShift,
  }) : super(key: key);

  @override
  State<detailTransaksi> createState() => _DetailTransaksiState();
}

class _DetailTransaksiState extends State<detailTransaksi> {
  var selectedPayment = null;

  Future<Map<String, dynamic>> fetchDetailTransaksi(int idTransaksi) async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:1000/detailTransaksi/$idTransaksi'),
    );
    Map<String, dynamic> detailTransaksi = json.decode(response.body);

    if (response.statusCode == 200) {
      var newValue = null;
      switch (detailTransaksi['transaksi']['metodepembayaran']) {
        case 'cash':
          newValue = 'Cash';
          break;
        case 'kartu kredit':
          newValue = 'Kartu Kredit';
          break;
        case 'kartu debit':
          newValue = 'Kartu Debit';
          break;
        case 'qris':
          newValue = 'QRIS';
          break;
      }

      selectedPayment = newValue;
      print(detailTransaksi);
    } else {
      print('Failed to update transaction status');
    }

    return detailTransaksi;
  }

  Future<void> updateTransactionStatus() async {
    try {
      final response = await http.put(
        Uri.parse(
            'http://10.0.2.2:1000/updateDetailTransaksi/${widget.idTransaksi}'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({}),
      );

      if (response.statusCode == 200) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
          return detailTransaksi(
            idTransaksi: widget.idTransaksi,
            accessToken: widget.accessToken,
            selectedShift: widget.selectedShift,
          );
        }));
      } else {
        print('Failed to update transaction status');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> deleteTransaction() async {
    try {
      final response = await http.delete(
        Uri.parse(
            'http://10.0.2.2:1000/deletedetailTransaksi/${widget.idTransaksi}'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        Navigator.pop(context);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
          return TransactionPage(
            accessToken: widget.accessToken,
            selectedShift: widget.selectedShift,
          );
        }));
      } else {
        print('Failed to delete transaction');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> updateMetodePembayaran(String method) async {
    try {
      final response = await http.put(
        Uri.parse(
            'http://10.0.2.2:1000/updateMetodePembayaran/${widget.idTransaksi}'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({'metodepembayaran': method}),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Berhasil mengubah metode pembayaran"),
        ));
      } else {
        print('Failed to update transaction status');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
          future: fetchDetailTransaksi(widget.idTransaksi),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return Center(child: Text('No Data Available'));
            } else {
              return buildDetailTransactionList(
                  snapshot.data as Map<String, dynamic>);
            }
          },
        ),
      ),
    );
  }

  Widget buildDetailTransactionList(Map<String, dynamic> transaction) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('ID Transaksi: ${transaction['idtransaksi']}'),
          Text('ID Menu: ${transaction['idmenu']}'),
          Text('Nama Menu: ${transaction['namamenu']}'),
          Text('Harga: ${transaction['harga']}'),
          Text('Jumlah: ${transaction['jumlah']}'),
          Text('SubTotal: ${transaction['subtotal']}'),
          Text('Status: ${transaction['status']}'),
          SizedBox(height: 20),
          DropdownButton<String>(
            value: selectedPayment,
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  selectedPayment = newValue;
                  switch (newValue) {
                    case 'Cash':
                      newValue = 'cash';
                      break;
                    case 'Kartu Kredit':
                      newValue = 'kartu kredit';
                      break;
                    case 'Kartu Debit':
                      newValue = 'kartu debit';
                      break;
                    case 'QRIS':
                      newValue = 'qris';
                      break;
                  }
                  updateMetodePembayaran(newValue!);
                  fetchDetailTransaksi(widget.idTransaksi);
                });
              }
            },
            items: <String>['Cash', 'Kartu Kredit', 'Kartu Debit', 'QRIS']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  updateTransactionStatus();
                },
                child: Text('Shift'),
              ),
              ElevatedButton(
                onPressed: () {
                  deleteTransaction();
                },
                child: Text('Delete'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
