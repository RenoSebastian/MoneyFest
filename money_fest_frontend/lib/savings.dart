// ignore_for_file: unused_field

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SavingsContent extends StatefulWidget {
  const SavingsContent({Key? key}) : super(key: key);

  @override
  _SavingsContentState createState() => _SavingsContentState();
}

class _SavingsContentState extends State<SavingsContent> {
  TextEditingController categoryNameController = TextEditingController();
  TextEditingController subcategoryNameController = TextEditingController();
  TextEditingController subcategoryAmountController = TextEditingController();

  int? selectedCategoryId;

  @override
  void initState() {
    super.initState();
    // Tidak perlu memuat daftar kategori pada initState
  }

  // Function to fetch categories from backend
  Future<List<Map<String, dynamic>>> fetchCategories() async {
    const url = 'http://10.0.2.2:8000/api/kategori';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body)['data'];
      return List<Map<String, dynamic>>.from(responseData);
    } else {
      print('Failed to fetch categories');
      return []; // Return empty list if fetching fails
    }
  }

  // Function to build dropdown menu for selecting category
  Future<DropdownButtonFormField<int>> _buildCategoryDropdown() async {
    final categories = await fetchCategories();

    return DropdownButtonFormField<int>(
      value: selectedCategoryId,
      onChanged: (int? value) {
        setState(() {
          selectedCategoryId = value;
        });
      },
      items: categories.map<DropdownMenuItem<int>>((category) {
        return DropdownMenuItem<int>(
          value: category['id'],
          child: Text(category['NamaKategori']),
        );
      }).toList(),
      decoration: InputDecoration(
        labelText: 'Choose category',
        border: OutlineInputBorder(),
      ),
    );
  }

  Future<void> addCategory(String categoryName) async {
    const url =
        'http://10.0.2.2:8000/api/kategori'; // Ganti dengan URL backend Anda
    final response = await http.post(
      Uri.parse(url),
      body: json.encode({'NamaKategori': categoryName}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      if (kDebugMode) {
        print('Kategori berhasil ditambahkan');
      }
    } else {
      if (kDebugMode) {
        print('Gagal menambahkan kategori');
      }
      if (kDebugMode) {
        print('Response status: ${response.statusCode}');
      }
      if (kDebugMode) {
        print('Response body: ${response.body}');
      }
    }
  }

  // Function to add subcategory
  Future<void> addSubcategory(String subcategoryName, double amount) async {
    if (selectedCategoryId == null) {
      print('Select a category first');
      return;
    }
    const url = 'http://10.0.2.2:8000/api/subkategori';
    final response = await http.post(
      Uri.parse(url),
      body: json.encode({
        'NamaSub': subcategoryName,
        'uang': amount,
        'kategori_id': selectedCategoryId,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      print('Subcategory added successfully');
    } else {
      print('Failed to add subcategory');
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
            _buildSubcategoryButton(),
          ],
        ),
        // Add your savings content here
      ],
    );
  }

  Widget _buildCategoryButton() {
    return ElevatedButton(
      onPressed: () {
        _addCategoryDialog(context);
      },
      child: Text('Add Category'),
    );
  }

  Widget _buildSubcategoryButton() {
    return ElevatedButton(
      onPressed: () {
        _addSubcategoryDialog(context);
      },
      child: Text('Add Subcategory'),
    );
  }

  void _addCategoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
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
                String categoryName = categoryNameController.text;
                addCategory(categoryName);
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _addSubcategoryDialog(BuildContext context) async {
  final categories = await fetchCategories(); // Memuat data kategori sebelum memunculkan dialog

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
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              String subcategoryName = subcategoryNameController.text;
              double amount = double.parse(subcategoryAmountController.text);
              addSubcategory(subcategoryName, amount);
              Navigator.of(context).pop();
            },
            child: Text('Save'),
          ),
        ],
      );
    },
  );
}

// Function to build dropdown menu for selecting category
Widget _buildCategoryDropdown(List<Map<String, dynamic>> categories) {
  return DropdownButtonFormField<int>(
    value: selectedCategoryId,
    onChanged: (int? value) {
      setState(() {
        selectedCategoryId = value;
      });
    },
    items: categories.map<DropdownMenuItem<int>>((category) {
      return DropdownMenuItem<int>(
        value: category['id'],
        child: Text(category['NamaKategori']),
      );
    }).toList(),
    decoration: InputDecoration(
      labelText: 'Choose category',
      border: OutlineInputBorder(),
    ),
  );
}