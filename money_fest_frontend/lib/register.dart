import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

class Register extends StatelessWidget {
  Register({Key? key}) : super(key: key);

  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController nickNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> register(String email, String username, String nickName,
      String password, BuildContext context) async {
    final url = Uri.parse('http://10.0.2.2:8000/api/register');
    final response = await http.post(
      url,
      body: {
        'email': email,
        'username': username,
        'NickName': nickName,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      // Registrasi berhasil
      if (kDebugMode) {
        print('Registrasi berhasil: ${response.body}');
      }
      // Navigasi ke halaman dashboard setelah registrasi berhasil
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, '/dashboard');
    } else {
      // Registrasi gagal, tampilkan pesan kesalahan
      if (kDebugMode) {
        print('Registrasi gagal: ${response.body}');
      }
      // Tampilkan pesan kesalahan kepada pengguna
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Registrasi gagal')));
    }
  }

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
                _buildLogo(),
                const SizedBox(height: 0),
                _buildForm(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Image.asset(
      'assets/MoneyFestLogo.png',
      width: 160,
      height: 160,
    );
  }

  Widget _buildForm(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        _buildBackgroundImage(),
        _buildRegisterText(),
        _buildRegisterLink(context),
        _buildInputFields(),
        _buildSubmitButton(context),
      ],
    );
  }

  Widget _buildBackgroundImage() {
    return Image.asset('assets/images/Base2.png', height: 450);
  }

  Widget _buildRegisterText() {
    return const Positioned(
      top: 50, // Changed top value
      child: Text(
        'Register',
        style: TextStyle(
          fontSize: 25,
          color: Colors.white,
          fontFamily: 'Poppins',
        ),
      ),
    );
  }

  Widget _buildRegisterLink(BuildContext context) {
    return Positioned(
      bottom: 100, // Changed bottom value
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, '/');
        },
        child: const Text(
          'Already have an Account? Login',
          style: TextStyle(
            fontSize: 12,
            fontFamily: 'Poppins-Regular',
            color: Color.fromRGBO(123, 120, 170, 1),
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }

  Widget _buildInputFields() {
    return Positioned(
      bottom: 150, // Changed bottom value
      child: Container(
        width: 280,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            _buildTextField(emailController, 'Email',
                fontFamily: 'Poppins-Regular',
                fontSize: 14,
                obscureText: false),
            const SizedBox(height: 10),
            _buildTextField(usernameController, 'Username',
                fontFamily: 'Poppins-Regular',
                fontSize: 14,
                obscureText: false),
            const SizedBox(height: 10),
            _buildTextField(nickNameController, 'Nick Name',
                fontFamily: 'Poppins-Regular',
                fontSize: 14,
                obscureText: false),
            const SizedBox(height: 10),
            _buildTextField(passwordController, 'Password',
                fontFamily: 'Poppins-Regular', fontSize: 14, obscureText: true),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText,
      {String? fontFamily, bool obscureText = false, required int fontSize}) {
    return Container(
      height: 35,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: const Color.fromRGBO(25, 23, 61, 1).withOpacity(1),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Color.fromRGBO(123, 120, 170, 1),
            fontSize: 14,
          ),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        ),
        obscureText: obscureText,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return Positioned(
      bottom: 30, // Changed bottom value
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
            register(emailController.text, usernameController.text,
                nickNameController.text, passwordController.text, context);
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
    );
  }
}
