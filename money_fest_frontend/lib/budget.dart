import 'package:flutter/material.dart';

class Budget extends StatelessWidget {
  const Budget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background Container
        Container(
          color: const Color.fromRGBO(25, 23, 61, 1),
        ),
        const Center(
          child: Text(
            "Budget",
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Colors.white,
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
        Positioned(
          bottom: 20,
          right: 20,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, '/');
            },
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}
