// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, use_build_context_synchronously, avoid_print, prefer_const_constructors_in_immutables, deprecated_member_use
import 'package:e_cakeshop_admin/modals/add_news_modal.dart';
import 'package:e_cakeshop_admin/modals/delete_modal.dart';
import 'package:e_cakeshop_admin/modals/edit_news_modal.dart';
import 'package:e_cakeshop_admin/models/novost.dart';
import 'package:e_cakeshop_admin/providers/novost_provider.dart';
import 'package:e_cakeshop_admin/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class NewsScreen extends StatefulWidget {
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  bool isDeleteModalOpen = false;
  bool isAddNewsModalOpen = false;
  bool _isEditNewsModalOpen = false;
  late NovostProvider novostProvider;
  Novost? novostToDelete;
  Novost? novostToEdit;
  late String _searchQuery = '';

  void openDeleteModal(Novost novost) {
    setState(() {
      isDeleteModalOpen = true;
      novostToDelete = novost;
    });
  }

  void closeDeleteModal() {
    setState(() {
      isDeleteModalOpen = false;
      novostToDelete = null;
    });
  }

  void openAddNewsModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddNewsModal(
          onCancelPressed: () {
            Navigator.pop(context);
          },
          onAddNewsPressed: addNewNovost,
        );
      },
    );
  }

  void openEditNewsModal(Novost novost) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditNewsModal(
          onCancelPressed: () {
            Navigator.pop(context);
          },
          onUpdatePressed: updateNews,
          novostToEdit: novost,
        );
      },
    );
  }

  void deleteNovost(Novost novost) async {
    try {
      await novostProvider.delete(novost.novostID!);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('News deleted successfully'),
        ),
      );
      closeDeleteModal();
    } catch (e) {
      print("Error deleting news: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to delete news'),
        ),
      );
    }
  }

  dynamic addNewNovost(Map<String, dynamic> newNews) async {
    try {
      await novostProvider.insert(newNews);
      setState(() {});
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('News added successfully'),
          ),
        );
      }
      setState(() {});
    } catch (e) {
      print("Error adding news: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to add news'),
          ),
        );
      }
    }
  }

  void updateNews(int id, dynamic request) async {
    try {
      var updatedNews = await novostProvider.update(id, request);
      if (updatedNews != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('News updated successfully'),
          ),
        );
        setState(() {});
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to update news'),
          ),
        );
      }
    } catch (e) {
      print("Error updating news: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    novostProvider = Provider.of<NovostProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('News List', style: TextStyle(color: Colors.black)),
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
                                hintText: 'Search for news...',
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
                            onPressed: openAddNewsModal,
                            child: const Text(
                              'Add News',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: Expanded(
                      child: NewsTable(
                        openEditNewsModal: openEditNewsModal,
                        openDeleteModal: openDeleteModal,
                        novostProvider: novostProvider,
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
                      deleteNovost(novostToDelete!);
                    },
                    onCancelPressed: closeDeleteModal,
                  ),
                ),
              if (isAddNewsModalOpen)
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: AddNewsModal(
                      onCancelPressed: () {
                        Navigator.pop(context);
                      },
                      onAddNewsPressed: addNewNovost,
                    ),
                  ),
                ),
              if (_isEditNewsModalOpen)
                Center(
                  child: AlertDialog(
                    content: EditNewsModal(
                      onCancelPressed: () {
                        setState(() {
                          _isEditNewsModalOpen = false;
                        });
                      },
                      onUpdatePressed: updateNews,
                      novostToEdit: novostToEdit,
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

class NewsTable extends StatelessWidget {
  final void Function(Novost) openEditNewsModal;
  final void Function(Novost) openDeleteModal;
  final NovostProvider novostProvider;
  final String searchQuery;

  const NewsTable({
    required this.openEditNewsModal,
    required this.openDeleteModal,
    required this.novostProvider,
    required this.searchQuery,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Novost>>(
      future: novostProvider.Get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          List<Novost> filteredNovost = snapshot.data!.where((novost) {
            String title = '${novost.naslov}';
            return title.toLowerCase().contains(searchQuery.toLowerCase());
          }).toList();

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Expanded(
              child: SingleChildScrollView(
                child: DataTable(
                  dataRowHeight: 256,
                  columns: const [
                    DataColumn(label: Text('ID')),
                    DataColumn(label: Text('Title')),
                    DataColumn(label: Text('Content')),
                    DataColumn(label: Text('Thumbnail')),
                    DataColumn(label: Text('Creation Date')),
                    DataColumn(label: Text('Actions')),
                  ],
                  rows: filteredNovost.map((novost) {
                    return DataRow(
                      cells: [
                        DataCell(Text(novost.novostID.toString())),
                        DataCell(Text(novost.naslov ?? '')),
                        DataCell(Text(novost.sadrzaj ?? '')),
                        DataCell(
                          novost.thumbnail != null
                              ? SizedBox(
                                  width: 256,
                                  height: 256,
                                  child: Image.memory(
                                    dataFromBase64String(novost.thumbnail!),
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : const Text('No Image'),
                        ),
                        DataCell(
                          novost.datumKreiranja != null
                              ? Text(
                                  DateFormat('dd.MM.yyyy')
                                      .format(novost.datumKreiranja!),
                                )
                              : const Text(''),
                        ),
                        DataCell(
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () => openEditNewsModal(novost),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  openDeleteModal(novost);
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
