import 'package:e_cakeshop/desktop/modals/delete_modal.dart';
import 'package:e_cakeshop/desktop/modals/report_modal.dart';
import 'package:flutter/material.dart';

class ArchiveScreen extends StatefulWidget {
  @override
  _ArchiveScreenState createState() => _ArchiveScreenState();
}

class _ArchiveScreenState extends State<ArchiveScreen> {
  bool isDeleteModalOpen = false;

  void openDeleteModal() {
    setState(() {
      isDeleteModalOpen = true;
    });
  }

  void closeDeleteModal() {
    setState(() {
      isDeleteModalOpen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Archived List', style: TextStyle(color: Colors.black)),
        backgroundColor: const Color.fromRGBO(227, 232, 247, 1),
      ),
      body: Container(
        color: const Color.fromRGBO(247, 249, 253, 1),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(227, 232, 247, 1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: TextField(
                              decoration: const InputDecoration(
                                hintText: 'Search for archived orders...',
                                prefixIcon: Icon(Icons.search),
                                border: InputBorder.none,
                              ),
                              onChanged: (text) {},
                            ),
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        Expanded(
                          flex: 1,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(200, 48),
                              backgroundColor:
                                  const Color.fromRGBO(97, 142, 246, 1),
                            ),
                            onPressed: () {
                              printReport();
                            },
                            child: const Text('Print Report'),
                          ),
                        ),
                      ],
                    ),
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
                      DataColumn(label: Text('Actions')),
                    ],
                    rows: [
                      DataRow(
                        cells: [
                          DataCell(Text('Order Number')),
                          DataCell(Text('User')),
                          DataCell(Text('Date')),
                          DataCell(Text('Product')),
                          DataCell(Text('Price')),
                          DataCell(Text('IsCanceled')),
                          DataCell(Text('IsShipped')),
                          DataCell(
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {},
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: openDeleteModal,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              if (isDeleteModalOpen)
                Center(
                  child: DeleteModal(
                    onDeletePressed: () {
                      closeDeleteModal();
                    },
                    onCancelPressed: () {
                      closeDeleteModal();
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void printReport() {
    List<Map<String, String>> reportData = [
      {
        'Order Number': '123',
        'Date': '2023-11-01',
        'User': 'John Doe',
        'Product': 'Product 1',
        'Price': '\$100',
        'IsCanceled': 'No',
        'IsShipped': 'Yes',
      },
    ];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ReportModal(data: reportData);
      },
    );
  }
}
