import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';

// Screens
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/purposeselectionscreen.dart';
import 'screens/smart_checklist_screen.dart';
import 'screens/home_screen.dart';
import 'screens/category_item_screen.dart';
import 'screens/settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyCAXjpB3nHBJyPXL0POsps7nynxurfwfew",
        authDomain: "fire-stepup-75576.firebaseapp.com",
        projectId: "fire-stepup-75576",
        storageBucket: "fire-stepup-75576.firebasestorage.app",
        messagingSenderId: "304142693385",
        appId: "1:304142693385:web:8bd595aa9df98f8161b4d8",
      ),
    );
  } else {
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

  void _toggleTheme(bool value) {
    setState(() => _isDarkMode = value);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "ReadySetGO",
      debugShowCheckedModeBanner: false,
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,

      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF6F7FB),
        primarySwatch: Colors.blue,
      ),

      darkTheme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F1115),
      ),

      initialRoute: "/",

      // STATIC ROUTES
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/purposeSelection': (context) => const PurposeSelectionScreen(),

        // This static version will NOT be used during navigation with arguments
        '/settings': (context) => SettingsScreen(
          isDarkMode: _isDarkMode,
          onThemeChanged: _toggleTheme,
        ),
      },

      // DYNAMIC ROUTES (MAIN FIXED PART)
      onGenerateRoute: (settings) {
        final args = settings.arguments as Map<String, dynamic>? ?? {};

        switch (settings.name) {

        // SMART CHECKLIST
          case '/smartChecklist':
            final rawItems = args['items'] ?? [];

            final convertedItems = rawItems.map<Map<String, dynamic>>((it) {
              if (it is String) {
                return {"name": it, "category": "General", "checked": false};
              } else if (it is Map) {
                return {
                  "name": it["name"] ?? "",
                  "category": it["category"] ?? "General",
                  "checked": it["checked"] ?? false,
                };
              }
              return {"name": "", "category": "General", "checked": false};
            }).toList();

            return MaterialPageRoute(
              builder: (_) => SmartChecklistScreen(
                purpose: args['purpose'] ?? "Trip",
                items: convertedItems,
                tripId: args['tripId'],
              ),
            );

        // HOME SCREEN (main route to refresh item list & progress)
          case '/home':
            return MaterialPageRoute(
              builder: (_) => HomeScreen(
                purpose: args['purpose'] ?? 'Trip',
                tripId: args['tripId'],
              ),
            );

        // CATEGORY ITEM SCREEN
          case '/categoryItems':
            return MaterialPageRoute(
              builder: (_) => CategoryItemScreen(
                purpose: args['purpose'] ?? 'Trip',
                initialSelectedItems:
                (args['initialSelectedItems'] ?? []).cast<String>(),
              ),
            );
        }

        return null;
      },
    );
  }
}
