import 'package:flutter/material.dart';

class Budget extends StatelessWidget {
  const Budget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background Container
        Container(
          color: const Color.fromRGBO(25, 23, 61,
              1), // Ganti dengan warna latar belakang yang Anda inginkan
        ),
        const Center(
          child: Text(
            "Budget",
            style: TextStyle(
              fontSize: 40, // Sesuaikan ukuran font sesuai kebutuhan Anda
              fontWeight: FontWeight.bold,
              color: Colors
                  .white, // Sesuaikan dengan warna yang sesuai dengan gambar latar belakang Anda
            ),
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
    );
  }
}
