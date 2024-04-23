import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Profile extends StatefulWidget {
  final int userId;
  const Profile({Key? key, required this.userId}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String nickname = '';
  String username = '';
  String email = '';

  @override
  void initState() {
    super.initState();
    // ignore: unnecessary_null_comparison
    if (widget.userId != null) {
      fetchUserData(widget.userId);
    }
  }

  Future<void> fetchUserData(int userId) async {
    final apiUrl = 'http://10.0.2.2:8000/api/user/$userId';
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final userData = json.decode(response.body);
      setState(() {
        nickname = userData['User']['NickName'];
        username = userData['User']['username'];
        email = userData['User']['email'];
      });
    } else {
      if (kDebugMode) {
        print('Failed to load user data');
      }
    }
  }

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
      child: SizedBox(
        width: 280,
        child: Column(
          children: [
            SizedBox(
              height: 45,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: const Color.fromRGBO(25, 23, 61, 1).withOpacity(1),
                ),
                child: Center(
                  child: Text(
                    // ignore: unnecessary_string_interpolations
                    '$nickname',
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.white.withOpacity(
                          0.5), // Opacity value can be adjusted (0.0 to 1.0)
                      fontFamily: 'Poppins-Regular',
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 35),
            SizedBox(
              height: 45,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: const Color.fromRGBO(25, 23, 61, 1).withOpacity(1),
                ),
                child: Center(
                  child: Text(
                    // ignore: unnecessary_string_interpolations
                    '$email',
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.white.withOpacity(
                          0.5), // Opacity value can be adjusted (0.0 to 1.0)
                      fontFamily: 'Poppins-Regular',
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 35),
            SizedBox(
              height: 45,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: const Color.fromRGBO(25, 23, 61, 1).withOpacity(1),
                ),
                child: Center(
                  child: Text(
                    // ignore: unnecessary_string_interpolations
                    '$username',
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.white.withOpacity(
                          0.5), // Opacity value can be adjusted (0.0 to 1.0)
                      fontFamily: 'Poppins-Regular',
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 35),
          ],
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
              // Add logic for more options menu
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
