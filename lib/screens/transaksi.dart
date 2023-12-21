import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:logger/logger.dart';

import 'detailTransaksi.dart';

class Transaction {
  final int idTransaksi;
  final DateTime tanggal;
  final String waktu;
  final String shift;
  final int idPengguna;
  final String idPelanggan;
  final String status;
  final String kodeMeja;
  final String namaPelanggan;
  final int total;
  final String metodePembayaran;
  final String totalDiskon;
  final int idPromosi;

  Transaction({
    required this.idTransaksi,
    required this.tanggal,
    required this.waktu,
    required this.shift,
    required this.idPengguna,
    required this.idPelanggan,
    required this.status,
    required this.kodeMeja,
    required this.namaPelanggan,
    required this.total,
    required this.metodePembayaran,
    required this.totalDiskon,
    required this.idPromosi,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      idTransaksi: json['idtransaksi'] as int,
      tanggal: DateTime.parse(json['tanggal']),
      waktu: json['waktu'] as String,
      shift: json['shift'] as String,
      idPengguna: json['idpengguna'] as int,
      idPelanggan: json['idpelanggan'] as String,
      status: json['status'] as String,
      kodeMeja: json['kodemeja'] as String,
      namaPelanggan: json['namapelanggan'] as String,
      total: int.parse(json['total']), // Convert String to int
      metodePembayaran: json['metodepembayaran'] as String,
      totalDiskon: json['totaldiskon'] as String,
      idPromosi: json['idpromosi'] as int,
    );
  }
}

var logger = Logger();

class TransactionPage extends StatelessWidget {
  final String accessToken;
  final String selectedShift;

  const TransactionPage({
    Key? key,
    required this.accessToken,
    required this.selectedShift,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transactions for $selectedShift'),
      ),
      body: FutureBuilder<List<Transaction>>(
        future: fetchTransactions(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No transactions available.'));
          } else {
            print(snapshot.data);
            return buildTransactionList(snapshot.data!);
          }
        },
      ),
    );
  }

  Future<List<Transaction>> fetchTransactions() async {
    final shift = selectedShift == 'Shift 1' ? 1 : 2;

    final url = Uri.parse('http://10.0.2.2:1000/transaksi?shift=$shift');
    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: json.encode({'shift': selectedShift}),
      );

      if (response.statusCode == 200) {
        final dynamic decodedData = json.decode(response.body);

        if (decodedData is Map<String, dynamic>) {
          List<Transaction> transactions = [Transaction.fromJson(decodedData)];
          logger.i('Transaction fetched: $transactions');
          return transactions;
        } else if (decodedData is List<dynamic>) {
          List<Transaction> transactions = decodedData.map((data) {
            return Transaction.fromJson(data);
          }).toList();
          logger.i('Transactions fetched: $transactions');
          return transactions;
        } else {
          throw Exception('Failed to fetch transactions');
        }
      } else {
        throw Exception('Failed to fetch transactions');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }

  Widget buildTransactionList(List<Transaction> transactions) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final transaction = transactions[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return detailTransaksi(
                  idTransaksi: transaction.idTransaksi,
                  accessToken: accessToken,
                  selectedShift: selectedShift,
                );
              }));
            },
            child: Card(
              child: ListTile(
                title: Text('Transaction ID: ${transaction.idTransaksi}'),
                subtitle: Text('Amount: ${transaction.total}'),
              ),
            ),
          );
        },
      ),
    );
  }
}
