// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, use_build_context_synchronously, avoid_print, prefer_const_constructors_in_immutables, deprecated_member_use
import 'package:e_cakeshop_admin/modals/add_image_modal.dart';
import 'package:e_cakeshop_admin/modals/delete_modal.dart';
import 'package:e_cakeshop_admin/modals/edit_image_modal.dart';
import 'package:e_cakeshop_admin/models/slika.dart';
import 'package:e_cakeshop_admin/providers/slika_provider.dart';
import 'package:e_cakeshop_admin/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PicturesScreen extends StatefulWidget {
  @override
  _PicturesScreenState createState() => _PicturesScreenState();
}

class _PicturesScreenState extends State<PicturesScreen> {
  bool isDeleteModalOpen = false;
  bool isAddImageModalOpen = false;
  bool _isEditImageModalOpen = false;
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

  void openAddImageModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddImageModal(
          onCancelPressed: () {
            Navigator.pop(context);
          },
          onAddSlikaPressed: addNewSlika,
        );
      },
    );
  }

  void openEditImageModal(Slika slika) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditImageModal(
          onCancelPressed: () {
            Navigator.pop(context);
          },
          onUpdatePressed: updateSlika,
          slikaToEdit: slika,
        );
      },
    );
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

  dynamic addNewSlika(Map<String, dynamic> newSlika) async {
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
      setState(() {});
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
            content: Text('Image updated successfully'),
          ),
        );
        setState(() {});
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to update Image'),
          ),
        );
      }
    } catch (e) {
      print("Error updating image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    slikaProvider = Provider.of<SlikaProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image List', style: TextStyle(color: Colors.black)),
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
                                hintText: 'Search for images...',
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
                            onPressed: openAddImageModal,
                            child: const Text(
                              'Add Image',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ImagesTable(
                      openEditSlikaModal: openEditImageModal,
                      openDeleteModal: openDeleteModal,
                      slikaProvider: slikaProvider,
                      searchQuery: _searchQuery,
                    ),
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
              if (isAddImageModalOpen)
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: AddImageModal(
                      onCancelPressed: () {
                        Navigator.pop(context);
                      },
                      onAddSlikaPressed: addNewSlika,
                    ),
                  ),
                ),
              if (_isEditImageModalOpen)
                Center(
                  child: AlertDialog(
                    content: EditImageModal(
                      onCancelPressed: () {
                        setState(() {
                          _isEditImageModalOpen = false;
                        });
                      },
                      onUpdatePressed: updateSlika,
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

  const ImagesTable({
    required this.openEditSlikaModal,
    required this.openDeleteModal,
    required this.slikaProvider,
    required this.searchQuery,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Slika>>(
      future: slikaProvider.Get({'includeKorisnik': true}),
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

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Expanded(
              child: SingleChildScrollView(
                child: DataTable(
                  dataRowHeight: 256,
                  columns: const [
                    DataColumn(
                      label: SizedBox(
                        width: 256,
                        child: Text('Image'),
                      ),
                    ),
                    DataColumn(label: Text('Description')),
                    DataColumn(label: Text('Actions')),
                  ],
                  rows: filteredSlika.map((slika) {
                    return DataRow(
                      cells: [
                        DataCell(
                          slika.slikaByte != null
                              ? SizedBox(
                                  width: 256,
                                  height: 256,
                                  child: Image.memory(
                                    dataFromBase64String(slika.slikaByte!),
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : const Text('No Image'),
                        ),
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
