import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Color.fromRGBO(25, 23, 61, 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Expanded(
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  _buildBackgroundImage(),
                  _buildInputFields(),
                  _buildTabBar(),
                  _buildUserImage(),
                  _buildProfileText(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundImage() {
    return Image.asset(
      'assets/images/Base3.png',
      width: 608,
      height: 608,
    );
  }

  Widget _buildInputFields() {
    return Positioned(
      bottom: 160,
      child: Container(
        width: 280,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            _buildTextField(),
            const SizedBox(height: 35), // Menambahkan jarak antara TextField
            _buildTextField(),
            const SizedBox(height: 35), // Menambahkan jarak antara TextField
            _buildTextField(),
            const SizedBox(height: 35), // Menambahkan jarak antara TextField
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({bool obscureText = false}) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: const Color.fromRGBO(25, 23, 61, 1).withOpacity(1),
      ),
      child: TextField(
        decoration: const InputDecoration(
          hintText: '',
          labelText: '',
          labelStyle: TextStyle(color: Color.fromRGBO(123, 120, 170, 1)),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        ),
        obscureText: obscureText,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Positioned(
      bottom: 0,
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
                      // Navigate to dashboard route
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
                      // Navigate to profile route
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
    );
  }

  Widget _buildUserImage() {
    return Positioned(
      top: 68,
      right: 95,
      child: Image.asset(
        'assets/images/User.png',
        width: 200,
        height: 200,
      ),
    );
  }

  Widget _buildProfileText() {
    return Positioned(
      top: 20,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          const Text(
            'Profile',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 25,
              color: Colors.white,
              fontFamily: 'Poppins',
            ),
          ),
          IconButton(
            onPressed: () {
              // Tambahkan logika untuk menu titik tiga
            },
            icon: const Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
