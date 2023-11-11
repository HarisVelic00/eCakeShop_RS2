import 'package:e_cakeshop/desktop/modals/add_order_modal.dart';
import 'package:e_cakeshop/desktop/modals/delete_modal.dart';
import 'package:e_cakeshop/desktop/modals/edit_order_modal.dart';
import 'package:e_cakeshop/models/narudzba.dart';
import 'package:e_cakeshop/providers/narudzba_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatefulWidget {
  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  bool isDeleteModalOpen = false;
  bool isAddOrderModalOpen = false;
  bool isEditOrderModalOpen = false;
  late NarudzbaProvider narudzbaProvider;
  Narudzba? narudzbaToDelete;
  late String _searchQuery = '';

  void openDeleteModal(Narudzba narudzba) {
    setState(() {
      isDeleteModalOpen = true;
      narudzbaToDelete = narudzba;
    });
  }

  void closeDeleteModal() {
    setState(() {
      isDeleteModalOpen = false;
      narudzbaToDelete = null;
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

  void openEditOrderModal() {
    setState(() {
      isEditOrderModalOpen = true;
    });
  }

  void closeEditOrderModal() {
    setState(() {
      isEditOrderModalOpen = false;
    });
  }

  void deleteNarudzba(Narudzba narudzba) async {
    try {
      await narudzbaProvider.delete(narudzba.narudzbaID!);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Order deleted successfully'),
        ),
      );
      closeDeleteModal();
    } catch (e) {
      print("Error deleting order: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to delete order'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    narudzbaProvider = Provider.of<NarudzbaProvider>(context, listen: false);
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
                                setState(() {
                                  _searchQuery = text;
                                });
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
                  OrdersTable(
                    openEditUserModal: openEditOrderModal,
                    openDeleteModal: openDeleteModal,
                    narudzbaProvider: narudzbaProvider,
                    searchQuery: _searchQuery,
                  )
                ],
              ),
              if (isDeleteModalOpen)
                Center(
                  child: DeleteModal(
                    onDeletePressed: () {
                      deleteNarudzba(narudzbaToDelete!);
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
              if (isEditOrderModalOpen)
                Center(
                  child: EditOrderModal(
                    onCancelPressed: closeEditOrderModal,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class OrdersTable extends StatelessWidget {
  final void Function() openEditUserModal;
  final void Function(Narudzba) openDeleteModal;
  final NarudzbaProvider narudzbaProvider;
  final String searchQuery;

  OrdersTable({
    required this.openEditUserModal,
    required this.openDeleteModal,
    required this.narudzbaProvider,
    required this.searchQuery,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Narudzba>>(
      future: narudzbaProvider.Get({'includeNarudzbaProizvodi': true}),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          List<Narudzba> filteredNarudzba = snapshot.data!.where((narudzba) {
            String orderNumber = '${narudzba.brojNarudzbe}';
            return orderNumber
                .toLowerCase()
                .contains(searchQuery.toLowerCase());
          }).toList();

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('ID')),
                DataColumn(label: Text('Order Number')),
                DataColumn(label: Text('User')),
                DataColumn(label: Text('Date')),
                DataColumn(label: Text('Products')),
                DataColumn(label: Text('Is Shipped')),
                DataColumn(label: Text('Is Canceled')),
                DataColumn(label: Text('Actions')),
              ],
              rows: filteredNarudzba.map((narudzba) {
                return DataRow(
                  cells: [
                    DataCell(Text(narudzba.narudzbaID.toString())),
                    DataCell(Text(narudzba.brojNarudzbe?.toString() ?? '')),
                    DataCell(Text(narudzba.korisnik?.ime ?? '')),
                    DataCell(Text(narudzba.datumNarudzbe.toString())),
                    DataCell(Text(narudzba.narudzbaProizvodi ?? '')),
                    DataCell(Text(narudzba.isShipped.toString())),
                    DataCell(Text(narudzba.isCanceled.toString())),
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
                              openDeleteModal(narudzba);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          );
        } else {
          return const Text('No data available');
        }
      },
    );
  }
}
