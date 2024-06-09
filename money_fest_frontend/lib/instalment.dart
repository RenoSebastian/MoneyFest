// ignore_for_file: unused_local_variable

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
// ignore: unused_import
import 'user_data.dart';
import 'dart:convert';

class InstalmentContent extends StatefulWidget {
  final int userId;
  const InstalmentContent({Key? key, required this.userId}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _InstalmentContentState createState() => _InstalmentContentState();
}

class _InstalmentContentState extends State<InstalmentContent> {
  // ignore: unused_field
  final bool _isSavingsSelected = true; // default Savings is selected
  final List<Map<String, dynamic>> _categories = [];
  final List<int> _categoryIds = [];
  String newBalance = '';
  // ignore: unused_field
  final bool _balanceEntered = false;

  // ignore: prefer_final_fields, unused_field
  int _selectedCategoryIndex = -1;
  // ignore: unused_field
  int _selectedReminderCategoryIndex = -1; // Added this line

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchInstalments(widget.userId);
  }

  Future<void> _fetchInstalments(int userId) async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:8000/api/instalments/user/$userId'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data =
          json.decode(response.body)['data'] as List<dynamic>;
      setState(() {
        _categories.clear();
        _categories.addAll(data
            .map((instalment) => {
                  'id': instalment['id'],
                  'name': instalment['kategori'],
                  'assigned': instalment['assigned'],
                  'available': instalment['available'],
                  'isEditing': false,
                  'isExpanded': false,
                  'reminders': [],
                })
            .toList());
      });
    } else {
      throw Exception('Failed to load categories');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInstalment(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInstalment() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildCategoryButton(),
          ],
        ),
      ],
    );
  }

  void _addCategoryRow(BuildContext context, int userId) async {
    TextEditingController nameController = TextEditingController();
    TextEditingController amountNeededController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    "Add Category",
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
              const SizedBox(height: 10),
              Text(
                'Amount Needed:',
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
                  controller: amountNeededController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(15.0),
                    hintText: 'Enter yours',
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
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final response = await http.post(
                  Uri.parse('http://10.0.2.2:8000/api/create/instalments'),
                  body: {
                    'user_id': userId.toString(),
                    'kategori': nameController.text,
                    'available': amountNeededController.text,
                  },
                );

                if (response.statusCode == 201) {
                  final Map<String, dynamic> responseData =
                      json.decode(response.body);
                  final int categoryId =
                      responseData['instalment']['id']; // Capture category ID
                  setState(() {
                    _categories.add({
                      'id': categoryId, // Save category ID
                      'name': nameController.text.isNotEmpty
                          ? nameController.text
                          : 'New Category',
                      'assigned': 0.0,
                      'available':
                          double.tryParse(amountNeededController.text) ?? 0.0,
                      'isEditing': true,
                      'isExpanded': false,
                      'reminders': [],
                    });
                    _categoryIds.add(categoryId); // Save category ID
                  });
                  Navigator.of(context).pop(); // Close the dialog
                } else {
                  if (kDebugMode) {
                    print('Failed to add category: ${response.statusCode}');
                  }
                }
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
      return ''; // Or any other default value as per your application's need
    }
    final formatter = NumberFormat('#,###');
    if (value is String) {
      // Convert the String to double first before formatting
      return formatter.format(double.parse(value));
    } else {
      return formatter.format(value);
    }
  }

  void _showCategoryNamePopup(BuildContext context, int index) {
    String newCategoryName = _categories[index]['name'] ?? 'New Category';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    "Edit Category",
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
                'New Category Name:',
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
                  controller: TextEditingController(text: newCategoryName),
                  onChanged: (value) {
                    newCategoryName = value;
                  },
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

  void editCategory(BuildContext context, int index) {
    TextEditingController nameController =
        TextEditingController(text: _categories[index]['name']);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    "Edit Category",
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
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final response = await http.put(
                  Uri.parse(
                      'http://10.0.2.2:8000/api/instalments/edit/${_categories[index]['id']}'),
                  headers: {
                    'Content-Type': 'application/json',
                  },
                  body: jsonEncode({
                    'kategori': nameController.text,
                  }),
                );

                if (response.statusCode == 200) {
                  setState(() {
                    _categories[index]['name'] = nameController.text;
                  });
                  Navigator.of(context).pop(); // Close the dialog
                } else {
                  if (kDebugMode) {
                    print('Failed to edit category: ${response.statusCode}');
                  }
                  // Handle error
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'Failed to edit category: ${response.statusCode}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCategoryButton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextButton(
          onPressed: () {
            setState(() {
              _categories.clear();
              _fetchInstalments(widget.userId);
            });
            _resetInstalments(context);
          },
          child: const Text(
            'Reset',
            style: TextStyle(color: Colors.white),
          ),
        ),
        SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.vertical,
          child: DataTable(
            columnSpacing: 10.0,
            columns: [
              DataColumn(
                label: InkWell(
                  onTap: () {
                    _addCategoryRow(context, widget.userId);
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
                label: Padding(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Text(
                    'Assigned',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const DataColumn(
                label: Padding(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Text(
                    'Available',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              DataColumn(
                label: const Text(''),
              ),
            ],
            rows: _categories.asMap().entries.expand((entry) {
              int index = entry.key;
              Map<String, dynamic> category = entry.value;
              bool _isEditing = category['isEditing'] ?? false;
              String _editingCategoryName = category['name'] ?? '';

              List<DataRow> rows = [
                DataRow(
                  cells: [
                    DataCell(
                      Row(
                        children: [
                          const SizedBox(width: 5),
                          InkWell(
                            onTap: () {
                              if (_isEditing) {
                                _showCategoryNamePopup(context, index);
                              }
                            },
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    _showSetReminderPopup(context, index);
                                  },
                                  child: const Icon(Icons.notifications,
                                      color: Colors.white),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    editCategory(context, index);
                                  },
                                  child: Text(
                                    _editingCategoryName,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                                const SizedBox(width: 5),
                              ],
                            ),
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
                    DataCell(
                      SizedBox(
                        width: 30, // adjust the width as needed
                        child: IconButton(
                          icon: Icon(Icons.delete, color: Colors.white),
                          onPressed: () async {
                            final response = await http.delete(
                              Uri.parse(
                                  'http://10.0.2.2:8000/api/instalments/del/${category['id']}'),
                            );

                            if (response.statusCode == 200) {
                              setState(() {
                                _categories.removeAt(index);
                              });
                            } else {
                              if (kDebugMode) {
                                print(
                                    'Failed to delete category: ${response.statusCode}');
                              }
                              // Handle error
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Failed to delete category: ${response.statusCode}'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(
                      Row(
                        children: [
                          const SizedBox(width: 5),
                          InkWell(
                            onTap: () {
                              _addAmount(context, index);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.blue,
                              ),
                              child: const Text(
                                'Add Amount',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const DataCell(Text('')),
                    const DataCell(Text('')),
                    const DataCell(Text('')),
                  ],
                ),
              ];
              return rows;
            }).toList(),
          ),
        ),
      ],
    );
  }

  void _addAmount(BuildContext context, int index) async {
    TextEditingController addAmountController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Amount'),
          content: TextField(
            controller: addAmountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Amount'),
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
                double addAmount =
                    double.tryParse(addAmountController.text) ?? 0.0;
                if (addAmount > 0) {
                  try {
                    final response = await http.put(
                      Uri.parse(
                          'http://10.0.2.2:8000/api/instalments/${_categories[index]['id']}'),
                      headers: {
                        'Content-Type': 'application/json',
                      },
                      body: jsonEncode({
                        'assigned': addAmount,
                      }),
                    );

                    if (response.statusCode == 200) {
                      // Update local data
                      final Map<String, dynamic> responseData =
                          json.decode(response.body);
                      setState(() {
                        _categories[index]['assigned'] =
                            responseData['instalment']['assigned'];
                        _categories[index]['available'] =
                            responseData['instalment']['available'];
                      });
                      Navigator.of(context).pop();
                    } else {
                      if (kDebugMode) {
                        print('Failed to add amount: ${response.statusCode}');
                        print('Response body: ${response.body}');
                      }
                      // Handle error
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Failed to add amount: ${response.statusCode}'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  } catch (e) {
                    if (kDebugMode) {
                      print('Error: $e');
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _resetInstalments(BuildContext context) async {
    final response = await http.post(
      Uri.parse(
          'http://10.0.2.2:8000/api/reset/instalments?user_id=${widget.userId}'),
    );

    if (response.statusCode == 200) {
      // Reset berhasil
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Instalments berhasil direset'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      // Gagal melakukan reset
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal mereset instalments'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showSetReminderPopup(BuildContext context, int index) {
    List<String> reminderOptions = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];

    DateTime? instalmentDeadline;
    String? remindFrequency = reminderOptions.first;
    String notes = '';

    Future<void> _selectInstalmentDeadline() async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2101),
      );
      if (picked != null && picked != instalmentDeadline) {
        setState(() {
          instalmentDeadline = picked;
        });
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Set Reminder'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Select Instalment Deadline:'),
                  TextButton(
                    onPressed: _selectInstalmentDeadline,
                    child: Text(
                      instalmentDeadline == null
                          ? 'Select Deadline'
                          : DateFormat('dd/MM/yyyy')
                              .format(instalmentDeadline!),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text('Reminder Frequency:'),
                  DropdownButton<String>(
                    value: remindFrequency,
                    onChanged: (String? value) {
                      setState(() {
                        remindFrequency = value;
                      });
                    },
                    items: reminderOptions
                        .map((String value) => DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            ))
                        .toList(),
                  ),
                  SizedBox(height: 10),
                  Text('Notes:'),
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFDAD9D9),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: TextFormField(
                      onChanged: (value) {
                        notes = value;
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(15.0),
                        hintText: 'Add notes (optional)',
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
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: instalmentDeadline == null
                      ? null
                      : () async {
                          final Map<String, dynamic> reminderData = {
                            'user_id': widget.userId, // add user_id
                            'instalment_id': _categories[index]
                                ['id'], // add instalment_id
                            'deadline': instalmentDeadline!.toIso8601String(),
                            'frequency': remindFrequency,
                            'notes': notes,
                          };

                          print('Reminder Data: $reminderData'); // Debugging

                          final response = await http.post(
                            Uri.parse(
                                'http://10.0.2.2:8000/api/instalments/${_categories[index]['id']}/reminders'),
                            body: json.encode(reminderData),
                            headers: {'Content-Type': 'application/json'},
                          );

                          print(
                              'Response Status: ${response.statusCode}'); // Debugging
                          print('Response Body: ${response.body}'); // Debugging

                          if (response.statusCode == 201) {
                            setState(() {
                              _categories[index]['reminders'].add(reminderData);
                            });
                            Navigator.of(context).pop();
                          } else {
                            print(
                                'Failed to save reminder: ${response.statusCode}');
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Failed to save reminder: ${response.statusCode}'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                  child: Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
