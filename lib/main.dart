import 'package:expense_app/screens/dashboard.screen.dart';
import 'package:expense_app/screens/login.screen.dart';
import 'package:expense_app/services/database/app_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppDatabase.initDatabase();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool? _isValidUser;

  @override
  void initState() {
    super.initState();

    _checkForValidSession();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: _isValidUser == null ? Container() : (_isValidUser! ? const DashboardScreen() : LoginScreen()),
    );
  }

  void _checkForValidSession() async {
    var preference = await SharedPreferences.getInstance();
    _isValidUser = false;
    if (preference.getBool('isLogin') ?? false) {
      _isValidUser = true;
    }

    setState(() {});
  }
}
