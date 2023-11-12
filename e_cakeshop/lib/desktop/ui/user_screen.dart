import 'package:e_cakeshop/desktop/modals/add_user_modal.dart';
import 'package:e_cakeshop/desktop/modals/delete_modal.dart';
import 'package:e_cakeshop/desktop/modals/edit_user_modal.dart';
import 'package:e_cakeshop/models/korisnik.dart';
import 'package:e_cakeshop/providers/korisnik_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserScreen extends StatefulWidget {
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  bool isDeleteModalOpen = false;
  bool isAddUserModalOpen = false;
  bool isEditUserModalOpen = false;
  late KorisnikProvider korisnikProvider;
  Korisnik? korisnikToDelete;
  Korisnik? korisnikToEdit;
  late String _searchQuery = '';

  void openDeleteModal(Korisnik korisnik) {
    setState(() {
      isDeleteModalOpen = true;
      korisnikToDelete = korisnik;
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

  void openEditUserModal(Korisnik korisnik) {
    setState(() {
      isEditUserModalOpen = true;
      korisnikToEdit = korisnik;
    });
  }

  void closeEditUserModal() {
    setState(() {
      isEditUserModalOpen = false;
    });
  }

  void deleteKorisnik(Korisnik korisnik) async {
    try {
      await korisnikProvider.delete(korisnik.korisnikID!);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User deleted successfully'),
        ),
      );
      setState(() {
        korisnikToDelete = null;
      });
    } catch (e) {
      print("Error deleting user: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to delete user'),
        ),
      );
    }
  }

  void addNewUser(Korisnik newUser) async {
    try {
      // Call the insert method from KorisnikProvider
      await korisnikProvider.insert(newUser);

      // Refresh the user list by calling the Get method
      setState(() {});

      // Check if the widget is still mounted before showing the SnackBar
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User added successfully'),
          ),
        );
      }
    } catch (e) {
      print("Error adding user: $e");

      // Check if the widget is still mounted before showing the SnackBar
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to add user'),
          ),
        );
      }
    }
  }

  void updateUser(int id, dynamic request) async {
    try {
      var updatedUser = await korisnikProvider.update(id, request);

      if (updatedUser != null) {
        // Handle successful update
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User updated successfully'),
          ),
        );
      } else {
        // Handle unsuccessful update
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
    korisnikProvider = Provider.of<KorisnikProvider>(context, listen: false);
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
                            onPressed: openAddUserModal,
                            child: const Text('Add User'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  UsersTable(
                    openEditUserModal: openEditUserModal,
                    openDeleteModal: openDeleteModal,
                    korisnikProvider: korisnikProvider,
                    searchQuery: _searchQuery,
                  ),
                ],
              ),
              if (isDeleteModalOpen)
                Center(
                  child: DeleteModal(
                    onDeletePressed: () {
                      deleteKorisnik(korisnikToDelete!);
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
                      onAddUserPressed: addNewUser, // Pass the callback here
                    ),
                  ),
                ),
              if (isEditUserModalOpen)
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: EditUserModal(
                      onCancelPressed: closeEditUserModal,
                      onSavePressed: closeEditUserModal,
                      onUpdatePressed: (id, request) {
                        // Call the update method from the provider here
                        updateUser(id, request);
                      },
                      korisnikToEdit:
                          korisnikToEdit, // Make sure you are passing korisnikToEdit
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

class UsersTable extends StatelessWidget {
  final void Function(Korisnik) openEditUserModal;
  final void Function(Korisnik) openDeleteModal;
  final KorisnikProvider korisnikProvider;
  final String searchQuery;

  UsersTable({
    required this.openEditUserModal,
    required this.openDeleteModal,
    required this.korisnikProvider,
    required this.searchQuery,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Korisnik>>(
      future:
          korisnikProvider.Get({'includeGrad': true, 'includeDrzava': true}),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          List<Korisnik> filteredKorisnik = snapshot.data!.where((korisnik) {
            String fullName =
                '${korisnik.ime} ${korisnik.prezime} ${korisnik.korisnickoIme}';
            return fullName.toLowerCase().contains(searchQuery.toLowerCase());
          }).toList();

          return DataTable(
            columns: const [
              DataColumn(label: Text('ID')),
              DataColumn(label: Text('Name')),
              DataColumn(label: Text('Surname')),
              DataColumn(label: Text('Username')),
              DataColumn(label: Text('Date of Birth')),
              DataColumn(label: Text('Email')),
              DataColumn(label: Text('City')),
              DataColumn(label: Text('Country')),
              DataColumn(label: Text('Telephone')),
              DataColumn(label: Text('Actions')),
            ],
            rows: filteredKorisnik.map((korisnik) {
              return DataRow(
                cells: [
                  DataCell(Text(korisnik.korisnikID.toString())),
                  DataCell(Text(korisnik.ime ?? '')),
                  DataCell(Text(korisnik.prezime ?? '')),
                  DataCell(Text(korisnik.korisnickoIme ?? '')),
                  DataCell(korisnik.datumRodjenja != null
                      ? Text(korisnik.datumRodjenja.toString())
                      : const Text('')),
                  DataCell(Text(korisnik.email ?? '')),
                  DataCell(Text(korisnik.grad?.naziv ?? '')),
                  DataCell(Text(korisnik.drzava?.naziv ?? '')),
                  DataCell(Text(korisnik.telefon ?? '')),
                  DataCell(
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => openEditUserModal(korisnik),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            openDeleteModal(korisnik);
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
