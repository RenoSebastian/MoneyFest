// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SavingsContent extends StatefulWidget {
  final int userId;
  final Map<String, dynamic> data; // Add this line

  const SavingsContent({Key? key, required this.userId, required this.data})
      : super(key: key); // Modify constructor

  @override
  _SavingsContentState createState() => _SavingsContentState();
}

class _SavingsContentState extends State<SavingsContent> {
// Add this line
  List<Map<String, dynamic>> _categories = [];
  final List<int> _categoryIds = [];

  @override
  void initState() {
    super.initState();
// Add this line
    fetchCategories(widget.userId);
  }

  Future<void> addCategory(String categoryName) async {
    const url = 'http://10.0.2.2:8000/api/kategori';
    final response = await http.post(
      Uri.parse(url),
      body: json.encode({
        'user_id': widget.userId.toString(),
        'NamaKategori': categoryName,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (kDebugMode) {
        print('Response Data: $responseData');
      }

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
        _categoryIds.add(categoryId);
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
          'kategori_id': categoryId, // Ensure categoryId is correct
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final int subCategoryId = data['data']['id'];

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

  Future<void> fetchCategories(int userId) async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:8000/api/kategori/user/$userId'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data =
          json.decode(response.body)['data'] as List<dynamic>;
      setState(() {
        _categories.clear();
        _categories.addAll(data
            .map((category) => {
                  'id': category['id'],
                  'name': category['NamaKategori'],
                  'assigned': category['jumlah'],
                  'subCategories':
                      [], // Initialize subCategories as empty array
                })
            .toList());
      });

      // Load subcategories for each category
      for (var category in _categories) {
        await fetchSubCategories(userId, category['id']);
      }
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<void> fetchSubCategories(int userId, int categoryId) async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://10.0.2.2:8000/api/subkategori/user/$userId/$categoryId'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data =
            json.decode(response.body)['data'] as List<dynamic>;
        setState(() {
          // Find the matching category based on categoryId
          final categoryIndex = _categories
              .indexWhere((category) => category['id'] == categoryId);
          if (categoryIndex != -1) {
            // Clear existing subCategories before adding new ones
            _categories[categoryIndex]['subCategories'].clear();
            // Add subCategories fetched from server
            _categories[categoryIndex]['subCategories'].addAll(data
                .map((subCategory) => {
                      'id': subCategory['id'],
                      'name': subCategory['NamaSub'],
                      'assigned': subCategory['uang'],
                    })
                .toList());
          }
        });
      } else {
        throw Exception(
            'Failed to load subcategories. Status code: ${response.statusCode}');
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error fetching subcategories: $error');
      }
      // Display error message
      // (You can display this error message in UI or use other method to handle errors)
    }
  }

  Future<double> fetchUserBalance(int userId) async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:8000/api/balance/user/$userId'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return double.parse(data['balance']['balance']);
    } else {
      throw Exception('Failed to load balance');
    }
  }

  Future<double> _getUserBalance() async {
    try {
      return await fetchUserBalance(widget.userId);
    } catch (error) {
      if (kDebugMode) {
        print('Error fetching user balance: $error');
      }
      return 0.0; // Default value if fetching balance fails
    }
  }

  Future<void> deleteCategory(int categoryId) async {
    final url = 'http://10.0.2.2:8000/api/kategori/del/$categoryId';
    final response = await http.delete(Uri.parse(url));

    if (response.statusCode == 200) {
      setState(() {
        _categories.removeWhere((category) => category['id'] == categoryId);
      });

      if (kDebugMode) {
        print('Kategori berhasil dihapus dengan ID: $categoryId');
      }
    } else {
      if (kDebugMode) {
        print('Gagal menghapus kategori');
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    }
  }

  Future<void> deleteSubCategory(int subCategoryId) async {
    final url = 'http://10.0.2.2:8000/api/subkategori/del/$subCategoryId';
    final response = await http.delete(Uri.parse(url));

    if (response.statusCode == 200) {
      setState(() {
        _categories = _categories.map((category) {
          category['subCategories'] = category['subCategories']
              .where((subCategory) => subCategory['id'] != subCategoryId)
              .toList();
          return category;
        }).toList();
      });

      if (kDebugMode) {
        print('Subkategori berhasil dihapus dengan ID: $subCategoryId');
      }
    } else {
      if (kDebugMode) {
        print('Gagal menghapus subkategori');
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
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

  Widget _buildCategoryButton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: DataTable(
            columnSpacing: 20.0,
            columns: [
              DataColumn(
                label: InkWell(
                  onTap: () {
                    _addCategoryRow(context);
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.add, color: Colors.white),
                      SizedBox(width: 8),
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
                label: Text('', style: TextStyle(color: Colors.white)),
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
                              setState(() {
                                category['isExpanded'] =
                                    !(category['isExpanded'] ?? false);
                              });
                            },
                            child: Icon(
                              category['isExpanded'] ?? false
                                  ? Icons.arrow_drop_up
                                  : Icons.arrow_drop_down,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 8),
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
                          const SizedBox(
                              width: 20), // Add this line to create a gap
                          const SizedBox(
                              width: 20), // Add this line to create a gap
                          const Spacer(),
                          InkWell(
                            onTap: () {
                              _addSubCategory(index);
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
                    DataCell(
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.white),
                        onPressed: () {
                          deleteCategory(category['id']);
                        },
                      ),
                    ),
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
                            const SizedBox(width: 15),
                            const Icon(Icons.arrow_right, color: Colors.white),
                            const SizedBox(width: 8),
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
                            const Spacer(),
                          ],
                        ),
                      ),
                      DataCell(Text(
                        'Rp. ${_formatNumber(subCategory['assigned'])}',
                        style: const TextStyle(color: Colors.white),
                      )),
                      DataCell(
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.white),
                          onPressed: () {
                            deleteSubCategory(subCategory['id']);
                          },
                        ),
                      ),
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

  void _addSubCategory(int categoryId) {
    if (categoryId >= 0 && categoryId < _categories.length) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          TextEditingController nameController = TextEditingController();
          TextEditingController assignedController = TextEditingController();

          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      "Add Subcategory",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                        color: Color(0xFF19173D),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Subcategory Name:',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.normal,
                    color: const Color(0xFF19173D).withOpacity(0.8),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFDAD9D9),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(15.0),
                      hintText: 'Enter subcategory name',
                      hintStyle: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.normal,
                        color: const Color(0xFF19173D).withOpacity(0.5),
                      ),
                    ),
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Assigned Value:',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.normal,
                    color: const Color(0xFF19173D).withOpacity(0.8),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFDAD9D9),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: TextFormField(
                    controller: assignedController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(15.0),
                      hintText: 'Enter assigned value',
                      hintStyle: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.normal,
                        color: const Color(0xFF19173D).withOpacity(0.5),
                      ),
                    ),
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.normal,
                    ),
                  ),
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

                  double userBalance = await _getUserBalance();

                  if (newAssigned > userBalance) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            Icon(
                              Icons.warning,
                              color: Colors.white,
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'The assigned amount exceeds your balance!',
                              ),
                            ),
                          ],
                        ),
                        backgroundColor: Colors.red,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        margin: const EdgeInsets.all(10),
                        duration: const Duration(seconds: 3),
                      ),
                    );

                    return; // Stop further execution
                  }

                  await addSubCategory(
                      _categories[categoryId]['id'], newName, newAssigned);

                  setState(() {
                    if (_categories[categoryId]['subCategories'] == null) {
                      _categories[categoryId]['subCategories'] = [];
                    }
                    _categories[categoryId]['subCategories'].add({
                      'id': _categories[categoryId]['subCategories'].length + 1,
                      'name': newName,
                      'assigned': newAssigned,
                    });
                    double totalAssigned = 0.0;
                    _categories[categoryId]['subCategories']
                        .forEach((subCategory) {
                      totalAssigned += subCategory['assigned'];
                    });
                    _categories[categoryId]['assigned'] = totalAssigned;
                    _categories[categoryId]['isExpanded'] = true;
                  });

                  Navigator.of(context).pop(); // Close dialog
                },
                child: const Text('Save'),
              ),
            ],
          );
        },
      );
    } else {
      if (kDebugMode) {
        print('Invalid categoryId: $categoryId');
      }
    }
  }

  void _addCategoryRow(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController nameController = TextEditingController();

        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    "New Category",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                      color: Color(0xFF19173D),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Category Name:',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.normal,
                  color: const Color(0xFF19173D).withOpacity(0.8),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFDAD9D9),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(15.0),
                    hintText: 'Enter category name',
                    hintStyle: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.normal,
                      color: const Color(0xFF19173D).withOpacity(0.5),
                    ),
                  ),
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.normal,
                  ),
                ),
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
            subCategoryIndex != -1 ? 'Edit Subcategory' : 'Add Subcategory',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
              color: Color(0xFF19173D),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFDAD9D9),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(15.0),
                    hintText: 'Enter subcategory name',
                    hintStyle: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.normal,
                      color: const Color(0xFF19173D).withOpacity(0.5),
                    ),
                  ),
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFDAD9D9),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: TextFormField(
                  controller: assignedController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(15.0),
                    hintText: 'Enter assigned value',
                    hintStyle: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.normal,
                      color: const Color(0xFF19173D).withOpacity(0.5),
                    ),
                  ),
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.normal,
                  ),
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
                    });

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
      return '';
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
