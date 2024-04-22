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

  Widget _buildCategoryButton() {
    void addCategoryRow() {
      setState(() {
        _categories.add({
          'name': 'New Category',
          'assigned': 0,
          'available': newBalance,
          'isEditing': true,
        });
      });
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
                onTap: addCategoryRow,
                child: const Text('Category +',
                    style: TextStyle(color: Colors.white)),
              ),
            ),
            const DataColumn(
                label: Text('Assigned', style: TextStyle(color: Colors.white))),
            const DataColumn(
                label:
                    Text('Available', style: TextStyle(color: Colors.white))),
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
                            controller:
                                TextEditingController(text: category['name']),
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
                        : Text(category['name'],
                            style: const TextStyle(color: Colors.white)),
                  ),
                ),
                DataCell(Text('Rp. ${category['assigned']}',
                    style: const TextStyle(color: Colors.white))),
                DataCell(Text('Rp. ${category['available']}',
                    style: const TextStyle(color: Colors.white))),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}

// ignore: unused_element
void _showCategoryPopup(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: EdgeInsets.zero,
        content: Card(
          margin: EdgeInsets.zero,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Add your own Fest",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Target Type",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 2.0),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: TextField(
                              decoration: const InputDecoration(
                                hintText: 'Option 1',
                                border: InputBorder.none,
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 10.0),
                              ),
                              onChanged: (String? newValue) {
                                // Add your dropdown onChanged logic here
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Cost",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 2.0),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: TextField(
                              keyboardType: TextInputType
                                  .number, // Keyboard type for numbers
                              decoration: const InputDecoration(
                                hintText: 'Enter cost',
                                border: InputBorder.none,
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 10.0),
                              ),
                              onChanged: (String? newValue) {
                                // Handle changes in cost value here
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    "Close",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
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
