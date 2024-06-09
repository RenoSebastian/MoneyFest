// ignore_for_file: unused_local_variable, use_build_context_synchronously, duplicate_ignore, no_leading_underscores_for_local_identifiers

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

  @override
  void initState() {
    super.initState();
    _fetchInstalments();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildInstalment(),
          ],
        ),
        // Add your instalment content here
      ],
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
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columnSpacing: 10.0,
            columns: const [
              DataColumn(
                label: Text(
                  '',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
            rows: _categories.asMap().entries.map((entry) {
              int index = entry.key;
              Map<String, dynamic> category = entry.value;
              return DataRow(
                cells: [
                  DataCell(
                    Text(
                      category['name'],
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  void _fetchInstalments() async {
    final response = await http.get(Uri.parse(
        'http://10.0.2.2:8000/api/instalments?user_id=${widget.userId}'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _categories.clear();
        _categoryIds.clear();
        for (var instalment in data['instalments']) {
          _categories.add({
            'id': instalment['id'],
            'name': instalment['kategori'],
            'assigned': instalment['assigned'],
            'available': instalment['available'],
            'isEditing': false,
            'isExpanded': false,
            'reminders': [],
          });
          _categoryIds.add(instalment['id']);
        }
      });
    } else {
      if (kDebugMode) {
        print('Failed to fetch instalments: ${response.statusCode}');
      }
    }
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

  Widget _buildCategoryButton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextButton(
          onPressed: () {
            setState(() {
              _categories.clear();
            });
            _resetInstalments(context);
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
                                const SizedBox(width: 5),
                                Text(
                                  _editingCategoryName,
                                  style: const TextStyle(color: Colors.white),
                                ),
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
                              _addAmount(
                                context,
                                index,
                              );
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
                  final response = await http.put(
                    Uri.parse(
                        'http://10.0.2.2:8000/api/instalments/${_categoryIds[index]}'),
                    headers: {
                      'Content-Type': 'application/json',
                    },
                    body: jsonEncode({
                      'assigned': addAmount,
                    }),
                  );

                  if (response.statusCode == 200) {
                    setState(() {
                      _categories[index]['assigned'] += addAmount;
                      _categories[index]['available'] -= addAmount;
                    });
                    Navigator.of(context).pop();
                  } else {
                    if (kDebugMode) {
                      print('Failed to add amount: ${response.statusCode}');
                    }
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

    DateTime? instalmentDeadline; // Ubah tipe data menjadi DateTime
    String? remindFrequency;
    String notes = '';

    remindFrequency =
        reminderOptions.first; // Inisialisasi remindFrequency di sini

    // Function to handle the selection of instalment deadline
    // ignore: unused_element, no_leading_underscores_for_local_identifiers
    Future<void> _selectInstalmentDeadline() async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2101),
      );
      if (picked != null && picked != instalmentDeadline) {
        setState(() {
          _selectedReminderCategoryIndex =
              index; // Update selected category index
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
              // Konten dialog dan aksi di sini

              actions: [
                TextButton(
                  onPressed: () async {
                    // Buat objek Map yang berisi data pengingat
                    final Map<String, dynamic> reminderData = {
                      'deadline': instalmentDeadline
                          .toString(), // Sesuaikan dengan kolom di database
                      'frequency': remindFrequency,
                      'notes': notes,
                    };

                    // Kirim data pengingat ke backend
                    final response = await http.post(
                      Uri.parse(
                          'http://10.0.2.2:8000/api/instalments/$index/reminders'),
                      body: reminderData,
                    );

                    if (response.statusCode == 201) {
                      // Pengingat berhasil disimpan
                      if (kDebugMode) {
                        print('Reminder saved successfully');
                      }
                      // Reset selected category index after saving reminders
                      setState(() {
                        _selectedReminderCategoryIndex = -1;
                      });
                      // ignore: use_build_context_synchronously
                      Navigator.of(context).pop(); // Tutup dialog
                    } else {
                      // Gagal menyimpan pengingat
                      if (kDebugMode) {
                        print(
                            'Failed to save reminder: ${response.statusCode}');
                      }
                      // Tampilkan pesan atau tindakan lain sesuai kebutuhan aplikasi Anda
                    }
                  },
                  child: const Text("Save"),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
