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
  final List<int> _categoryIds = [];
  final List<int> _subCategoryIds = [];
  final int _selectedCategoryIndex = -1;

  @override
  void initState() {
    super.initState();
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
      print('Error fetching subcategories: $error');
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
        TextButton(
          onPressed: () {
            setState(() {
              // Mengosongkan daftar kategori lokal
              _categories.clear();
              // Memuat kembali kategori dari server
              fetchCategories(widget.userId);
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
              bool isEditing =
                  category['isEditing'] != null ? category['isEditing'] : false;
              String editingCategoryName =
                  category['name'] != null ? category['name'] : '';
              bool isExpanded = category['isExpanded'] != null
                  ? category['isExpanded']
                  : false;
              List subCategories = category['subCategories'] != null
                  ? category['subCategories']
                  : [];

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
                              _addSubCategory(index); // Using category ID
                            },
                            child: const Icon(Icons.add, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    DataCell(Text(
                      'Rp. ${_formatNumber(category['assigned']) ?? 0}',
                      style: const TextStyle(color: Colors.white),
                    )),
                    DataCell(Text(
                      'Rp. ${_formatNumber(category['available']) ?? 0}',
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
                        'Rp. ${_formatNumber(subCategory['assigned']) ?? 0}',
                        style: const TextStyle(color: Colors.white),
                      )),
                      DataCell(Text(
                        'Rp. ${_formatNumber(subCategory['available']) ?? 0}',
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

  void _addSubCategory(int categoryId) {
    if (categoryId >= 0 && categoryId < _categories.length) {
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
                        content: const Row(
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
                        margin: EdgeInsets.all(10),
                        duration: Duration(seconds: 3),
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
      print('Invalid categoryId: $categoryId');
    }
  }

  void _addCategoryRow(BuildContext context) {
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
