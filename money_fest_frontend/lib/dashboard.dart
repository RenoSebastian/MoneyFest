import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(25, 23, 61, 1), // Warna biru dongker
      child: const Center(
        child: Text(
          'Ini Dashboard',
          style: TextStyle(
            fontSize: 24,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
