import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'profile.dart';
import 'budget.dart';
import 'register.dart';
import 'dashboard.dart';
import 'login.dart';
import 'user_data.dart';

class MoneyFestApp extends StatelessWidget {
  const MoneyFestApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserData(), // Create an instance of UserData
      child: MaterialApp(
        title: 'MoneyFest',
        initialRoute: '/',
        routes: {
          '/': (BuildContext context) => Login(),
          '/dashboard': (BuildContext context) {
            final userId = Provider.of<UserData>(context).userId;
            return Dashboard(userId: userId);
          },
          '/register': (BuildContext context) => Register(),
          '/budget': (BuildContext context) {
            final userId = Provider.of<UserData>(context).userId;
            return Budget(userId: userId);
          },
          '/profile': (BuildContext context) {
            // Access userId from the UserData instance
            final userId = Provider.of<UserData>(context).userId;
            // Periksa jika userId tidak null sebelum menggunakan nilainya
            if (userId != null) {
              return Profile(userId: userId);
            } else {
              // Jika userId null, lakukan sesuatu, misalnya kembali ke halaman login
              return Login();
            }
          }
        },
      ),
    );
  }
}
