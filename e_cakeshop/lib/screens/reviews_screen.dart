// ignore_for_file: library_private_types_in_public_api, use_key_in_widget_constructors, use_build_context_synchronously, avoid_print

import 'package:e_cakeshop/modals/add_review_modal.dart';
import 'package:e_cakeshop/modals/delete_modal.dart';
import 'package:e_cakeshop/modals/edit_review_modal.dart';
import 'package:e_cakeshop/models/recenzija.dart';
import 'package:e_cakeshop/providers/recenzija_provider.dart';
import 'package:flutter/material.dart';
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

  void openAddReviewModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddReviewModal(
          onCancelPressed: () {
            Navigator.pop(context);
          },
          onAddReviewPressed: addNewReview,
        );
      },
    );
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
                        const SizedBox(width: 16.0),
                        Expanded(
                          flex: 1,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(200, 48),
                              backgroundColor:
                                  const Color.fromRGBO(97, 142, 246, 1),
                            ),
                            onPressed: openAddReviewModal,
                            child: const Text('Add Review'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ReviewTable(
                      openEditReviewModal: openEditReviewModal,
                      openDeleteModal: openDeleteModal,
                      recenzijaProvider: recenzijaProvider,
                      searchQuery: _searchQuery,
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
              if (isAddReviewModalOpen)
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: AddReviewModal(
                      onCancelPressed: () {
                        Navigator.pop(context);
                      },
                      onAddReviewPressed: addNewReview,
                    ),
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
            child: Flexible(
              child: SingleChildScrollView(
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('ID')),
                    DataColumn(label: Text('Content')),
                    DataColumn(label: Text('Rating')),
                    DataColumn(label: Text('Date of creation')),
                    DataColumn(label: Text('User')),
                    DataColumn(label: Text('Actions')),
                  ],
                  rows: filteredRecenzija.map((recenzija) {
                    return DataRow(
                      cells: [
                        DataCell(Text(recenzija.recenzijaID?.toString() ?? '')),
                        DataCell(Text(recenzija.sadrzajRecenzije ?? '')),
                        DataCell(Text(recenzija.ocjena.toString())),
                        DataCell(Text(recenzija.datumKreiranja.toString())),
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
