import 'package:flutter/material.dart';

class Register extends StatelessWidget {
  const Register({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Color.fromRGBO(25, 23, 61, 1),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Ini Halaman Register',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // Navigasi ke halaman dashboard
                  Navigator.pushReplacementNamed(context, '/dashboard');
                },
                child: const Text('Next'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
