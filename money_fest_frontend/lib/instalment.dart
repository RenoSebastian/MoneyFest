import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InstalmentContent extends StatefulWidget {
  const InstalmentContent({Key? key}) : super(key: key);

  @override
  _InstalmentContentState createState() => _InstalmentContentState();
}

class _InstalmentContentState extends State<InstalmentContent> {
  bool _isSavingsSelected = true; // default Savings is selected
  final List<Map<String, dynamic>> _categories = [];
  String newBalance = '';
  bool _balanceEntered = false;

  int _selectedCategoryIndex = -1;
  int _selectedReminderCategoryIndex = -1; // Add this variable to track selected category index for setting reminder

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
        // Add your savings content here
      ],
    );
  }

  void _addCategoryRow(BuildContext context) {
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
              Padding(
                padding: const EdgeInsets.all(8.0),
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
              SizedBox(height: 10),
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
              SizedBox(height: 10),
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
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  String categoryName = nameController.text.isNotEmpty
                      ? nameController.text
                      : 'New Category';

                  double amountNeeded = double.tryParse(amountNeededController.text) ?? 0.0;

                  _categories.add({
                    'name': categoryName,
                    'assigned': 0.0,
                    'available': amountNeeded,
                    'isEditing': true,
                    'isExpanded': false,
                    'reminders': []
                  });
                });
                Navigator.of(context).pop();
              },
              child: Text('Save'),
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
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
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
              SizedBox(height: 10),
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
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _categories[index]['name'] = newCategoryName;
                });
                Navigator.of(context).pop();
              },
              child: Text("Save"),
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
                  child: Row(
                    children: [
                      Icon(Icons.add, color: Colors.white),
                      const SizedBox(width: 5),
                      const Text(
                        'Add Category',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              DataColumn(
                label: Padding(
                  padding: const EdgeInsets.only(left: 20.0), // Atur padding kiri di sini
                  child: const Text(
                    'Assigned',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              DataColumn(
                label: Padding(
                  padding: const EdgeInsets.only(left: 20.0), // Atur padding kiri di sini
                  child: const Text(
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
                          SizedBox(width: 5),
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
                                  child: Icon(Icons.notifications, color: Colors.white),
                                ),
                                SizedBox(width: 5),
                                Text(
                                  _editingCategoryName,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    DataCell(Text(
                      'Rp. ${_formatNumber(category['assigned'])}',
                      style: TextStyle(color: Colors.white),
                    )),
                    DataCell(Text(
                      'Rp. ${_formatNumber(category['available'])}',
                      style: TextStyle(color: Colors.white),
                    )),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(
                      Row(
                        children: [
                          SizedBox(width: 5),
                          InkWell(
                            onTap: () {
                              // Add your logic here to handle adding amount
                              _addAmount(context, index); // Panggil fungsi _addAmount dengan memberikan context dan index kategori
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.blue,
                              ),
                              child: Text(
                                'Add Amount',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    DataCell(Text('')), // Hapus kolom Assigned
                    DataCell(Text('')), // Hapus kolom Available
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

  void _addAmount(BuildContext context, int index) {
    TextEditingController addAmountController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    "Assign Amount",
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
              SizedBox(height: 10),
              Text(
                'How much do u have right now?',
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
                  controller: addAmountController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(15.0),
                    hintText: 'Assigned your Amount',
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
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Get the amount to add
                double addAmount = double.tryParse(addAmountController.text) ?? 0.0;
                // Update the 'Assigned' value in the relevant category
                setState(() {
                  double currentAssigned = _categories[index]['assigned'] ?? 0.0;
                  _categories[index]['assigned'] = currentAssigned + addAmount;
                  // Subtract the 'Available' value by the added amount
                  _categories[index]['available'] -= addAmount;
                });
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
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

    remindFrequency = reminderOptions.first; // Inisialisasi remindFrequency di sini

    // Function to handle the selection of instalment deadline
    Future<void> _selectInstalmentDeadline() async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2101),
      );
      if (picked != null && picked != instalmentDeadline) {
        setState(() {
          _selectedReminderCategoryIndex = index; // Update selected category index
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
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          "Set Reminder",
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
                    SizedBox(height: 10),
                    Text(
                      'Instalment Deadline:',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.normal,
                        color: const Color(0xFF19173D).withOpacity(0.8),
                      ),
                    ),
                    // TextButton to trigger the calendar selection
                    TextButton(
                      onPressed: _selectInstalmentDeadline,
                      child: Text(
                        instalmentDeadline != null ? DateFormat('yyyy-MM-dd').format(instalmentDeadline!) : 'Select Deadline',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.normal,
                          color: const Color(0xFF19173D),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Remind Me:',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.normal,
                        color: const Color(0xFF19173D).withOpacity(0.8),
                      ),
                    ),
                    // Dropdown for remind frequency (Every day, every week, etc.)
                    DropdownButton<String>(
                      value: remindFrequency,
                      onChanged: (String? newValue) {
                        setState(() {
                          remindFrequency = newValue;
                        });
                      },
                      items: reminderOptions.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.normal,
                              color: const Color(0xFF19173D),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Notes:',
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
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(15.0),
                          hintText: 'Enter notes',
                          hintStyle: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.normal,
                            color: const Color(0xFF19173D).withOpacity(0.5),
                          ),
                        ),
                        onChanged: (value) {
                          notes = value;
                        },
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the popup
                  },
                  child: const Text(
                    'Delete',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.normal,
                      color: Colors.red,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    if (instalmentDeadline == null) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Validation Error'),
                            content: Text(
                              'Please select instalment deadline before saving.',
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      // Handle saving the reminder here
                      // Save the data to _categories list
                      setState(() {
                        _categories[index]['reminders'] ??= [];
                        _categories[index]['reminders'].add({
                          'deadline': instalmentDeadline,
                          'frequency': remindFrequency,
                          'notes': notes,
                        });
                      });

                      // Show confirmation message
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Reminder Saved'),
                            content: Text(
                              'You will be reminded every $remindFrequency until the deadline on ${DateFormat('yyyy-MM-dd').format(instalmentDeadline!)}',
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop(); // Close the popup
                                },
                                child: Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  child: const Text(
                    'Save',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
