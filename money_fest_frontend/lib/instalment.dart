import 'package:flutter/material.dart';

class InstalmentContent extends StatefulWidget {
  const InstalmentContent({Key? key}) : super(key: key);

  @override
  _InstalmentContentState createState() => _InstalmentContentState();
}

class _InstalmentContentState extends State<InstalmentContent> {
  bool _isSavingsSelected = true; // default Savings is selected
  final List<Map<String, dynamic>> _categories = [];
  String newBalance = '';

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

  Widget _buildCategoryButton() {
    void addCategoryRow() {
      _showSetReminderPopup(context); // Panggil _showAddBalancePopup saat tombol "Category +" ditekan
    }

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
        DataTable(
          columns: [
            DataColumn(
              label: InkWell(
                onTap: addCategoryRow, // panggil method untuk menampilkan pop-up
                child: const Text('Category +', style: TextStyle(color: Colors.white)),
              ),
            ),
            const DataColumn(label: Text('Assigned', style: TextStyle(color: Colors.white))),
            const DataColumn(label: Text('Available', style: TextStyle(color: Colors.white))),
          ],
          rows: _categories.map((category) {
            return DataRow(
              cells: [
                DataCell(
                  InkWell(
                    onTap: () {
                      setState(() {
                        category['isEditing'] = true;
                      });
                    },
                    child: category['isEditing']
                        ? TextField(
                            controller: TextEditingController(text: category['name']),
                            onChanged: (value) {
                              setState(() {
                                category['name'] = value;
                              });
                            },
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintStyle: TextStyle(color: Colors.white),
                            ),
                            style: const TextStyle(color: Colors.white),
                          )
                        : Text(category['name'], style: const TextStyle(color: Colors.white)),
                  ),
                ),
                DataCell(Text('Rp. ${category['assigned']}', style: const TextStyle(color: Colors.white))),
                DataCell(Text('Rp. ${category['available']}', style: const TextStyle(color: Colors.white))),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  void _showSetReminderPopup(BuildContext context) {
  List<String> reminderOptions = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  String? instalmentDeadline;
  String? remindFrequency;
  String? notes;

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
        instalmentDeadline = picked.toString();
      });
    }
  }

  showDialog(
    context: context,
    builder: (BuildContext context) {
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
                  instalmentDeadline ?? 'Select Deadline',
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
              Navigator.of(context).pop(); // Close the popup
            },
            child: const Text(
              'Cancel',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              // Handle saving the reminder here
              // Save the data to _categories list
              setState(() {
                _categories.add({
                  'name': notes ?? 'No notes',
                  'assigned': instalmentDeadline ?? 'No deadline',
                  'available': remindFrequency ?? '',
                });
              });
              Navigator.of(context).pop(); // Close the popup
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                gradient: const LinearGradient(
                  colors: [
                    Color.fromRGBO(13, 166, 194, 1),
                    Color.fromRGBO(33, 78, 226, 1)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Save',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    },
  );
}
}
