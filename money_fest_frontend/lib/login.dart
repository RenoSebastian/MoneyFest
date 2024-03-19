import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

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
                'Ini Halaman Login',
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
              const SizedBox(
                  height:
                      16), // Memberi jarak antara tombol dan teks berikutnya
              GestureDetector(
                onTap: () {
                  // Navigasi ke halaman pendaftaran
                  Navigator.pushNamed(context, '/register');
                },
                child: const Text(
                  'Belum memiliki akun?, klik disini untuk daftar',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
