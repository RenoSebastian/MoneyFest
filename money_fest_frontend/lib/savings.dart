import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'user_data.dart';

class SavingsContent extends StatefulWidget {
  final int userId;
  const SavingsContent({Key? key, required this.userId}) : super(key: key);

  @override
  _SavingsContentState createState() => _SavingsContentState();
}

class _SavingsContentState extends State<SavingsContent> {
  final List<Map<String, dynamic>> _categories = [];
  List<int> _categoryIds = [];
  List<int> _subCategoryIds = [];
  final int _selectedCategoryIndex = -1;

  Future<void> addCategory(String categoryName) async {
    const url =
        'http://10.0.2.2:8000/api/kategori'; // Ganti dengan URL backend Anda
    final response = await http.post(
      Uri.parse(url),
      body: json.encode({
        'NamaKategori': categoryName,
        'user_id': widget.userId.toString(), // Masukkan user_id di sini
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      print('Response Data: $responseData');

      final int categoryId = responseData['data']['id'];

      setState(() {
        _categories.add({
          'id': categoryId,
          'name': categoryName,
          'user_id': widget.userId.toString(),
          'assigned': 0,
          'available': 0,
          'isEditing': true,
          'subCategories': [],
          'isExpanded': false,
        });
        _categoryIds
            .add(categoryId); // Tambahkan ID kategori ke dalam _categoryIds
      });

      if (kDebugMode) {
        print('Kategori berhasil ditambahkan dengan ID: $categoryId');
      }
    } else {
      if (kDebugMode) {
        print('Gagal menambahkan kategori');
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    }
  }

  Future<void> addSubCategory(
      int categoryId, String subcategoryName, double newAssigned) async {
    const url = 'http://10.0.2.2:8000/api/subkategori';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          'user_id': widget.userId.toString(),
          'NamaSub': subcategoryName,
          'uang': newAssigned,
          'kategori_id': categoryId,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final int subCategoryId =
            data['data']['id']; // Periksa struktur respons API

        if (kDebugMode) {
          print('SubKategori berhasil ditambahkan dengan ID: $subCategoryId');
          print('hubungan dengan kategori ID : $categoryId');
        }
      } else {
        if (kDebugMode) {
          print('Gagal menambahkan subkategori');
          print('Response status: ${response.statusCode}');
          print('Response body: ${response.body}');
        }
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error: $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildSavings();
  }

  Widget _buildSavings() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildCategoryButton(),
          ],
        ),
        // Add your savings content here
      ],
    );
  }

  // Pada widget _buildCategoryButton
  Widget _buildCategoryButton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextButton(
          onPressed: () {
            setState(() {
              _categories.clear();
            });
          },
          child: const Text(
            'Reset',
            style: TextStyle(color: Colors.white),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columnSpacing: 10.0,
            columns: [
              DataColumn(
                label: InkWell(
                  onTap: () {
                    _addCategoryRow(context);
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.add, color: Colors.white),
                      SizedBox(width: 5),
                      Text(
                        'Add Category',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              const DataColumn(
                label: Text('Assigned', style: TextStyle(color: Colors.white)),
              ),
              const DataColumn(
                label: Text('Available', style: TextStyle(color: Colors.white)),
              ),
            ],
            rows: _categories.asMap().entries.expand((entry) {
              int index = entry.key;
              Map<String, dynamic> category = entry.value;
              bool isEditing = category['isEditing'] ?? false;
              String editingCategoryName = category['name'] ?? '';
              bool isExpanded = category['isExpanded'] ?? false;
              List subCategories = category['subCategories'] ?? [];

              List<DataRow> rows = [
                DataRow(
                  cells: [
                    DataCell(
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              if (isExpanded) {
                                setState(() {
                                  category['isExpanded'] = false;
                                });
                              } else {
                                setState(() {
                                  category['isExpanded'] = true;
                                });
                              }
                            },
                            child: Icon(
                              isExpanded
                                  ? Icons.arrow_drop_up
                                  : Icons.arrow_drop_down,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 5),
                          InkWell(
                            onTap: () {
                              if (isEditing) {
                                _showCategoryNamePopup(context, index);
                              } else {
                                setState(() {
                                  category['isEditing'] = true;
                                });
                              }
                            },
                            child: isEditing
                                ? TextButton(
                                    onPressed: () {
                                      _showCategoryNamePopup(context, index);
                                    },
                                    child: Text(
                                      editingCategoryName,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  )
                                : Text(
                                    editingCategoryName,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                          ),
                          const Spacer(),
                          InkWell(
                            onTap: () {
                              _addSubCategory(
                                  index); // Menggunakan indeks kategori yang terkait
                            },
                            child: const Icon(Icons.add, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    DataCell(Text(
                      'Rp. ${_formatNumber(category['assigned'])}',
                      style: const TextStyle(color: Colors.white),
                    )),
                    DataCell(Text(
                      'Rp. ${_formatNumber(category['available'])}',
                      style: const TextStyle(color: Colors.white),
                    )),
                  ],
                ),
              ];

              if (isExpanded) {
                for (var subCategory in subCategories) {
                  rows.add(DataRow(
                    cells: [
                      DataCell(
                        Row(
                          children: [
                            const SizedBox(width: 20),
                            const Icon(Icons.arrow_right, color: Colors.white),
                            const SizedBox(width: 5),
                            InkWell(
                              onTap: () {
                                _showSubCategoryNamePopup(
                                  context,
                                  index,
                                  subCategories.indexOf(subCategory),
                                );
                              },
                              child: Text(
                                subCategory['name'],
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                      DataCell(Text(
                        'Rp. ${_formatNumber(subCategory['assigned'])}',
                        style: const TextStyle(color: Colors.white),
                      )),
                      DataCell(Text(
                        'Rp. ${_formatNumber(subCategory['available'])}',
                        style: const TextStyle(color: Colors.white),
                      )),
                    ],
                  ));
                }
              }

              return rows;
            }).toList(),
          ),
        ),
      ],
    );
  }

  void _addSubCategory(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController nameController = TextEditingController();
        TextEditingController assignedController = TextEditingController();

        return AlertDialog(
          title: const Text('Add Subcategory'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  hintText: 'Enter subcategory name',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: assignedController,
                decoration: const InputDecoration(
                  hintText: 'Enter assigned value',
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    assignedController.value = TextEditingValue(
                      text: _formatNumber(value),
                      selection: TextSelection.collapsed(
                          offset: _formatNumber(value).length),
                    );
                  }
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                String newName = nameController.text;
                double newAssigned = double.tryParse(
                        assignedController.text.replaceAll(',', '')) ??
                    0.0;

                setState(() {
                  // Tambahkan subkategori baru ke dalam list subCategories
                  _categories[index]['subCategories'].add({
                    'id': _categories[index]['subCategories'].length + 1,
                    'name': newName,
                    'assigned': newAssigned,
                    // Update total assigned for the category
                  });
                  double totalAssigned = 0.0;
                  _categories[index]['subCategories'].forEach((subCategory) {
                    totalAssigned += subCategory['assigned'];
                  });
                  _categories[index]['assigned'] = totalAssigned;
                });

                // Panggil metode addSubCategory di sini dengan index yang sesuai
                await addSubCategory(
                    _categories[index]['id'], newName, newAssigned);

                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _addCategoryRow(BuildContext context) {
    final userId = widget.userId;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController nameController = TextEditingController();

        return AlertDialog(
          title: const Text('New Category'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(
              hintText: 'Enter category name',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  String categoryName = nameController.text.isNotEmpty
                      ? nameController.text
                      : 'New Category';

                  addCategory(categoryName);
                });
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showSubCategoryNamePopup(
      BuildContext context, int categoryIndex, int subCategoryIndex) {
    TextEditingController nameController = TextEditingController();
    TextEditingController assignedController = TextEditingController();

    String subCategoryName = '';
    String subCategoryAssigned = '';

    if (subCategoryIndex != -1) {
      subCategoryName =
          _categories[categoryIndex]['subCategories'][subCategoryIndex]['name'];
      subCategoryAssigned = _categories[categoryIndex]['subCategories']
              [subCategoryIndex]['assigned']
          .toString();
    }

    nameController.text = subCategoryName;
    assignedController.text = subCategoryAssigned;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
              subCategoryIndex != -1 ? 'Edit Subcategory' : 'Add Subcategory'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  hintText: 'Enter subcategory name',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: assignedController,
                decoration: const InputDecoration(
                  hintText: 'Enter assigned value',
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    assignedController.value = TextEditingValue(
                      text: _formatNumber(value),
                      selection: TextSelection.collapsed(
                          offset: _formatNumber(value).length),
                    );
                  }
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  String newName = nameController.text;
                  double newAssigned = double.tryParse(
                          assignedController.text.replaceAll(',', '')) ??
                      0.0;

                  if (subCategoryIndex != -1) {
                    _categories[categoryIndex]['subCategories']
                        [subCategoryIndex]['name'] = newName;
                    _categories[categoryIndex]['subCategories']
                        [subCategoryIndex]['assigned'] = newAssigned;
                  } else {
                    _categories[categoryIndex]['subCategories'].add({
                      'name': newName,
                      'assigned': newAssigned,
                      // Add other properties as needed
                    });

                    // Update total assigned for the category
                    double totalAssigned = 0.0;
                    _categories[categoryIndex]['subCategories']
                        .forEach((subCategory) {
                      totalAssigned += subCategory['assigned'];
                    });
                    _categories[categoryIndex]['assigned'] = totalAssigned;
                  }
                });
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  String _formatNumber(dynamic value) {
    if (value == null) {
      return ''; // Atau nilai default lainnya sesuai dengan kebutuhan aplikasi Anda
    }
    final formatter = NumberFormat('#,###');
    return formatter.format(value is int ? value.toDouble() : value);
  }

  void _showCategoryNamePopup(BuildContext context, int index) {
    String newCategoryName = _categories[index]['name'] ?? 'New Category';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Edit Category Name"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: TextEditingController(text: newCategoryName),
                onChanged: (value) {
                  newCategoryName = value;
                },
                decoration: const InputDecoration(
                  hintText: 'Enter new category name',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _categories[index]['name'] = newCategoryName;
                });
                Navigator.of(context).pop();
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }
}
