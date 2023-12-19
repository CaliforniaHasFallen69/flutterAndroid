import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dashboard')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Implementasi desain D3 (Daftar Pesanan)
            Expanded(
              child: ListView.builder(
                itemCount: orderList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Order ${orderList[index].orderNumber}'),
                    subtitle: Text('Status: ${orderList[index].status}'),
                    onTap: () {
                      // Pindah ke halaman detail pesanan saat item daftar pesanan diklik
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderDetailPage(order: orderList[index]),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            // Implementasi desain D5 (Detail Transaksi dan Total Bayar)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Detail Transaksi:'),
                  Text('Transaksi ID: ${selectedTransaction.transactionId}'),
                  Text('Tanggal: ${selectedTransaction.date}'),
                  Text('Shift: ${selectedTransaction.shift}'),
                  Text('Nomor Meja: ${selectedTransaction.tableNumber}'),
                  Divider(),
                  Text('Total Bayar: ${selectedTransaction.totalAmount}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderDetailPage extends StatelessWidget {
  final Order order;

  const OrderDetailPage({required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Order Detail')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Implementasi desain D5 (Detail Transaksi dan Total Bayar)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Detail Pesanan:'),
                  Text('Nomor Pesanan: ${order.orderNumber}'),
                  Text('Status: ${order.status}'),
                  // Tambahan informasi pesanan lainnya
                  // ...
                  Divider(),
                  Text('Total Bayar: ${order.totalAmount}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Contoh model untuk pesanan dan transaksi
class Order {
  final String orderNumber;
  final String status;
  final double totalAmount;

  Order({
    required this.orderNumber,
    required this.status,
    required this.totalAmount,
  });
}

class Transaction {
  final String transactionId;
  final String date;
  final String shift;
  final String tableNumber;
  final double totalAmount;

  Transaction({
    required this.transactionId,
    required this.date,
    required this.shift,
    required this.tableNumber,
    required this.totalAmount,
  });
}

// Contoh data simulasi
List<Order> orderList = [
  Order(orderNumber: '001', status: 'Dalam Proses', totalAmount: 50.0),
  Order(orderNumber: '002', status: 'Selesai', totalAmount: 30.0),
  // Tambahkan data pesanan lainnya sesuai kebutuhan
];

Transaction selectedTransaction = Transaction(
  transactionId: 'WT1202311270001',
  date: '2023-11-27',
  shift: 'Pagi',
  tableNumber: 'WT1A1',
  totalAmount: 80.0,
);
