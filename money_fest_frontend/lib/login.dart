import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
          top: 0,
        ),
        child: Container(
          decoration: const BoxDecoration(
            color: Color.fromRGBO(25, 23, 61, 1),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'MoneyFestLogo.png',
                  width: 260,
                  height: 260,
                ),
                const SizedBox(height: 0),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset('images/Base.png', width: 314, height: 273),
                    const Positioned(
                      top: 25,
                      child: Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 190, // Ubah nilai bottom sesuai kebutuhan
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/register');
                        },
                        child: const Text(
                          'Don\'t have an Account? Register Here',
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'Poppins-Regular',
                            color: Color.fromRGBO(123, 120, 170, 1),
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 95, // Ubah nilai bottom sesuai kebutuhan
                      child: Container(
                        width: 280, // Ubah lebar sesuai kebutuhan
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            Container(
                              height: 35, // Ubah tinggi sesuai kebutuhan
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: const Color.fromRGBO(25, 23, 61, 1)
                                    .withOpacity(1),
                              ),
                              child: const TextField(
                                decoration: InputDecoration(
                                  hintText: 'Username/email',
                                  hintStyle: TextStyle(
                                    color: Color.fromRGBO(123, 120, 170, 1),
                                    fontSize: 14,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 16),
                                  alignLabelWithHint:
                                      true, // Membuat teks selaras dengan hint
                                ),
                                textAlign:
                                    TextAlign.center, // Mengatur teks ke tengah
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              height: 35, // Ubah tinggi sesuai kebutuhan
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: const Color.fromRGBO(25, 23, 61, 1)
                                    .withOpacity(1),
                              ),
                              child: const TextField(
                                decoration: InputDecoration(
                                  hintText: 'Password',
                                  hintStyle: TextStyle(
                                    color: Color.fromRGBO(123, 120, 170, 1),
                                    fontSize: 14,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 16),
                                ),
                                obscureText: true,
                                textAlign:
                                    TextAlign.center, // Mengatur teks ke tengah
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 35,
                      child: Container(
                        width: 124,
                        height: 36,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          gradient: const LinearGradient(
                            colors: [
                              Color.fromRGBO(13, 166, 194, 1),
                              Color.fromRGBO(33, 78, 226, 1)
                            ],
                          ),
                          border: Border.all(
                            color: const Color.fromRGBO(
                                67, 166, 208, 1), // warna garis pinggir
                            width: 1, // ketebalan garis pinggir
                          ),
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, '/dashboard');
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: const Text(
                            'Next',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
