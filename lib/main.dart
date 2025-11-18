import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

// ✅ Screens
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/purposeselectionscreen.dart';
import 'screens/smart_checklist_screen.dart';
import 'screens/home_screen.dart';
import 'screens/category_item_screen.dart';
import 'screens/settings_screen.dart';

// ✅ Initialize Firebase
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // if (kIsWeb) {
  //   await Firebase.initializeApp(
  //     options: const FirebaseOptions(
  //         apiKey: "AIzaSyCAXjpB3nHBJyPXL0POsps7nynxurfwfew",
  //         authDomain: "fire-stepup-75576.firebaseapp.com",
  //         projectId: "fire-stepup-75576",
  //         storageBucket: "fire-stepup-75576.firebasestorage.app",
  //         messagingSenderId: "304142693385",
  //         appId: "1:304142693385:web:8bd595aa9df98f8161b4d8"
  //     ),
  //   );
  // } else {
  //   await Firebase.initializeApp();
  // }

  if(kIsWeb)
    {
      await Firebase.initializeApp(options: const FirebaseOptions(apiKey: "AIzaSyCAXjpB3nHBJyPXL0POsps7nynxurfwfew",
          authDomain: "fire-stepup-75576.firebaseapp.com",
          projectId: "fire-stepup-75576",
          storageBucket: "fire-stepup-75576.firebasestorage.app",
          messagingSenderId: "304142693385",
          appId: "1:304142693385:web:8bd595aa9df98f8161b4d8"));
    }
  else {
     await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;

  void _toggleTheme(bool isDark) {
    setState(() => _isDarkMode = isDark);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ReadySetGO',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFF6F7FB),
      ),
      darkTheme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F1115),
      ),
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      initialRoute: '/',

      // 🔹 Static Routes
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/purposeSelection': (context) => const PurposeSelectionScreen(),
        '/settings': (context) => SettingsScreen(
          onThemeChanged: _toggleTheme,
          isDarkMode: _isDarkMode,
        ),
      },

      // ⚡ Dynamic Routes for passing data
      onGenerateRoute: (settings) {
        final args = settings.arguments as Map<String, dynamic>? ?? {};

        switch (settings.name) {
        // Smart Checklist Screen
          case '/smartChecklist':
            return MaterialPageRoute(
              builder: (context) => SmartChecklistScreen(
                purpose: args['purpose'] ?? 'Custom Trip',
                items: (args['items'] ?? []).cast<String>(),
                initialItems: (args['initialItems'] ?? []).cast<String>(),
              ),
            );

        // Home Screen
          case '/home':
            return MaterialPageRoute(
              builder: (context) => HomeScreen(
                purpose: args['purpose'] ?? 'Trip',
                selectedItems: (args['selectedItems'] ?? []).cast<String>(),
                progress: args['progress'] ?? 0.0,
              ),
            );

        // Category Items Screen
          case '/categoryItems':
            return MaterialPageRoute(
              builder: (context) => CategoryItemScreen(
                purpose: args['purpose'] ?? 'Trip',
                initialSelectedItems: (args['initialSelectedItems'] ?? []).cast<String>(),
              ),
            );

          default:
            return null;
        }
      },
    );
  }
}
