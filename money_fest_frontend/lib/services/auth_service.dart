// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:money_fest_frontend/user_data.dart'; // Import the UserData class
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  Future<void> loginUser(
      BuildContext context, String username, String password) async {
    final Url = Uri.parse('$baseUrl/login');
    final response = await http.post(
      Url,
      body: {
        'username': username,
        'password': password,
      },
    );

    final responseData = json.decode(response.body);
    if (response.statusCode == 200) {
      final userId = responseData['dataUser']['id'];
      Provider.of<UserData>(context, listen: false)
          .setUserId(userId); // Set userId using Provider
      Navigator.pushReplacementNamed(context, '/profile', arguments: userId);
      if (kDebugMode) {
        print(responseData['message']);
      }
    } else {
      if (kDebugMode) {
        print(responseData['message']);
      }

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Error"),
            content: Text(responseData['message']),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> register(String email, String username, String nickName,
      String password, BuildContext context) async {
    final Url = Uri.parse('$baseUrl/register');
    final response = await http.post(
      Url,
      body: {
        'email': email,
        'username': username,
        'NickName': nickName,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final userId = responseData['data']
          ['id']; // Ubah sesuai dengan struktur respons dari backend Anda
      Provider.of<UserData>(context, listen: false).setUserId(userId);
      Navigator.pushReplacementNamed(context, '/profile', arguments: userId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.white,
              ),
              SizedBox(width: 10),
              Expanded(child: Text('Register Succesful')),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          margin: EdgeInsets.all(10),
          duration: Duration(seconds: 3),
        ),
      );
    } else {
      // Registrasi gagal, tampilkan pesan kesalahan
      if (kDebugMode) {
        print('Registrasi gagal: ${response.body}');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                Icons.error,
                color: Colors.white,
              ),
              SizedBox(width: 10),
              Expanded(child: Text('Failed to register')),
            ],
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          margin: EdgeInsets.all(10),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  //Profile
  // Metode untuk mengambil data pengguna
  Future<void> fetchUserData(int userId,
      {required Function(dynamic) onSuccess,
      required Function(dynamic) onError}) async {
    final apiUrl = '$baseUrl/user/$userId'; // Menggunakan baseUrl di sini
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final userData = json.decode(response.body);
      onSuccess(userData); // Panggil onSuccess callback dengan data pengguna
    } else {
      onError(
          'Failed to load user data'); // Panggil onError callback dengan pesan kesalahan
    }
  }

  Future<void> addCategory(String categoryName) async {
    // Endpoint backend untuk menambahkan kategori
    const url = '$baseUrl/kategori';
    final response = await http.post(
      Uri.parse(url),
      body: json.encode({'NamaKategori': categoryName}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      if (kDebugMode) {
        print('Kategori berhasil ditambahkan');
      }
    } else {
      if (kDebugMode) {
        print('Gagal menambahkan kategori');
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    }
  }
}
