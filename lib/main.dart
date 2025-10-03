import 'package:flutter/material.dart';
import 'package:tirtha_suraksha/screens/login_screen.dart'; // Import the new login screen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tirtha Suraksha',
      debugShowCheckedModeBanner: false,

      // Light Mode Theme
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        tabBarTheme: const TabBarThemeData(
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.black,
        ),
         bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: Colors.deepPurple,
          unselectedItemColor: Colors.grey,
        ),
      ),

      // Dark Mode Theme
      darkTheme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        tabBarTheme: const TabBarThemeData(
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.white,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
        ),
      ),

      themeMode: ThemeMode.system, 
      
      // The app now starts with the LoginScreen
      home: const LoginScreen(),
    );
  }
}