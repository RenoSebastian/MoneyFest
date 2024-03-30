import 'package:flutter/material.dart';
import 'profile.dart';
import 'budget.dart';
import 'register.dart';
import 'dashboard.dart';
import 'login.dart';

class MoneyFestApp extends StatelessWidget {
  const MoneyFestApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MoneyFest',
      initialRoute: '/',
      routes: {
        '/': (BuildContext context) => const Login(),
        '/dashboard': (BuildContext context) => const Dashboard(),
        '/register': (BuildContext context) => const Register(),
        '/budget': (BuildContext context) => const Budget(),
        '/profile': (BuildContext context) => const Profile(),
      },
    );
  }
}
