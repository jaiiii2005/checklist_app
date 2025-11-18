import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  bool _isLoading = false;

  /// ✅ Handle email/password login
  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      User? user = await _authService.loginWithEmail(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text("Login successful! 🎉"),
          ),
        );
        Navigator.pushReplacementNamed(context, '/purposeSelection');
      }
    } on FirebaseAuthException catch (e) {
      String errorMsg = _handleFirebaseError(e.code);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text("⚠ $errorMsg"),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("⚠ Unexpected error: ${e.toString()}"),
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// ✅ Friendly Firebase error messages
  String _handleFirebaseError(String code) {
    switch (code) {
      case 'user-not-found':
        return "No user found for that email.";
      case 'wrong-password':
        return "Incorrect password. Try again.";
      case 'invalid-email':
        return "The email address is badly formatted.";
      case 'user-disabled':
        return "This account has been disabled.";
      default:
        return "Login failed. Please try again.";
    }
  }

  /// ✅ UI Layout
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4A00E0), Color(0xFF8E2DE2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ✅ Logo
                    Image.asset(
                      "lib/assets/logo.png",
                      width: 80,
                      height: 80,
                    ),
                    const SizedBox(height: 16),

                    const Text(
                      "Welcome Back!",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ✅ Email Field
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: "Email",
                        prefixIcon: const Icon(Icons.email),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your email";
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return "Enter a valid email";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // ✅ Password Field
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Password",
                        prefixIcon: const Icon(Icons.lock),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? "Enter your password"
                          : null,
                    ),
                    const SizedBox(height: 24),

                    // ✅ Login Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4A00E0),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: _isLoading ? null : _handleLogin,
                        child: _isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ✅ OR Divider
                    const Row(
                      children: [
                        Expanded(child: Divider()),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Text("OR"),
                        ),
                        Expanded(child: Divider()),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // ✅ Google Sign-In (Future Integration)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: Image.asset(
                          "lib/assets/google_logo.png",
                          height: 24,
                        ),
                        label: const Text(
                          "Continue with Google",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          elevation: 2,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: const BorderSide(color: Colors.grey),
                          ),
                        ),
                        onPressed: () async {
                          try {
                            await _authService.signInWithGoogle();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Logged in with Google ✅"),
                              ),
                            );
                            Navigator.pushReplacementNamed(
                                context, '/purposeSelection');
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                Text("Google Sign-In failed: $e"),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ✅ Signup Redirect
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don’t have an account?"),
                        TextButton(
                          onPressed: () =>
                              Navigator.pushNamed(context, '/signup'),
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(color: Color(0xFF4A00E0)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}