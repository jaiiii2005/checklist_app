import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId:
    '304142693385-25eavf7g04flc2cr6uhfguik9kn1r05p.apps.googleusercontent.com', // 👈 your web client ID
    scopes: ['email', 'profile'],
  );


  /// ---------------- EMAIL SIGNUP ----------------
  Future<User?> signUpWithEmail(String email, String password) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? "Signup failed");
    }
  }

  /// ---------------- EMAIL LOGIN ----------------
  Future<User?> loginWithEmail(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? "Login failed");
    }
  }

  /// ---------------- GOOGLE SIGN-IN ----------------
  Future<User?> signInWithGoogle() async {
    try {
      // Trigger the Google authentication flow
      final GoogleSignInAccount?
      googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // User canceled the login
        return null;
      }

      // Obtain auth details
      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      // Get credentials
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      // Sign in to Firebase
      final userCredential = await _auth.signInWithCredential(credential);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? "Google Sign-In failed");
    } catch (e) {
      throw Exception("Google Sign-In error: $e");
    }
  }

  /// ---------------- SIGN OUT ----------------
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.signOut();
      }
    } catch (e) {
      throw Exception("Sign out failed: $e");
    }
  }

  /// ---------------- CURRENT USER ----------------
  User? get currentUser => _auth.currentUser;
}
