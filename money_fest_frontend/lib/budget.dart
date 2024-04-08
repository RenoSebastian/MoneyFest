import 'package:flutter/material.dart';

class Budget extends StatefulWidget {
  const Budget({Key? key}) : super(key: key);

  @override
  _BudgetState createState() => _BudgetState();
}

class _BudgetState extends State<Budget> {
  int _selectedMonthIndex = 0;
  bool _isSavingsSelected = true; // default Savings is selected

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

  String _balance = 'Add your balance';
  bool _balanceEntered = false; // Flag to check if balance has been entered

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 0),
        child: Container(
          decoration: const BoxDecoration(
            color: Color.fromRGBO(25, 23, 61, 1),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 30,
                left: 20,
                child: IconButton(
                  icon: const Icon(Icons.home, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
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
              Positioned(
                top: 30,
                left: 20,
                child: IconButton(
                  icon: const Icon(Icons.account_balance, color: Colors.white),
                  onPressed: () {
                    Navigator.pushNamed(context, '/dashboard');
                  },
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
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          Text(
            'Budget',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 25,
              color: Colors.white,
              fontFamily: 'Poppins',
            ),
          ),
          PopupMenuButton<String>(
            icon: Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'logout',
                child: Text('Logout'),
              ),
            ],
            onSelected: (String? value) {
              if (value == 'logout') {
                _logout();
              }
            },
          ),
        ],
      ),
    );
  }

  void _logout() {
    Navigator.pushNamed(context, '/login');
  }

  Widget _buildBalanceText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            _showEditBalancePopup(context);
          },
          child: Text(
            _balance,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontFamily: 'Poppins',
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
                    "Add Balance",
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
                  color: Color(0xFF19173D).withOpacity(0.7),
                ),
              ),
              SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFFDAD9D9),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: TextFormField(
                  onChanged: (value) {
                    setState(() {
                      _balance = value;
                      _balanceEntered = true;
                    });
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(15.0),
                  ),
                  style: TextStyle(
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
              child: Text(
                'Cancel',
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
                  gradient: LinearGradient(
                    colors: [
                      Color.fromRGBO(13, 166, 194, 1),
                      Color.fromRGBO(33, 78, 226, 1)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
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

  void _showEditBalancePopup(BuildContext context) {
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
                  color: Color(0xFF19173D).withOpacity(0.7),
                ),
              ),
              SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFFDAD9D9),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: TextFormField(
                  initialValue: _balance,
                  onChanged: (value) {
                    setState(() {
                      _balance = value;
                      _balanceEntered = true;
                    });
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(15.0),
                  ),
                  style: TextStyle(
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
              child: Text(
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
                  gradient: LinearGradient(
                    colors: [
                      Color.fromRGBO(13, 166, 194, 1),
                      Color.fromRGBO(33, 78, 226, 1)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
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
          duration: Duration(milliseconds: 300),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected
                    ? Color.fromRGBO(13, 166, 194, 1)
                    : Colors.grey,
                width: 4.0,
              ),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.width * 0.02),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: isSelected
                    ? Color.fromARGB(255, 255, 255, 255)
                    : const Color.fromARGB(255, 158, 158, 158),
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
            const Text('Assigned', style: TextStyle(color: Colors.white)),
            const Text('Available', style: TextStyle(color: Colors.white)),
          ],
        ),
        // Add your savings content here
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
            const Text('Assigned', style: TextStyle(color: Colors.white)),
            const Text('Available', style: TextStyle(color: Colors.white)),
          ],
        ),
        // Add your instalment content here
      ],
    );
  }

  Widget _buildCategoryButton() {
    return TextButton(
      onPressed: () {
        _showCategoryPopup();
      },
      child: const Text(
        'Category +',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  void _showCategoryPopup() {
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
                                keyboardType: TextInputType.number,
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
}

class MonthSelector extends StatefulWidget {
  final List<String> months;
  final int selectedMonthIndex;
  final Function(int) onMonthSelected;

  const MonthSelector({
    Key? key,
    required this.months,
    required this.selectedMonthIndex,
    required this.onMonthSelected,
  }) : super(key: key);

  @override
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
                                ],
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
