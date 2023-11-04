import 'package:e_cakeshop/desktop/modals/add_user_modal.dart';
import 'package:e_cakeshop/desktop/modals/delete_modal.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: UserScreen(),
  ));
}

class UserScreen extends StatefulWidget {
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  bool isDeleteModalOpen = false;
  bool isAddUserModalOpen = false;

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

  void openAddUserModal() {
    setState(() {
      isAddUserModalOpen = true;
    });
  }

  void closeAddUserModal() {
    setState(() {
      isAddUserModalOpen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users List', style: TextStyle(color: Colors.black)),
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
                                hintText: 'Search for users...',
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
                            onPressed:
                                openAddUserModal, // Open the AddUserModal
                            child: const Text('Add User'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  DataTable(
                    columns: [
                      DataColumn(label: Text('ID')),
                      DataColumn(label: Text('Name')),
                      DataColumn(label: Text('Surname')),
                      DataColumn(label: Text('Username')),
                      DataColumn(label: Text('Date of Birth')),
                      DataColumn(label: Text('Email')),
                      DataColumn(label: Text('Telephone')),
                      DataColumn(label: Text('City')),
                      DataColumn(label: Text('Country')),
                      DataColumn(
                          label: Text('Actions')), // New column for actions
                    ],
                    rows: [
                      DataRow(
                        cells: [
                          DataCell(Text('1')),
                          DataCell(Text('John')),
                          DataCell(Text('Doe')),
                          DataCell(Text('johndoe')),
                          DataCell(Text('01/01/1990')),
                          DataCell(Text('john.doe@example.com')),
                          DataCell(Text('123-456-7890')),
                          DataCell(Text('New York')),
                          DataCell(Text('USA')),
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
                                  onPressed:
                                      openDeleteModal, // Open the DeleteModal
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      // Add more DataRow entries for additional users
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
                    onCancelPressed: closeDeleteModal,
                  ),
                ),
              if (isAddUserModalOpen)
                Center(
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: AddUserModal(
                        onCancelPressed: closeAddUserModal,
                      )),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
