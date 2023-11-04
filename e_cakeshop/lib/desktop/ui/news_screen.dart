import 'package:e_cakeshop/desktop/modals/add_news_modal.dart'; // Import the AddNewsModal
import 'package:e_cakeshop/desktop/modals/delete_modal.dart';
import 'package:flutter/material.dart';

class NewsScreen extends StatefulWidget {
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  bool isDeleteModalOpen = false;
  bool isAddNewsModalOpen = false;

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

  @override
  Widget build(BuildContext context) {
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
                            onPressed: openAddNewsModal,
                            child: const Text('Add News'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Your DataTable and data rows for news go here
                  DataTable(
                    columns: [
                      DataColumn(label: Text('ID')),
                      DataColumn(label: Text('Title')),
                      DataColumn(label: Text('Content')),
                      DataColumn(label: Text('Thumbnail')),
                      DataColumn(label: Text('Actions')),
                    ],
                    rows: [
                      DataRow(
                        cells: [
                          DataCell(Text('ID')),
                          DataCell(Text('Title')),
                          DataCell(Text('Content')),
                          DataCell(Text('Thumbnail')),
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
                      // Add more DataRow entries for additional news
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
              if (isAddNewsModalOpen)
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: AddNewsModal(
                      onCancelPressed: closeAddNewsModal,
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
