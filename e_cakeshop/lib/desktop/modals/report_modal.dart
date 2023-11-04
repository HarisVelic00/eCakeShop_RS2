import 'package:flutter/material.dart';

class ReportModal extends StatelessWidget {
  final List<Map<String, String>> data;

  ReportModal({required this.data});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color.fromRGBO(247, 249, 253, 1),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Printed Report',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            DataTable(
              columns: [
                DataColumn(label: Text('Order Number')),
                DataColumn(label: Text('Date')),
                DataColumn(label: Text('User')),
                DataColumn(label: Text('Product')),
                DataColumn(label: Text('Price')),
                DataColumn(label: Text('IsCanceled')),
                DataColumn(label: Text('IsShipped')),
              ],
              rows: data.map((row) {
                return DataRow(
                  cells: [
                    DataCell(Text(row['Order Number'] ?? '')),
                    DataCell(Text(row['Date'] ?? '')),
                    DataCell(Text(row['User'] ?? '')),
                    DataCell(Text(row['Product'] ?? '')),
                    DataCell(Text(row['Price'] ?? '')),
                    DataCell(Text(row['IsCanceled'] ?? '')),
                    DataCell(Text(row['IsShipped'] ?? '')),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
