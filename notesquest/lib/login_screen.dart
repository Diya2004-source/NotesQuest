import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'admin/admin_dashboard.dart';
import 'payment_screen.dart';
import 'registration_screen.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController =
      TextEditingController();

  final TextEditingController passwordController =
      TextEditingController();

  bool isPasswordVisible = false;
  bool isLoading = false;

  // ================= INPUT STYLE =================
  InputDecoration inputStyle(
    String label,
    IconData icon,
  ) {
    return InputDecoration(
      labelText: label,

      prefixIcon: Icon(
        icon,
        color: Colors.white70,
      ),

      filled: true,
      fillColor: Colors.white10,

      labelStyle: const TextStyle(
        color: Colors.white70,
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: Colors.white.withOpacity(0.2),
        ),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: Colors.blue,
          width: 2,
        ),
      ),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
      ),
    );
  }

  // ================= SAVE USER DATA =================
  Future<void> saveUserData(User user) async {
    final userRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid);

    final doc = await userRef.get();

    // CREATE USER DOC IF NOT EXISTS
    if (!doc.exists) {
      await userRef.set({
        "name": user.displayName ?? "",
        "email": user.email ?? "",
        "role": "user",
        "isPremium": false,
        "paymentStatus": "unpaid",
        "createdAt": FieldValue.serverTimestamp(),
      });
    }
  }

  // ================= CHECK ROLE & REDIRECT =================
  Future<void> checkRoleAndNavigate(User user) async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    final data = doc.data() as Map<String, dynamic>;

    final role =
        data['role']?.toString().toLowerCase() ??
            "user";

    if (!mounted) return;

    if (role == "admin") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              const AdminDashboard(),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              const PaymentPage(),
        ),
      );
    }
  }

  // ================= EMAIL PASSWORD LOGIN =================
  Future<void> loginUser() async {
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();

    setState(() => isLoading = true);

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance
              .signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      await saveUserData(userCredential.user!);

      if (!mounted) return;

      setState(() => isLoading = false);

      await checkRoleAndNavigate(
        userCredential.user!,
      );
    }

    on FirebaseAuthException catch (e) {
      if (!mounted) return;

      setState(() => isLoading = false);

      String message = "Login failed";

      switch (e.code) {
        case 'invalid-email':
          message = "Invalid email format";
          break;

        case 'user-not-found':
          message = "No user found";
          break;

        case 'wrong-password':
          message = "Wrong password";
          break;

        case 'invalid-credential':
          message =
              "Incorrect email or password";
          break;

        case 'network-request-failed':
          message = "No internet connection";
          break;

        default:
          message = e.message ?? "Login failed";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(message),
        ),
      );
    }

    catch (e) {
      if (!mounted) return;

      setState(() => isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            "Something went wrong: $e",
          ),
        ),
      );
    }
  }

  // ================= GOOGLE LOGIN =================
  Future<void> signInWithGoogle() async {
    try {
      setState(() => isLoading = true);

      // SIGN OUT PREVIOUS ACCOUNT
      await GoogleSignIn().signOut();

      final GoogleSignInAccount? googleUser =
          await GoogleSignIn().signIn();

      if (googleUser == null) {
        setState(() => isLoading = false);
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential =
          GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await FirebaseAuth.instance
              .signInWithCredential(credential);

      await saveUserData(userCredential.user!);

      if (!mounted) return;

      setState(() => isLoading = false);

      await checkRoleAndNavigate(
        userCredential.user!,
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      setState(() => isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            e.message ?? "Google Sign-In Failed",
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() => isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            "Google Sign-In Failed: $e",
          ),
        ),
      );
    }
  }

  // ================= FORGOT PASSWORD =================
  Future<void> forgotPassword() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Enter email first",
          ),
        ),
      );
      return;
    }

    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(
        email: email,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            "Password reset link sent!",
          ),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            e.message ??
                "Error sending reset email",
          ),
        ),
      );
    }
  }

  // ================= DISPOSE =================
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),

      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),

            child: Form(
              key: _formKey,

              child: Column(
                children: [

                  // ================= LOGO =================
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius:
                          BorderRadius.circular(24),
                    ),

                    child: Image.asset(
                      "assets/Logo.png",
                      height: 110,
                    ),
                  ),

                  const SizedBox(height: 25),

                  // ================= TITLE =================
                  const Text(
                    "Welcome Back",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    "Login to continue your journey",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(height: 35),

                  // ================= EMAIL =================
                  TextFormField(
                    controller: emailController,

                    style: const TextStyle(
                      color: Colors.white,
                    ),

                    decoration: inputStyle(
                      "Email",
                      Icons.email_outlined,
                    ),

                    validator: (value) {
                      if (value == null ||
                          value.isEmpty) {
                        return "Enter email";
                      }

                      if (!value.contains("@")) {
                        return "Enter valid email";
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 18),

                  // ================= PASSWORD =================
                  TextFormField(
                    controller: passwordController,

                    obscureText: !isPasswordVisible,

                    style: const TextStyle(
                      color: Colors.white,
                    ),

                    decoration: inputStyle(
                      "Password",
                      Icons.lock_outline,
                    ).copyWith(
                      suffixIcon: IconButton(
                        icon: Icon(
                          isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.white70,
                        ),
                        onPressed: () {
                          setState(() {
                            isPasswordVisible =
                                !isPasswordVisible;
                          });
                        },
                      ),
                    ),

                    validator: (value) {
                      if (value == null ||
                          value.isEmpty) {
                        return "Enter password";
                      }

                      if (value.length < 6) {
                        return "Minimum 6 characters";
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 10),

                  // ================= FORGOT PASSWORD =================
                  Align(
                    alignment: Alignment.centerRight,

                    child: TextButton(
                      onPressed: forgotPassword,

                      child: const Text(
                        "Forgot Password?",
                        style: TextStyle(
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // ================= LOGIN BUTTON =================
                  SizedBox(
                    width: double.infinity,
                    height: 55,

                    child: ElevatedButton(
                      onPressed:
                          isLoading ? null : loginUser,

                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(0xFF2563EB),

                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(14),
                        ),
                      ),

                      child: isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text(
                              "Login",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // ================= GOOGLE BUTTON =================
                  SizedBox(
                    width: double.infinity,
                    height: 55,

                    child: OutlinedButton.icon(
                      onPressed:
                          isLoading
                              ? null
                              : signInWithGoogle,

                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color:
                              Colors.white.withOpacity(0.3),
                        ),

                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(14),
                        ),
                      ),

                      icon: const Icon(
                        Icons.g_mobiledata,
                        size: 32,
                        color: Colors.white,
                      ),

                      label: const Text(
                        "Sign in with Google",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  // ================= REGISTER =================
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center,

                    children: [

                      const Text(
                        "Don't have an account?",
                        style: TextStyle(
                          color: Colors.white70,
                        ),
                      ),

                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const registration(),
                            ),
                          );
                        },

                        child: const Text(
                          "Register",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight:
                                FontWeight.bold,
                          ),
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
    );
  }
}