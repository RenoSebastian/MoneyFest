import 'package:flutter/material.dart';
import 'package:money_fest_frontend/services/auth_service.dart'; // Import the AuthService class

class Login extends StatelessWidget {
  Login({Key? key}) : super(key: key);

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 0),
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
                  'assets/MoneyFestLogo.png',
                  width: 260,
                  height: 260,
                ),
                const SizedBox(height: 0),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset('assets/images/Base.png',
                        width: 314, height: 273),
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
                      bottom: 190,
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
                      bottom: 95,
                      child: Container(
                        width: 280,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            Container(
                              height: 35,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: const Color.fromRGBO(25, 23, 61, 1)
                                    .withOpacity(1),
                              ),
                              child: TextField(
                                controller: usernameController,
                                decoration: const InputDecoration(
                                  hintText: 'Username/email',
                                  hintStyle: TextStyle(
                                    color: Color.fromRGBO(123, 120, 170, 1),
                                    fontSize: 14,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 12),
                                  alignLabelWithHint: true,
                                ),
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              height: 35,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: const Color.fromRGBO(25, 23, 61, 1)
                                    .withOpacity(1),
                              ),
                              child: TextField(
                                controller: passwordController,
                                decoration: const InputDecoration(
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
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.white),
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
                            color: const Color.fromRGBO(67, 166, 208, 1),
                            width: 1,
                          ),
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            AuthService().loginUser(
                                context,
                                usernameController.text,
                                passwordController.text);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
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
