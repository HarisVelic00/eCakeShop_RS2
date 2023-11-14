import 'package:e_cakeshop/desktop/modals/add_image_modal.dart';
import 'package:e_cakeshop/desktop/modals/delete_modal.dart';
import 'package:e_cakeshop/desktop/modals/edit_image_modal.dart';
import 'package:e_cakeshop/models/slika.dart';
import 'package:e_cakeshop/providers/slika_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PicturesScreen extends StatefulWidget {
  @override
  _PicturesScreenState createState() => _PicturesScreenState();
}

class _PicturesScreenState extends State<PicturesScreen> {
  bool isDeleteModalOpen = false;
  bool isAddPictureModalOpen = false;
  bool isEditImageModalOpen = false;
  late SlikaProvider slikaProvider;
  Slika? slikaToDelete;
  Slika? slikaToEdit;
  late String _searchQuery = '';

  void openDeleteModal(Slika slika) {
    setState(() {
      isDeleteModalOpen = true;
      slikaToDelete = slika;
    });
  }

  void closeDeleteModal() {
    setState(() {
      isDeleteModalOpen = false;
      slikaToDelete = null;
    });
  }

  void openAddPictureModal() {
    setState(() {
      isAddPictureModalOpen = true;
    });
  }

  void closeAddPictureModal() {
    setState(() {
      isAddPictureModalOpen = false;
    });
  }

  void openEditImageModal(Slika slika) {
    setState(() {
      isEditImageModalOpen = true;
      slikaToEdit = slika;
    });
  }

  void closeEditImageModal() {
    setState(() {
      isEditImageModalOpen = false;
    });
  }

  void deleteSlika(Slika slika) async {
    try {
      await slikaProvider.delete(slika.slikaID!);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Picture deleted successfully'),
        ),
      );
      closeDeleteModal();
    } catch (e) {
      print("Error deleting picture: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to delete picture'),
        ),
      );
    }
  }

  void addNewSlika(Slika newSlika) async {
    try {
      await slikaProvider.insert(newSlika);
      setState(() {});
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Image added successfully'),
          ),
        );
      }
    } catch (e) {
      print("Error adding Image: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to add image'),
          ),
        );
      }
    }
  }

  void updateSlika(int id, dynamic request) async {
    try {
      var updatedImage = await slikaProvider.update(id, request);

      if (updatedImage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User updated successfully'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to update user'),
          ),
        );
      }
    } catch (e) {
      print("Error updating user: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    slikaProvider = Provider.of<SlikaProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Picture List', style: TextStyle(color: Colors.black)),
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
                                hintText: 'Search for pictures...',
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
                            onPressed: openAddPictureModal,
                            child: const Text('Add Picture'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ImagesTable(
                    openEditSlikaModal: openEditImageModal,
                    openDeleteModal: openDeleteModal,
                    slikaProvider: slikaProvider,
                    searchQuery: _searchQuery,
                  )
                ],
              ),
              if (isDeleteModalOpen)
                Center(
                  child: DeleteModal(
                    onDeletePressed: () {
                      deleteSlika(slikaToDelete!);
                      closeDeleteModal();
                    },
                    onCancelPressed: closeDeleteModal,
                  ),
                ),
              if (isAddPictureModalOpen)
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: AddImageModal(
                      onCancelPressed: closeAddPictureModal,
                      onAddSlikaPressed: addNewSlika,
                    ),
                  ),
                ),
              if (isEditImageModalOpen)
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: EditImageModal(
                      onCancelPressed: closeEditImageModal,
                      onSavePressed: closeEditImageModal,
                      onUpdatePressed: (id, request) {
                        updateSlika(id, request);
                      },
                      slikaToEdit: slikaToEdit,
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

class ImagesTable extends StatelessWidget {
  final void Function(Slika) openEditSlikaModal;
  final void Function(Slika) openDeleteModal;
  final SlikaProvider slikaProvider;
  final String searchQuery;

  ImagesTable({
    required this.openEditSlikaModal,
    required this.openDeleteModal,
    required this.slikaProvider,
    required this.searchQuery,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Slika>>(
      future: slikaProvider.Get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          List<Slika> filteredSlika = snapshot.data!.where((slika) {
            String imageName = '${slika.opis}';
            return imageName.toLowerCase().contains(searchQuery.toLowerCase());
          }).toList();

          return DataTable(
            columns: const [
              DataColumn(label: Text('ID')),
              DataColumn(label: Text('Description')),
              DataColumn(label: Text('Actions')),
            ],
            rows: filteredSlika.map((slika) {
              return DataRow(
                cells: [
                  DataCell(Text(slika.slikaID?.toString() ?? '')),
                  DataCell(Text(slika.opis ?? '')),
                  DataCell(
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => openEditSlikaModal(slika),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            openDeleteModal(slika);
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
