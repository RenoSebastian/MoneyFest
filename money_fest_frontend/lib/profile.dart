import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:money_fest_frontend/services/auth_service.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:image_picker/image_picker.dart';

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
  String? profileImageUrl;
  File? _image;

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

        // Penanganan untuk menghindari pembuatan URL dengan nilai null
        String? imagePath = userData['User']['profile_image'];
        if (imagePath != null) {
          profileImageUrl = 'http://10.0.2.2:8000/storage/$imagePath';
        } else {
          // Atau jika imagePath null, set profileImageUrl menjadi null juga
          profileImageUrl = null;
        }
      });
      if (kDebugMode) {
        print('URL Gambar Profil: $profileImageUrl');
      }
    } else {
      if (kDebugMode) {
        print('Gagal memuat data pengguna');
      }
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });

      const apiUrl = 'http://10.0.2.2:8000/api/update-profile-image';
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
      request.fields['user_id'] = widget.userId.toString();

      // Tambahkan penanganan jika tidak ada gambar yang dipilih
      if (_image != null) {
        request.files.add(
            await http.MultipartFile.fromPath('profile_image', _image!.path));
      } else {
        if (kDebugMode) {
          print('Tidak ada gambar yang dipilih');
        }
        return;
      }

      var response = await request.send();

      if (response.statusCode == 200) {
        // ignore: unused_local_variable
        String responseBody = await response.stream.bytesToString();
        if (kDebugMode) {
          print('Foto profil berhasil diperbarui');
        }
      } else {
        if (kDebugMode) {
          print('Gagal memperbarui foto profil: ${response.reasonPhrase}');
        }
      }
    } else {
      if (kDebugMode) {
        print('Pemilihan foto dibatalkan');
      }
    }
  }

  @override
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
                  Positioned(
                    // Memindahkan tombol "Ganti Foto Profil" di bawah gambar profil
                    top: 230,
                    left: 165,
                    child: ElevatedButton(
                      onPressed: _pickImage,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets
                            .zero, // Menghapus padding di dalam tombol
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize
                            .min, // Menyusun widget ke dalam baris secara minimum
                        children: [
                          Icon(Icons
                              .camera_alt), // Menggunakan ikon kamera untuk mengganti foto profil
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Metode untuk membangun widget background image
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
                      color: const Color.fromRGBO(123, 120, 170, 1).withOpacity(
                          1.0), // Opacity value can be adjusted (0.0 to 1.0)
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
                      color: const Color.fromRGBO(123, 120, 170, 1).withOpacity(
                          1.0), // Opacity value can be adjusted (0.0 to 1.0)
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
                      color: const Color.fromRGBO(123, 120, 170, 1).withOpacity(
                          1.0), // Opacity value can be adjusted (0.0 to 1.0)
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
      child: _image != null
          ? CircleAvatar(
              radius: 100,
              backgroundImage: FileImage(_image!),
            )
          : profileImageUrl != null
              ? CircleAvatar(
                  radius: 100,
                  backgroundImage: NetworkImage(
                      '$profileImageUrl'), // Gunakan profileImageUrl di sini
                )
              : Image.asset(
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
          PopupMenuButton(
            offset: const Offset(0, 50), // Geser popup ke bawah sejauh 50 pixel
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0), // Mengatur melengkung
            ),
            itemBuilder: (BuildContext context) => <PopupMenuEntry>[
              const PopupMenuItem(
                value: 'logout',
                child: Text(
                  'Logout',
                  style: TextStyle(
                    fontFamily: 'Poppins-Regular',
                    color: Color.fromRGBO(
                        25, 23, 61, 1), // Ganti warna teks jika perlu
                    fontSize: 16, // Ganti ukuran teks jika perlu
                  ),
                ),
              ),
            ],
            onSelected: (value) {
              if (value == 'logout') {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: const Color.fromRGBO(
                          255, 255, 255, 1), // Atur warna latar belakang
                      title: const Text(
                        "Logout",
                        style: TextStyle(
                          color: Color.fromRGBO(
                              25, 23, 61, 1), // Atur warna teks judul
                          fontFamily: 'Poppins', // Atur jenis font teks judul
                        ),
                      ),
                      content: const Text(
                        "Are you sure want to logout?",
                        style: TextStyle(
                          color: Color.fromARGB(
                              255, 72, 71, 75), // Atur warna teks konten
                          fontFamily:
                              'Poppins-Regular', // Atur jenis font teks konten
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: const Text(
                            "Yes",
                            style: TextStyle(
                              color: Color.fromARGB(255, 72, 71,
                                  75), // Atur warna teks tombol "Yes"
                              fontFamily:
                                  'Poppins-Regular', // Atur jenis font teks tombol "Yes"
                            ),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, '/');
                          },
                        ),
                        TextButton(
                          child: const Text(
                            "Cancel",
                            style: TextStyle(
                              color: Color.fromARGB(255, 72, 71,
                                  75), // Atur warna teks tombol "Cancel"
                              fontFamily:
                                  'Poppins-Regular', // Atur jenis font teks tombol "Cancel"
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              }
            },

            color: const Color.fromRGBO(
                123, 120, 170, 1), // Set warna latar belakang
            iconSize: 16, // Set ukuran ikon popup
          ),
        ],
      ),
    );
  }
}
