import 'package:e_cakeshop/desktop/modals/add_product_modal.dart';
import 'package:e_cakeshop/desktop/modals/delete_modal.dart';
import 'package:e_cakeshop/desktop/modals/edit_product_modal.dart';
import 'package:e_cakeshop/models/proizvod.dart';
import 'package:e_cakeshop/providers/proizvod_provider.dart';
import 'package:e_cakeshop/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductScreen extends StatefulWidget {
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  bool isDeleteModalOpen = false;
  bool isAddProductModalOpen = false;
  bool isEditProductModalOpen = false;
  late ProizvodProvider proizvodProvider;
  Proizvod? proizvodToDelete;

  void openDeleteModal(Proizvod proizvod) {
    setState(() {
      isDeleteModalOpen = true;
      proizvodToDelete = proizvod;
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

  void openEditProductModal() {
    setState(() {
      isEditProductModalOpen = true;
    });
  }

  void closeEditProductModal() {
    setState(() {
      isEditProductModalOpen = false;
    });
  }

  void deleteProizvod(Proizvod product) async {
    try {
      await proizvodProvider.delete(product.proizvodID!);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Product deleted successfully'),
        ),
      );
      setState(() {
        proizvodToDelete = null;
      });
    } catch (e) {
      print("Error deleting product: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to delete product'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    proizvodProvider = Provider.of<ProizvodProvider>(context, listen: false);
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
                            onPressed: openAddProductModal,
                            child: const Text('Add Product'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ProductTable(
                    openEditUserModal: openEditProductModal,
                    openDeleteModal: openDeleteModal,
                    proizvodProvider: proizvodProvider,
                  )
                ],
              ),
              if (isDeleteModalOpen)
                Center(
                  child: DeleteModal(
                    onDeletePressed: () {
                      if (proizvodToDelete != null) {
                        deleteProizvod(proizvodToDelete!);
                      }
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
              if (isEditProductModalOpen)
                Center(
                  child: EditProductModal(
                    onCancelPressed: closeEditProductModal,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProductTable extends StatelessWidget {
  final void Function() openEditUserModal;
  final void Function(Proizvod) openDeleteModal;
  final ProizvodProvider proizvodProvider;

  ProductTable({
    required this.openEditUserModal,
    required this.openDeleteModal,
    required this.proizvodProvider,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Proizvod>>(
      future: proizvodProvider.Get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          return DataTable(
            columns: const [
              DataColumn(label: Text('ID')),
              DataColumn(label: Text('Name')),
              DataColumn(label: Text('Code')),
              DataColumn(label: Text('Price')),
              DataColumn(label: Text('Image')),
              DataColumn(label: Text('Description')),
              DataColumn(label: Text('Actions')),
            ],
            rows: snapshot.data!.map((proizvod) {
              return DataRow(
                cells: [
                  DataCell(Text(proizvod.proizvodID?.toString() ?? '')),
                  DataCell(Text(proizvod.naziv ?? '')),
                  DataCell(Text(proizvod.sifra ?? '')),
                  DataCell(Text(proizvod.cijena?.toString() ?? '')),
                  DataCell(
                    proizvod.slika != null
                        ? Image.memory(dataFromBase64String(proizvod.slika!))
                        : const Text('No Image'),
                  ),
                  DataCell(Text(proizvod.opis ?? '')),
                  DataCell(
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: openEditUserModal,
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            openDeleteModal(proizvod);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }).toList(),
          );
        } else {
          return const Text('No data available');
        }
      },
    );
  }
}
