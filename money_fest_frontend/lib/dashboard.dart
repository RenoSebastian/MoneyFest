import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedMonthIndex = 0; // Indeks bulan yang dipilih

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
                  icon: Icon(Icons.home, color: Colors.white),
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
                    const SizedBox(height: 20), // Jarak antara catatan dan daftar tombol bulan
                    _buildMonthButtons(),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Image.asset(
                      'images/tabBar.png', // Sesuaikan dengan path gambar Anda
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
                            Center(
                              child: Image.asset('images/home.png', width: 50, height: 50), // Ganti path gambar dengan yang sesuai
                            ),
                            Center(
                              child: Image.asset('images/card.png', width: 50, height: 50), // Ganti path gambar dengan yang sesuai
                            ),
                            Center(
                              child: Image.asset('images/profile.png', width: 50, height: 50), // Ganti path gambar dengan yang sesuai
                            ),
                          ],
                        ),
                        SizedBox(height: 25), // Tambahkan jarak sebesar 5 ke bawah
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
    return Text(
      'Report',
      style: TextStyle(
        fontSize: 25,
        color: Colors.white,
        fontFamily: 'Poppins',
      ),
    );
  }

  Widget _buildBarChart() {
    return Container(
      width: 400,
      height: 300,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 100, // Set max Y value
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
            ),
          ),
          gridData: FlGridData(
            show: true,
            drawHorizontalLine: true,
            horizontalInterval: 25,
            checkToShowHorizontalLine: (value) => value % 25 == 0,
            getDrawingHorizontalLine: (value) => FlLine(
              color: Color.fromRGBO(239, 239, 241, 0.298),
              strokeWidth: 1,
            ),
          ),
          barGroups: [
            BarChartGroupData(
              x: 0,
              barRods: [
                BarChartRodData(
                  y: 25, // Set Y value to 25%
                  width: 35,
                  borderRadius: const BorderRadius.all(Radius.circular(6)),
                  colors: [
                    Colors.blue[900]!,
                    Colors.lightBlue[300]!,
                    Colors.lightBlue[100]!,
                  ],
                ),
              ],
            ),

            BarChartGroupData(
              x: 1,
              barRods: [
                BarChartRodData(
                  y: 50, // Set Y value to 50%
                  width: 35,
                  borderRadius: const BorderRadius.all(Radius.circular(6)),
                  colors: [
                      Colors.blue[900]!,
                      Colors.lightBlue[300]!,
                      Colors.lightBlue[100]!,
                    ],
                ),
              ],
            ),
            BarChartGroupData(
              x: 2,
              barRods: [
                BarChartRodData(
                  y: 75, // Set Y value to 75%
                  width: 35,
                  borderRadius: const BorderRadius.all(Radius.circular(6)),
                  colors: [
                    Colors.blue[900]!,
                    Colors.lightBlue[300]!,
                    Colors.lightBlue[100]!,
                  ],
                ),
              ],
            ),
            BarChartGroupData(
              x: 3, // Perbaikan: Mengubah nilai x menjadi 3
              barRods: [
                BarChartRodData(
                  y: 100, // Set Y value to 100%
                  width: 35,
                  borderRadius: const BorderRadius.all(Radius.circular(6)),
                  colors:[
                    Colors.blue[900]!,
                    Colors.lightBlue[300]!,
                    Colors.lightBlue[100]!,
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
      child: Column(
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
              fontSize: 14,
              color: Color.fromRGBO(25, 23, 61, 1),
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }

    Widget _buildMonthButtonsContainer() {
    return Container(
      height: 110,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey, // Warna garis luar (stroke)
          width: 1, // Ketebalan garis luar
        ),
      ),
      child: _buildMonthButtons(), // Panggil fungsi yang telah Anda buat sebelumnya
    );
  }


  Widget _buildMonthButtons() {
  return Positioned(
    top: MediaQuery.of(context).size.height / 2 - 20, // Set ke tengah vertikal
    left: 0,
    right: 0,
    child: Column(
      children: [
        Container(
          height: 40,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center, // Pusatkan secara horizontal
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: _selectedMonthIndex > 0
                    ? () {
                        setState(() {
                          _selectedMonthIndex--;
                        });
                      }
                    : null, // Tombol tidak aktif jika sudah di bulan pertama
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
                          primary: _selectedMonthIndex == index
                              ? Colors.blue
                              : Color.fromRGBO(25, 23, 61, 1), // Mengubah warna menjadi transparan
                          side: BorderSide(
                            color: Colors.grey, // Tetap menggunakan warna abu-abu untuk border
                            width: 1, // Ketebalan border
                          ),
                        ),
                        child: Text(
                          _months[index],
                          style: TextStyle(
                            color: _selectedMonthIndex == index
                                ? Colors.white // Ganti warna teks menjadi putih jika dipilih
                                : Color.fromARGB(255, 132, 125, 125), // Ganti warna teks menjadi hitam jika tidak dipilih
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              IconButton(
                icon: Icon(Icons.arrow_forward),
                onPressed: _selectedMonthIndex < _months.length - 5
                    ? () {
                        setState(() {
                          _selectedMonthIndex += 5;
                        });
                      }
                    : null, // Tombol tidak aktif jika sudah di bulan terakhir
              ),
            ],
          ),
        ),
        SizedBox(height: 80), // Tambahkan jarak sebesar lima di bawah daftar tombol bulan
      ],
    ),
  );
}
}
