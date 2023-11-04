import 'package:e_cakeshop/desktop/modals/add_order_modal.dart';
import 'package:e_cakeshop/desktop/modals/delete_modal.dart';
import 'package:flutter/material.dart';

class OrdersScreen extends StatefulWidget {
  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  bool isDeleteModalOpen = false;
  bool isAddOrderModalOpen = false;

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

  void openAddOrderModal() {
    setState(() {
      isAddOrderModalOpen = true;
    });
  }

  void closeAddOrderModal() {
    setState(() {
      isAddOrderModalOpen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order List', style: TextStyle(color: Colors.black)),
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
                                hintText: 'Search for orders...',
                                prefixIcon: Icon(Icons.search),
                                border: InputBorder.none,
                              ),
                              onChanged: (text) {
                                // Implement search functionality here
                              },
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
                            onPressed: openAddOrderModal,
                            child: const Text('Add Order'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  DataTable(
                    columns: [
                      DataColumn(label: Text('ID')),
                      DataColumn(label: Text('Order Number')),
                      DataColumn(label: Text('User')),
                      DataColumn(label: Text('Date')),
                      DataColumn(label: Text('Products')),
                      DataColumn(label: Text('Is Shipped')),
                      DataColumn(label: Text('Is Canceled')),
                      DataColumn(label: Text('Actions')),
                    ],
                    rows: [
                      DataRow(
                        cells: [
                          DataCell(Text('ID')),
                          DataCell(Text('Order Number')),
                          DataCell(Text('User')),
                          DataCell(Text('Date')),
                          DataCell(Text('Products')),
                          DataCell(Text('Is Shipped')),
                          DataCell(Text('Is Canceled')),
                          DataCell(
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    // Implement edit functionality here
                                  },
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
                      // Add more DataRow entries for additional orders
                    ],
                  ),
                ],
              ),
              if (isDeleteModalOpen)
                Center(
                  child: DeleteModal(
                    onDeletePressed: () {
                      // Handle delete action here
                      // ...
                      closeDeleteModal();
                    },
                    onCancelPressed: () {
                      closeDeleteModal();
                    },
                  ),
                ),
              if (isAddOrderModalOpen)
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: AddOrderModal(
                      onCancelPressed: closeAddOrderModal,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
