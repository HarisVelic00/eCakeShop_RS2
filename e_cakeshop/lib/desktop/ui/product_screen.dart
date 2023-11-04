import 'package:e_cakeshop/desktop/modals/add_product_modal.dart'; // Import the AddProductModal
import 'package:e_cakeshop/desktop/modals/delete_modal.dart';
import 'package:flutter/material.dart';

class ProductScreen extends StatefulWidget {
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  bool isDeleteModalOpen = false;
  bool isAddProductModalOpen =
      false; // Added to track the Add Product modal state

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

  void openAddProductModal() {
    setState(() {
      isAddProductModalOpen = true;
    });
  }

  void closeAddProductModal() {
    setState(() {
      isAddProductModalOpen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Product List', style: TextStyle(color: Colors.black)),
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
                                hintText: 'Search for products...',
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
                            onPressed:
                                openAddProductModal, // Open the Add Product Modal
                            child: const Text('Add Product'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  DataTable(
                    columns: [
                      DataColumn(label: Text('ID')),
                      DataColumn(label: Text('Name')),
                      DataColumn(label: Text('Code')),
                      DataColumn(label: Text('Price')),
                      DataColumn(label: Text('Image')),
                      DataColumn(label: Text('Description')),
                      DataColumn(label: Text('Type')),
                      DataColumn(label: Text('Actions')),
                    ],
                    rows: [
                      DataRow(
                        cells: [
                          DataCell(Text('ID')),
                          DataCell(Text('Name')),
                          DataCell(Text('Code')),
                          DataCell(Text('Price')),
                          DataCell(Text('Image')),
                          DataCell(Text('Description')),
                          DataCell(Text('Type')),
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
                      // Add more DataRow entries for additional products
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
              if (isAddProductModalOpen)
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: AddProductModal(
                      onCancelPressed: closeAddProductModal,
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
