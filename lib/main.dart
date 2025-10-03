import 'package:flutter/material.dart';

// Screens
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/purposeselectionscreen.dart'; // ✅ add purpose selection
//import 'screens/packing_items_screen.dart'; // ✅ add packing items
//import 'screens/home_screen.dart'; // ✅ add home screen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ReadySetGO',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),

      // ✅ Start with SplashScreen
      initialRoute: '/',

      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/purposeSelection': (context) => const PurposeSelectionScreen(),
        //'/packingItems': (context) => PackingItemsScreen(),
        //'/home': (context) => const HomeScreen(),
      },
    );
  }
}
