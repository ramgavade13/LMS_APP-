import 'package:flutter/material.dart';
import 'screens/signup_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const VITLibraryApp());
}

class VITLibraryApp extends StatelessWidget {
  const VITLibraryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'VIT Library',

      
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5F7FB),
        appBarTheme: const AppBarTheme(centerTitle: true),
      ),

      
      home: const SignupScreen(),

      
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen( role: 'role'),
      },
    );
  }
}