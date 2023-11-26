import 'dart:io';
import 'package:e_cakeshop/modals/delete_modal.dart';
import 'package:e_cakeshop/models/narudzba.dart';
import 'package:e_cakeshop/providers/narudzba_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pdf/widgets.dart' as pw;

class ArchiveScreen extends StatefulWidget {
  @override
  _ArchiveScreenState createState() => _ArchiveScreenState();
}

class _ArchiveScreenState extends State<ArchiveScreen> {
  bool isDeleteModalOpen = false;
  late NarudzbaProvider arhivaProvider;
  Narudzba? arhiviranaNarudzbaToDelete;
  late String _searchQuery = '';

  void openDeleteModal(Narudzba arhiviranaNarudzba) {
    setState(() {
      isDeleteModalOpen = true;
      arhiviranaNarudzbaToDelete = arhiviranaNarudzba;
    });
  }

  void closeDeleteModal() {
    setState(() {
      isDeleteModalOpen = false;
      arhiviranaNarudzbaToDelete = null;
    });
  }

  void deleteArhiviranaNarudzba(Narudzba arhiviranaNarudzba) async {
    try {
      await arhivaProvider.delete(arhiviranaNarudzba.narudzbaID!);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Arhivirana narudzba deleted successfully'),
        ),
      );
      closeDeleteModal();
    } catch (e) {
      print("Error deleting order: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to delete arhivirana narudzba'),
        ),
      );
    }
  }

  Future<void> generatePdfReport(NarudzbaProvider arhivaProvider) async {
    try {
      final List<Narudzba> reportData =
          await arhivaProvider.Get({'includeNarudzbaProizvodi': true});

      final pdf = pw.Document();
      final List<List<dynamic>> pdfData = [];

      pdfData.add([
        'Order Number',
        'Date',
        'User',
        'Products',
        'Price',
        'Is Shipped',
        'Is Canceled',
      ]);

      for (var narudzba in reportData) {
        final products = narudzba.narudzbaProizvodi ?? 'Products N/A';
        final user = narudzba.korisnik?.ime ?? 'User N/A';

        pdfData.add([
          narudzba.brojNarudzbe?.toString() ?? '',
          narudzba.datumNarudzbe.toString(),
          user,
          products,
          narudzba.ukupnaCijena.toString(),
          narudzba.isShipped.toString(),
          narudzba.isCanceled.toString(),
        ]);
      }

      pdf.addPage(
        pw.Page(
          build: (context) {
            return pw.TableHelper.fromTextArray(
              context: context,
              data: pdfData,
            );
          },
        ),
      );

      final file = File('report.pdf');
      await file.writeAsBytes(await pdf.save());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('PDF report generated successfully'),
        ),
      );
    } catch (e) {
      print("Error generating PDF report: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to generate PDF report'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    arhivaProvider = Provider.of<NarudzbaProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Archived List', style: TextStyle(color: Colors.black)),
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
                                hintText: 'Search for archived orders...',
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
                            onPressed: () async {
                              await generatePdfReport(arhivaProvider);
                            },
                            child: const Text('Print Report'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ArchiveTable(
                    openDeleteModal: openDeleteModal,
                    arhivaProvider: arhivaProvider,
                    searchQuery: _searchQuery,
                  )
                ],
              ),
              if (isDeleteModalOpen)
                Center(
                  child: DeleteModal(
                    onDeletePressed: () {
                      deleteArhiviranaNarudzba(arhiviranaNarudzbaToDelete!);
                      closeDeleteModal();
                    },
                    onCancelPressed: () {
                      closeDeleteModal();
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class ArchiveTable extends StatelessWidget {
  final void Function(Narudzba) openDeleteModal;
  final NarudzbaProvider arhivaProvider;
  final String searchQuery;

  ArchiveTable({
    required this.openDeleteModal,
    required this.arhivaProvider,
    required this.searchQuery,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Narudzba>>(
      future: arhivaProvider.Get({'includeNarudzbaProizvodi': true}),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          List<Narudzba> archivedOrder =
              snapshot.data!.where((arhiviranaNarudzba) {
            String brojNarudzbe = '${arhiviranaNarudzba.brojNarudzbe}';
            return brojNarudzbe
                .toLowerCase()
                .contains(searchQuery.toLowerCase());
          }).toList();
          return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                child: DataTable(
                  dataRowHeight: 90.0,
                  columns: const [
                    DataColumn(label: Text('Order Number')),
                    DataColumn(label: Text('Date')),
                    DataColumn(label: Text('User')),
                    DataColumn(label: Text('Products')),
                    DataColumn(label: Text('Price')),
                    DataColumn(label: Text('Is Shipped')),
                    DataColumn(label: Text('Is Canceled')),
                    DataColumn(label: Text('Actions')),
                  ],
                  rows: archivedOrder.map((narudzba) {
                    return DataRow(
                      cells: [
                        DataCell(Text(narudzba.brojNarudzbe?.toString() ?? '')),
                        DataCell(Text(narudzba.datumNarudzbe.toString())),
                        DataCell(Text(narudzba.korisnik?.ime ?? '')),
                        DataCell(
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: narudzba.narudzbaProizvodi!
                                .split(',')
                                .map((product) => Text(product.trim()))
                                .toList(),
                          ),
                        ),
                        DataCell(Text(narudzba.ukupnaCijena.toString())),
                        DataCell(Text(narudzba.isShipped.toString())),
                        DataCell(Text(narudzba.isCanceled.toString())),
                        DataCell(
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  openDeleteModal(narudzba);
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ));
        } else {
          return const Text('No data available');
        }
      },
    );
  }
}
