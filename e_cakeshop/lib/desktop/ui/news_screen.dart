import 'package:e_cakeshop/desktop/modals/add_news_modal.dart';
import 'package:e_cakeshop/desktop/modals/delete_modal.dart';
import 'package:e_cakeshop/desktop/modals/edit_news_modal.dart';
import 'package:e_cakeshop/models/novost.dart';
import 'package:e_cakeshop/providers/novost_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewsScreen extends StatefulWidget {
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  bool isDeleteModalOpen = false;
  bool isAddNewsModalOpen = false;
  bool isEditNewsModalOpen = false;
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
    setState(() {
      isAddNewsModalOpen = true;
    });
  }

  void closeAddNewsModal() {
    setState(() {
      isAddNewsModalOpen = false;
    });
  }

  void openEditNewsModal(Novost novost) {
    setState(() {
      isEditNewsModalOpen = true;
      novostToEdit = novost;
    });
  }

  void closeEditNewsModal() {
    setState(() {
      isEditNewsModalOpen = false;
    });
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

  void addNewUser(Novost newNews) async {
    try {
      // Call the insert method from KorisnikProvider
      await novostProvider.insert(newNews);

      // Refresh the user list by calling the Get method
      setState(() {});

      // Check if the widget is still mounted before showing the SnackBar
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('News added successfully'),
          ),
        );
      }
    } catch (e) {
      print("Error adding news: $e");

      // Check if the widget is still mounted before showing the SnackBar
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
      var updatedUser = await novostProvider.update(id, request);

      if (updatedUser != null) {
        // Handle successful update
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('News updated successfully'),
          ),
        );
      } else {
        // Handle unsuccessful update
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
                            child: const Text('Add News'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  NewsTable(
                    openEditNewsModal: openEditNewsModal,
                    openDeleteModal: openDeleteModal,
                    novostProvider: novostProvider,
                    searchQuery: _searchQuery,
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
                      onCancelPressed: closeAddNewsModal,
                      onAddNewsPressed: addNewUser,
                    ),
                  ),
                ),
              if (isEditNewsModalOpen)
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: EditNewsModal(
                      onCancelPressed: closeEditNewsModal,
                      onSavePressed: closeEditNewsModal,
                      onUpdatePressed: (id, request) {
                        // Call the update method from the provider here
                        updateNews(id, request);
                      },
                      novostToEdit:
                          novostToEdit, // Make sure you are passing korisnikToEdit
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

  NewsTable({
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

          return DataTable(
            columns: const [
              DataColumn(label: Text('ID')),
              DataColumn(label: Text('Title')),
              DataColumn(label: Text('Content')),
              DataColumn(label: Text('Actions')),
            ],
            rows: filteredNovost.map((novost) {
              return DataRow(
                cells: [
                  DataCell(Text(novost.novostID.toString())),
                  DataCell(Text(novost.naslov ?? '')),
                  DataCell(Text(novost.sadrzaj ?? '')),
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
          );
        } else {
          return const Text('No data available');
        }
      },
    );
  }
}
