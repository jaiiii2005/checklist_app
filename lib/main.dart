import 'package:flutter/material.dart';

// Screens
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/purposeselectionscreen.dart';
import 'screens/smart_checklist_screen.dart'; // ✅ Added Smart Checklist

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
      },

      // ✅ Handle navigation that needs arguments
      onGenerateRoute: (settings) {
        if (settings.name == '/smartChecklist') {
          final args = settings.arguments as Map<String, dynamic>?;

          return MaterialPageRoute(
            builder: (context) => SmartChecklistScreen(
              purpose: args?['purpose'] ?? 'Custom Trip',
              items: args?['items'] ?? [],
            ),
          );
        }

        return null; // default
      },
    );
  }
}

