import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedMonthIndex = 0;

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
                    _buildBarChart(),
                    const SizedBox(height: 16),
                    _buildNotesContainer(),
                    const SizedBox(height: 20),
                    _buildMonthButtons(),
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
    return const Text(
      'Report',
      style: TextStyle(
        fontSize: 25,
        color: Colors.white,
        fontFamily: 'Poppins',
      ),
    );
  }

  Widget _buildBarChart() {
    return SizedBox(
      width: 350,
      height: 300,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 100,
          barTouchData: BarTouchData(enabled: false),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: SideTitles(
              showTitles: true,
              getTextStyles: (value) => const TextStyle(
                color: Color.fromRGBO(123, 120, 170, 1),
                fontSize: 14,
              ),
              margin: 10,
              getTitles: (double value) {
                switch (value.toInt()) {
                  case 0:
                    return 'Category 1';
                  case 1:
                    return 'Category 2';
                  case 2:
                    return 'Category 3';
                  case 3:
                    return 'Category 4';
                  default:
                    return '';
                }
              },
            ),
            leftTitles: SideTitles(
              showTitles: true,
              getTextStyles: (value) => const TextStyle(
                color: Color.fromRGBO(123, 120, 170, 1),
                fontSize: 14,
              ),
              getTitles: (value) {
                if (value % 10 == 0) {
                  return value.toInt().toString();
                } else {
                  return '';
                }
              },
            ),
          ),
          gridData: FlGridData(
            show: true,
            drawHorizontalLine: true,
            horizontalInterval: 25,
            checkToShowHorizontalLine: (value) => value % 25 == 0,
            getDrawingHorizontalLine: (value) => FlLine(
              color: const Color.fromARGB(255, 255, 255, 255),
              strokeWidth: 1,
            ),
          ),
          barGroups: [
            BarChartGroupData(
              x: 0,
              barRods: [
                BarChartRodData(
                  y: 25,
                  width: 35,
                  borderRadius: const BorderRadius.all(Radius.circular(6)),
                  colors: [
                    const Color.fromRGBO(33, 78, 226, 1),
                    const Color.fromRGBO(13, 166, 194, 1),
                    const Color.fromARGB(255, 136, 217, 254),
                  ],
                ),
              ],
            ),
            BarChartGroupData(
              x: 1,
              barRods: [
                BarChartRodData(
                  y: 50,
                  width: 35,
                  borderRadius: const BorderRadius.all(Radius.circular(6)),
                  colors: [
                    const Color.fromRGBO(33, 78, 226, 1),
                    const Color.fromRGBO(13, 166, 194, 1),
                    const Color.fromARGB(255, 136, 217, 254),
                  ],
                ),
              ],
            ),
            BarChartGroupData(
              x: 2,
              barRods: [
                BarChartRodData(
                  y: 75,
                  width: 35,
                  borderRadius: const BorderRadius.all(Radius.circular(6)),
                  colors: [
                    const Color.fromRGBO(33, 78, 226, 1),
                    const Color.fromRGBO(13, 166, 194, 1),
                    const Color.fromARGB(255, 136, 217, 254),
                  ],
                ),
              ],
            ),
            BarChartGroupData(
              x: 3,
              barRods: [
                BarChartRodData(
                  y: 100,
                  width: 35,
                  borderRadius: const BorderRadius.all(Radius.circular(6)),
                  colors: [
                    const Color.fromRGBO(33, 78, 226, 1),
                    const Color.fromRGBO(13, 166, 194, 1),
                    const Color.fromARGB(255, 136, 217, 254),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotesContainer() {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Notes',
            style: TextStyle(
              fontSize: 15,
              color: Color.fromRGBO(25, 23, 61, 1),
              fontFamily: 'Poppins',
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Selamat, anda telah berada di zona bebas finansial, mari hemat dan hidup bahagia bersama MoneyFest!',
            style: TextStyle(
              fontSize: 12,
              color: Color.fromRGBO(25, 23, 61, 1),
              fontFamily: 'Poppins-Regular',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthButtons() {
    return Column(
      children: [
        SizedBox(
          height: 40,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _selectedMonthIndex > 0
                    ? () {
                        setState(() {
                          _selectedMonthIndex--;
                        });
                      }
                    : null,
              ),
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _months.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _selectedMonthIndex = index;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _selectedMonthIndex == index
                              ? Colors.blue
                              : const Color.fromRGBO(25, 23, 61, 1),
                          side: const BorderSide(
                            color: Colors.grey,
                            width: 1,
                          ),
                        ),
                        child: Text(
                          _months[index],
                          style: TextStyle(
                            color: _selectedMonthIndex == index
                                ? Colors.white
                                : const Color.fromARGB(255, 132, 125, 125),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: _selectedMonthIndex < _months.length - 1
                    ? () {
                        setState(() {
                          _selectedMonthIndex++;
                        });
                      }
                    : null,
              ),
            ],
          ),
        ),
        const SizedBox(height: 80),
      ],
    );
  }
}
