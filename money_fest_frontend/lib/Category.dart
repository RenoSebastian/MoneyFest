import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
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

  // Dummy balance data, replace with your actual balance data
  String _balance = 'Rp. 5.000.000,00';

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
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildCategoryButton(),
                        SizedBox(width: 8),
                        Text('Assigned', style: TextStyle(color: Colors.white)),
                        SizedBox(width: 8),
                        Text('Available',
                            style: TextStyle(color: Colors.white)),
                      ],
                    ),
                    const SizedBox(height: 8),
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
    return Column(
      children: [
        Text(
          'Budget',
          style: TextStyle(
            fontSize: 25,
            color: Colors.white,
            fontFamily: 'Poppins',
          ),
        ),
      ],
    );
  }

  Widget _buildBalanceText() {
    return Text(
      '$_balance',
      style: TextStyle(
        fontSize: 18,
        color: Colors.white,
        fontFamily: 'Poppins',
      ),
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
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected
                    ? Color.fromRGBO(0, 255, 191, 1)
                    : Colors.grey, // Warna biru-hijau neon ketika ditekan
                width: 4.0, // Ubah lebar garis sesuai kebutuhan Anda
              ),
            ),
          ),
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.width *
                  0.02), // Sesuaikan padding dengan lebar layar // Sesuaikan padding dengan kebutuhan Anda
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              color: isSelected
                  ? Color.fromARGB(255, 255, 255, 255)
                  : const Color.fromARGB(255, 158, 158,
                      158), // Warna teks sesuai dengan garis saat ditekan
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
            Text('Assigned', style: TextStyle(color: Colors.white)),
            Text('Available', style: TextStyle(color: Colors.white)),
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
            Text('Assigned', style: TextStyle(color: Colors.white)),
            Text('Available', style: TextStyle(color: Colors.white)),
          ],
        ),
        // Add your instalment content here
      ],
    );
  }

  Widget _buildCategoryButton() {
    return TextButton(
      onPressed: () {
        // Menampilkan pop-up saat tombol "Category +" ditekan
        _showCategoryPopup();
      },
      child: Text(
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
          title: Text("Hello World"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "Close",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }
}

class MonthSelector extends StatefulWidget {
  final List<String> months;
  final int selectedMonthIndex;
  final Function(int) onMonthSelected;

  MonthSelector({
    required this.months,
    required this.selectedMonthIndex,
    required this.onMonthSelected,
  });

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
      padding: EdgeInsets.all(2),
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(
          color: Color.fromARGB(255, 158, 158, 158),
          width: 0.5,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back),
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
                            ? LinearGradient(
                                colors: [
                                  Colors.blue,
                                  Colors.green
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
            icon: Icon(Icons.arrow_forward),
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
      duration: Duration(milliseconds: 550),
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

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Budget App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // Gaya teks, warna, dan font yang ingin Anda tiru dari halaman Login
        textTheme: TextTheme(
          headline6: TextStyle(
            fontSize: 25,
            color: Colors.white,
            fontFamily: 'Poppins',
          ),
          bodyText1: TextStyle(
            fontSize: 15,
            color: Color.fromRGBO(25, 23, 61, 1),
            fontFamily: 'Poppins-Regular',
          ),
        ),
      ),
      home: Dashboard(),
    );
  }
}
