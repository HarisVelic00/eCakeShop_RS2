// ignore_for_file: library_private_types_in_public_api, use_key_in_widget_constructors, use_build_context_synchronously, avoid_print, prefer_const_constructors_in_immutables
import 'package:e_cakeshop_admin/modals/add_order_modal.dart';
import 'package:e_cakeshop_admin/modals/delete_modal.dart';
import 'package:e_cakeshop_admin/modals/edit_order_modal.dart';
import 'package:e_cakeshop_admin/models/narudzba.dart';
import 'package:e_cakeshop_admin/providers/narudzba_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatefulWidget {
  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  bool isDeleteModalOpen = false;
  bool isAddOrderModalOpen = false;
  bool _isEditOrderModalOpen = false;
  late NarudzbaProvider narudzbaProvider;
  Narudzba? narudzbaToDelete;
  Narudzba? narudzbaToEdit;
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
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddOrderModal(
          onCancelPressed: () {
            Navigator.pop(context);
          },
          onAddOrderPressed: addNewOrder,
        );
      },
    );
  }

  void openEditOrderModal(Narudzba narudzba) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditOrderModal(
          onCancelPressed: () {
            Navigator.pop(context);
          },
          onUpdatePressed: updateOrder,
          narudzbaToEdit: narudzba,
        );
      },
    );
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

  dynamic addNewOrder(Map<String, dynamic> newOrder) async {
    try {
      await narudzbaProvider.insert(newOrder);
      setState(() {});
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Order added successfully'),
          ),
        );
      }
      setState(() {});
    } catch (e) {
      print("Error adding order: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to add order'),
          ),
        );
      }
    }
  }

  void updateOrder(int id, dynamic request) async {
    try {
      var updatedUser = await narudzbaProvider.update(id, request);
      if (updatedUser != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Order updated successfully'),
          ),
        );
        setState(() {});
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to update order'),
          ),
        );
      }
    } catch (e) {
      print("Error updating order: $e");
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
              ListView(
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
                            child: const Text(
                              'Add Order',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: Expanded(
                      child: OrdersTable(
                        openEditOrderModal: openEditOrderModal,
                        openDeleteModal: openDeleteModal,
                        narudzbaProvider: narudzbaProvider,
                        searchQuery: _searchQuery,
                      ),
                    ),
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
                      onCancelPressed: () {
                        Navigator.pop(context);
                      },
                      onAddOrderPressed: addNewOrder,
                    ),
                  ),
                ),
              if (_isEditOrderModalOpen)
                Center(
                    child: AlertDialog(
                        content: EditOrderModal(
                  onCancelPressed: () {
                    setState(() {
                      _isEditOrderModalOpen = false;
                    });
                  },
                  onUpdatePressed: updateOrder,
                  narudzbaToEdit: narudzbaToEdit,
                )))
            ],
          ),
        ),
      ),
    );
  }
}

class OrdersTable extends StatelessWidget {
  final void Function(Narudzba) openEditOrderModal;
  final void Function(Narudzba) openDeleteModal;
  final NarudzbaProvider narudzbaProvider;
  final String searchQuery;

  const OrdersTable({
    required this.openEditOrderModal,
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
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          List<Narudzba> filteredNarudzba = snapshot.data!.where((narudzba) {
            String order = '${narudzba.korisnik?.ime}';
            return order.toLowerCase().contains(searchQuery.toLowerCase());
          }).toList();

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Expanded(
              child: SingleChildScrollView(
                child: DataTable(
                  dataRowMinHeight: 50,
                  dataRowMaxHeight: 150,
                  columns: const [
                    DataColumn(label: Text('Order Number')),
                    DataColumn(label: Text('User')),
                    DataColumn(label: Text('Date')),
                    DataColumn(label: Text('Products')),
                    DataColumn(label: Text('Shipped')),
                    DataColumn(label: Text('Canceled')),
                    DataColumn(label: Text('Actions')),
                  ],
                  rows: filteredNarudzba.map((narudzba) {
                    return DataRow(
                      cells: [
                        DataCell(Text(narudzba.brojNarudzbe?.toString() ?? '')),
                        DataCell(Text(narudzba.korisnik?.ime ?? '')),
                        DataCell(
                          narudzba.datumNarudzbe != null
                              ? Text(
                                  DateFormat('MM.dd.yyyy')
                                      .format(narudzba.datumNarudzbe!),
                                )
                              : const Text(''),
                        ),
                        DataCell(
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: narudzba.narudzbaProizvodi!
                                  .split(',')
                                  .map((product) => Text(product.trim()))
                                  .toList(),
                            ),
                          ),
                        ),
                        DataCell(
                          Text(narudzba.isShipped ?? false ? '✓' : '✗'),
                        ),
                        DataCell(
                          Text(narudzba.isCanceled ?? false ? '✓' : '✗'),
                        ),
                        DataCell(
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () => openEditOrderModal(narudzba),
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
              ),
            ),
          );
        } else {
          return const Center(child: Text('No data available'));
        }
      },
    );
  }
}
