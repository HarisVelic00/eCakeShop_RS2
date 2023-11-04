import 'package:e_cakeshop/desktop/modals/add_image_modal.dart'; // Import the AddImageModal
import 'package:e_cakeshop/desktop/modals/delete_modal.dart';
import 'package:flutter/material.dart';

class PicturesScreen extends StatefulWidget {
  @override
  _PicturesScreenState createState() => _PicturesScreenState();
}

class _PicturesScreenState extends State<PicturesScreen> {
  bool isDeleteModalOpen = false;
  bool isAddPictureModalOpen = false;

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

  @override
  Widget build(BuildContext context) {
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
                            onPressed: openAddPictureModal,
                            child: const Text('Add Picture'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Your DataTable and data rows for pictures go here
                  DataTable(
                    columns: [
                      DataColumn(label: Text('ID')),
                      DataColumn(label: Text('Picture')),
                      DataColumn(label: Text('Description')),
                      DataColumn(label: Text('Actions')),
                    ],
                    rows: [
                      DataRow(
                        cells: [
                          DataCell(Text('ID')),
                          DataCell(Text('Picture')),
                          DataCell(Text('Description')),
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
                      // Add more DataRow entries for additional pictures
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
              if (isAddPictureModalOpen)
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: AddImageModal(
                      onCancelPressed: closeAddPictureModal,
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
