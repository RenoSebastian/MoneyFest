import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Budget extends StatefulWidget {
  const Budget({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _BudgetState createState() => _BudgetState();
}

class _BudgetState extends State<Budget> {
  int _selectedMonthIndex = 0;
  bool _isSavingsSelected = true; // default Savings is selected
  final List<Map<String, dynamic>> _categories = [];
  int _selectedCategoryIndex = -1;

  final List<String> _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];

  // Dummy balance data, replace with your actual balance data
  String _balance = 'Add your balance';
  String newBalance = '';
  // ignore: unused_field
  bool _balanceEntered = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Color.fromRGBO(25, 23, 61, 1),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
              top: 50), // Sesuaikan dengan jarak yang diinginkan dari atas
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildReportText(),
                    const SizedBox(height: 8),
                    _buildBalanceText(),
                    const SizedBox(height: 16),
                    _buildMonthSelector(),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildOption('Savings', _isSavingsSelected),
                        _buildOption('Instalment', !_isSavingsSelected),
                      ],
                    ),
                    _buildContent()
                  ],
                ),
              ),
              Positioned(
                bottom: -9,
                left: 2,
                right: 0,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Image.asset(
                      'assets/images/tabBar.png',
                      fit: BoxFit.contain,
                      width: MediaQuery.of(context).size.width,
                      height: 100,
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            InkWell(
                              onTap: () {
                                // Navigate to budget route
                                Navigator.pushNamed(context, '/dashboard');
                              },
                              child: Image.asset(
                                'assets/images/home.png',
                                width: 50,
                                height: 50,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                // Navigate to budget route
                                Navigator.pushNamed(context, '/budget');
                              },
                              child: Image.asset(
                                'assets/images/card.png',
                                width: 50,
                                height: 50,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                // Navigate to budget route
                                Navigator.pushNamed(context, '/profile');
                              },
                              child: Image.asset(
                                'assets/images/profile.png',
                                width: 50,
                                height: 50,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 25),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReportText() {
    return Positioned(
      top: 20,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          const Text(
            'Budget',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 25,
              color: Colors.white,
              fontFamily: 'Poppins',
            ),
          ),
          PopupMenuButton<String>(
            icon: const Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[],
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            _showEditBalancePopup(context);
          },
          child: FittedBox(
            child: Text(
              _balance,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontFamily: 'Poppins',
              ),
            ),
          ),
        ),
        IconButton(
          icon: Image.asset(
            'assets/images/plus.png',
            width: 20,
            height: 20,
          ),
          onPressed: () {
            _showAddBalancePopup(context);
          },
        ),
      ],
    );
  }

  void _showAddBalancePopup(BuildContext context) {
    String? newBalance;

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
                    "Add Balance",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily:
                          'Poppins', // Mengatur jenis font menjadi Poppins
                      color: Color(0xFF19173D), // Warna teks
                    ),
                  ),
                ),
              ),
              Text(
                'How many do you have?',
                style: TextStyle(
                  fontFamily: 'Poppins', // Mengatur jenis font menjadi Poppins
                  fontWeight: FontWeight.normal, // Mengatur teks menjadi normal
                  color: const Color(0xFF19173D)
                      .withOpacity(0.7), // Transparansi 70%
                ),
              ),
              const SizedBox(height: 10), // Spasi antara elemen
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFDAD9D9), // Warna abu muda
                  borderRadius: BorderRadius.circular(8.0), // Radius sudut
                ),
                child: TextFormField(
                  decoration: InputDecoration(
                    border: InputBorder.none, // Menghapus border
                    contentPadding:
                        const EdgeInsets.all(15.0), // Padding untuk teks
                    hintText: 'Masukkan jumlah saldo',
                    hintStyle: TextStyle(
                      fontFamily:
                          'Poppins', // Mengatur jenis font menjadi Poppins
                      fontWeight:
                          FontWeight.normal, // Mengatur teks menjadi normal
                      color: const Color(0xFF19173D)
                          .withOpacity(0.5), // Transparansi 50%
                    ),
                  ),
                  onChanged: (value) {
                    newBalance = value;
                  },
                  style: const TextStyle(
                    fontFamily:
                        'Poppins', // Mengatur jenis font menjadi Poppins
                    fontWeight:
                        FontWeight.normal, // Mengatur teks menjadi normal
                  ),
                ),
              ),
              // Tambah elemen-elemen lainnya sesuai kebutuhan
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup popup
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  fontFamily: 'Poppins', // Mengatur jenis font menjadi Poppins
                  fontWeight: FontWeight.normal, // Mengatur teks menjadi normal
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                int? parsedBalance = int.tryParse(newBalance ?? '');
                if (parsedBalance != null) {
                  setState(() {
                    _balance = NumberFormat.currency(
                      locale: 'id',
                      symbol: 'Rp. ',
                      decimalDigits: 0,
                    ).format(parsedBalance);
                  });
                }
                Navigator.of(context).pop(); // Tutup popup setelah selesai
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                      20.0), // Atur radius sesuai keinginan
                  gradient: const LinearGradient(
                    colors: [
                      Color.fromRGBO(13, 166, 194, 1),
                      Color.fromRGBO(33, 78, 226, 1)
                    ],
                    // Ubah warna gradient sesuai kebutuhan Anda
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
                      fontFamily:
                          'Poppins', // Mengatur jenis font menjadi Poppins
                      fontWeight:
                          FontWeight.normal, // Mengatur teks menjadi normal
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

  void _showEditBalancePopup(BuildContext context) {
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
                    "Edit Balance",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFF19173D),
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ),
              Text(
                'How many do you have?',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.normal,
                  color: const Color(0xFF19173D).withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFDAD9D9),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: TextFormField(
                  initialValue: _balance
                      .replaceAll('Rp. ', '')
                      .replaceAll('.', ''), // Remove currency symbol and dot
                  onChanged: (value) {
                    setState(() {
                      // ignore: prefer_interpolation_to_compose_strings
                      _balance = 'Rp. ' +
                          NumberFormat.decimalPattern('id').format(int.parse(
                              value)); // Format new balance with currency symbol and dot
                      _balanceEntered = true;
                    });
                  },
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(15.0),
                  ),
                  keyboardType: TextInputType.number,
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
                setState(() {
                  _balance = 'Add your balance'; // Reset balance
                  _balanceEntered = false; // Reset balance entered flag
                });
                Navigator.of(context).pop();
              },
              child: const Text(
                'Reset',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
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

  Widget _buildMonthSelector() {
    return MonthSelector(
      months: _months,
      selectedMonthIndex: _selectedMonthIndex,
      onMonthSelected: (index) {
        setState(() {
          _selectedMonthIndex = index;
        });
      },
    );
  }

  Widget _buildOption(String text, bool isSelected) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _isSavingsSelected = text == 'Savings';
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected
                    ? const Color.fromRGBO(13, 166, 194, 1)
                    : Colors.grey, // Warna biru-hijau neon ketika ditekan
                width: 4.0, // Ubah lebar garis sesuai kebutuhan Anda
              ),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.width *
                    0.02), // Sesuaikan padding dengan lebar layar // Sesuaikan padding dengan kebutuhan Anda
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: isSelected
                    ? const Color.fromARGB(255, 255, 255, 255)
                    : const Color.fromARGB(255, 158, 158,
                        158), // Warna teks sesuai dengan garis saat ditekan
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return _isSavingsSelected ? _buildSavings() : _buildInstalment();
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

  Widget _buildInstalment() {
    return const Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Category +', style: TextStyle(color: Colors.white)),
            Text('Assigned', style: TextStyle(color: Colors.white)),
            Text('Available', style: TextStyle(color: Colors.white)),
          ],
        ),
        // Add your instalment content here
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
          title: Text('Add Subcategory'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: 'Enter subcategory name',
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: assignedController,
                decoration: InputDecoration(
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
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  String newName = nameController.text;
                  double newAssigned = double.tryParse(
                          assignedController.text.replaceAll(',', '')) ??
                      0.0;

                  _categories[index]['subCategories'].add({
                    'name': newName,
                    'assigned': newAssigned,
                    // Add other properties as needed
                  });

                  // Update total assigned for the category
                  double totalAssigned = 0.0;
                  _categories[index]['subCategories'].forEach((subCategory) {
                    totalAssigned += subCategory['assigned'];
                  });
                  _categories[index]['assigned'] = totalAssigned;
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

  void _addCategoryRow(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController nameController = TextEditingController();

        return AlertDialog(
          title: Text('New Category'),
          content: TextField(
            controller: nameController,
            decoration: InputDecoration(
              hintText: 'Enter category name',
            ),
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

                  _categories.add({
                    'name': categoryName,
                    'assigned': 0,
                    'available': 0,
                    'isEditing': true,
                    'subCategories': [],
                    'isExpanded': false,
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
                decoration: InputDecoration(
                  hintText: 'Enter subcategory name',
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: assignedController,
                decoration: InputDecoration(
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
              child: Text('Cancel'),
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
          title: Text("Edit Category Name"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: TextEditingController(text: newCategoryName),
                onChanged: (value) {
                  newCategoryName = value;
                },
                decoration: InputDecoration(
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
              bool _isEditing = category['isEditing'] ?? false;
              String _editingCategoryName = category['name'] ?? '';
              bool _isExpanded = category['isExpanded'] ?? false;
              List subCategories = category['subCategories'] ?? [];

              List<DataRow> rows = [
                DataRow(
                  cells: [
                    DataCell(
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              if (_isExpanded) {
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
                              _isExpanded
                                  ? Icons.arrow_drop_up
                                  : Icons.arrow_drop_down,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 5),
                          InkWell(
                            onTap: () {
                              if (_isEditing) {
                                _showCategoryNamePopup(context, index);
                              } else {
                                setState(() {
                                  category['isEditing'] = true;
                                });
                              }
                            },
                            child: _isEditing
                                ? TextButton(
                                    onPressed: () {
                                      _showCategoryNamePopup(context, index);
                                    },
                                    child: Text(
                                      _editingCategoryName,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  )
                                : Text(
                                    _editingCategoryName,
                                    style: TextStyle(color: Colors.white),
                                  ),
                          ),
                          Spacer(),
                          InkWell(
                            onTap: () {
                              _addSubCategory(index);
                            },
                            child: Icon(Icons.add, color: Colors.white),
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
              ];

              if (_isExpanded) {
                for (var subCategory in subCategories) {
                  rows.add(DataRow(
                    cells: [
                      DataCell(
                        Row(
                          children: [
                            SizedBox(width: 20),
                            Icon(Icons.arrow_right, color: Colors.white),
                            SizedBox(width: 5),
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
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                      DataCell(Text(
                        'Rp. ${_formatNumber(subCategory['assigned'])}',
                        style: TextStyle(color: Colors.white),
                      )),
                      DataCell(Text(
                        'Rp. ${_formatNumber(subCategory['available'])}',
                        style: TextStyle(color: Colors.white),
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
}

class MonthSelector extends StatefulWidget {
  final List<String> months;
  final int selectedMonthIndex;
  final Function(int) onMonthSelected;

  const MonthSelector({
    super.key,
    required this.months,
    required this.selectedMonthIndex,
    required this.onMonthSelected,
  });

  @override
  // ignore: library_private_types_in_public_api
  _MonthSelectorState createState() => _MonthSelectorState();
}

class _MonthSelectorState extends State<MonthSelector> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController(
      initialScrollOffset: (widget.selectedMonthIndex * 60).toDouble(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color.fromARGB(255, 158, 158, 158),
          width: 0.5,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: widget.selectedMonthIndex > 0
                ? () => _scrollToMonth(widget.selectedMonthIndex - 1)
                : null,
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              controller: _scrollController,
              child: Row(
                children: widget.months.map((month) {
                  final index = widget.months.indexOf(month);
                  return GestureDetector(
                    onTap: () => widget.onMonthSelected(index),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        gradient: widget.selectedMonthIndex == index
                            ? const LinearGradient(
                                colors: [
                                  Color.fromRGBO(13, 166, 194, 1),
                                  Color.fromRGBO(33, 78, 226, 1)
                                ], // Ubah warna gradient sesuai kebutuhan Anda
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                            : null,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        month,
                        style: TextStyle(
                          color: widget.selectedMonthIndex == index
                              ? Colors.white
                              : const Color.fromARGB(255, 158, 158, 158),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: widget.selectedMonthIndex < widget.months.length - 1
                ? () => _scrollToMonth(widget.selectedMonthIndex + 1)
                : null,
          ),
        ],
      ),
    );
  }

  void _scrollToMonth(int index) {
    _scrollController.animateTo(
      index * 65.0,
      duration: const Duration(milliseconds: 550),
      curve: Curves.easeInOut,
    );
    widget.onMonthSelected(index);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
