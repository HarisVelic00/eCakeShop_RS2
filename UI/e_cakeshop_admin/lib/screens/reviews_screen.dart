// ignore_for_file: library_private_types_in_public_api, use_key_in_widget_constructors, use_build_context_synchronously, avoid_print
import 'package:e_cakeshop_admin/modals/delete_modal.dart';
import 'package:e_cakeshop_admin/modals/edit_review_modal.dart';
import 'package:e_cakeshop_admin/models/recenzija.dart';
import 'package:e_cakeshop_admin/providers/recenzija_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ReviewScreen extends StatefulWidget {
  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  late RecenzijaProvider recenzijaProvider;
  bool isDeleteModalOpen = false;
  bool isAddReviewModalOpen = false;
  bool _isEditReviewModalOpen = false;
  Recenzija? recenzijaToDelete;
  Recenzija? recenzijaToEdit;
  late String _searchQuery = '';

  void openDeleteModal(Recenzija recenzija) {
    setState(() {
      isDeleteModalOpen = true;
      recenzijaToDelete = recenzija;
    });
  }

  void closeDeleteModal() {
    setState(() {
      isDeleteModalOpen = false;
    });
  }

  void openEditReviewModal(Recenzija recenzija) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditReviewModal(
          onCancelPressed: () {
            Navigator.pop(context);
          },
          onUpdatePressed: updateReview,
          recenzijaToEdit: recenzija,
        );
      },
    );
  }

  void deleteRecenzija(Recenzija recenzija) async {
    try {
      await recenzijaProvider.delete(recenzija.recenzijaID!);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Review deleted successfully'),
        ),
      );
      setState(() {
        recenzijaToDelete = null;
      });
    } catch (e) {
      print("Error deleting review: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to delete review'),
        ),
      );
    }
  }

  dynamic addNewReview(Map<String, dynamic> newRecenzija) async {
    try {
      await recenzijaProvider.insert(newRecenzija);
      setState(() {});
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Review added successfully'),
          ),
        );
      }
      setState(() {});
    } catch (e) {
      print("Error adding review: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to add review'),
          ),
        );
      }
    }
  }

  void updateReview(int id, dynamic request) async {
    try {
      var updatedUser = await recenzijaProvider.update(id, request);

      if (updatedUser != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Review updated successfully'),
          ),
        );
        setState(() {});
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to update review'),
          ),
        );
      }
    } catch (e) {
      print("Error updating review: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    recenzijaProvider = Provider.of<RecenzijaProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Review List', style: TextStyle(color: Colors.black)),
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
                                hintText: 'Search for reviews...',
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
                      ],
                    ),
                  ),
                  Center(
                    child: Expanded(
                      child: ReviewTable(
                        openEditReviewModal: openEditReviewModal,
                        openDeleteModal: openDeleteModal,
                        recenzijaProvider: recenzijaProvider,
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
                      if (recenzijaToDelete != null) {
                        deleteRecenzija(recenzijaToDelete!);
                      }
                      closeDeleteModal();
                    },
                    onCancelPressed: () {
                      closeDeleteModal();
                    },
                  ),
                ),
              if (_isEditReviewModalOpen)
                Center(
                  child: AlertDialog(
                    content: EditReviewModal(
                      onCancelPressed: () {
                        setState(() {
                          _isEditReviewModalOpen = false;
                        });
                      },
                      onUpdatePressed: updateReview,
                      recenzijaToEdit: recenzijaToEdit,
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

class ReviewTable extends StatelessWidget {
  final void Function(Recenzija) openEditReviewModal;
  final void Function(Recenzija) openDeleteModal;
  final RecenzijaProvider recenzijaProvider;
  final String searchQuery;

  const ReviewTable({
    required this.openEditReviewModal,
    required this.openDeleteModal,
    required this.recenzijaProvider,
    required this.searchQuery,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Recenzija>>(
      future: recenzijaProvider.Get({'includeKorisnik': true}),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          List<Recenzija> filteredRecenzija = snapshot.data!.where((recenzija) {
            String recenzijaName = '${recenzija.korisnik!.ime}';
            return recenzijaName
                .toLowerCase()
                .contains(searchQuery.toLowerCase());
          }).toList();

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Expanded(
              child: SingleChildScrollView(
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Content')),
                    DataColumn(label: Text('Rating')),
                    DataColumn(label: Text('Creation Date')),
                    DataColumn(label: Text('User')),
                    DataColumn(label: Text('Actions')),
                  ],
                  rows: filteredRecenzija.map((recenzija) {
                    return DataRow(
                      cells: [
                        DataCell(Text(recenzija.sadrzajRecenzije ?? '')),
                        DataCell(Text(recenzija.ocjena.toString())),
                        DataCell(
                          recenzija.datumKreiranja != null
                              ? Text(
                                  DateFormat('dd.MM.yyyy')
                                      .format(recenzija.datumKreiranja!),
                                )
                              : const Text(''),
                        ),
                        DataCell(Text(recenzija.korisnik!.ime ?? '')),
                        DataCell(
                          Row(
                            children: [
                              IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () =>
                                      openEditReviewModal(recenzija)),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  openDeleteModal(recenzija);
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
          return const Text('No data available');
        }
      },
    );
  }
}
