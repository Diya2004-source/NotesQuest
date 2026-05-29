import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_screen.dart';

class registration extends StatefulWidget {
  const registration({super.key});

  @override
  State<registration> createState() => _registrationState();
}

class _registrationState extends State<registration> {
  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  // CONTROLLERS
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final phoneController = TextEditingController();
  final cityController = TextEditingController();
  final courseController = TextEditingController();
  final semesterController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    phoneController.dispose();
    cityController.dispose();
    courseController.dispose();
    semesterController.dispose();
    super.dispose();
  }

  // ================= INPUT STYLE =================
  InputDecoration inputStyle(
    String label,
    IconData icon,
  ) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.white70),
      filled: true,
      fillColor: Colors.white10,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      labelStyle: const TextStyle(
        color: Colors.white70,
      ),
    );
  }

  // ================= REGISTER USER =================
  Future<void> registerUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      // CREATE USER IN FIREBASE AUTH
      UserCredential userCredential =
          await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // GET USER UID
      String uid = userCredential.user!.uid;

      // SAVE USER DATA IN FIRESTORE
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .set({
        "name": nameController.text.trim(),
        "email": emailController.text.trim(),
        "phone": phoneController.text.trim(),
        "city": cityController.text.trim(),
        "course": courseController.text.trim(),
        "semester": semesterController.text.trim(),

        // DEFAULT VALUES
        "role": "user",
        "isPremium": false,
        "paymentStatus": "unpaid",

        "createdAt": FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      setState(() => isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Registration Successful"),
          backgroundColor: Colors.green,
        ),
      );

      // REDIRECT TO LOGIN
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const login(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      setState(() => isLoading = false);

      String message = "";

      switch (e.code) {
        case 'email-already-in-use':
          message = "Email already exists";
          break;

        case 'weak-password':
          message = "Password is too weak";
          break;

        case 'invalid-email':
          message = "Invalid email";
          break;

        default:
          message = e.message ?? "Registration failed";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() => isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),

            child: Form(
              key: _formKey,

              child: Column(
                children: [

                  const SizedBox(height: 10),

                  const Text(
                    "Create Account",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Image.asset(
                    'assets/Logo.png',
                    height: 120,
                  ),

                  const SizedBox(height: 25),

                  // NAME
                  TextFormField(
                    controller: nameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: inputStyle(
                      "Full Name",
                      Icons.person,
                    ),
                    validator: (value) =>
                        value!.isEmpty
                            ? "Enter your name"
                            : null,
                  ),

                  const SizedBox(height: 15),

                  // EMAIL
                  TextFormField(
                    controller: emailController,
                    style: const TextStyle(color: Colors.white),
                    decoration: inputStyle(
                      "Email",
                      Icons.email,
                    ),
                    validator: (value) =>
                        value!.contains("@")
                            ? null
                            : "Enter valid email",
                  ),

                  const SizedBox(height: 15),

                  // PASSWORD
                  TextFormField(
                    controller: passwordController,
                    obscureText: !isPasswordVisible,
                    style: const TextStyle(color: Colors.white),

                    decoration: inputStyle(
                      "Password",
                      Icons.lock,
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

                    validator: (value) =>
                        value!.length < 6
                            ? "Minimum 6 characters"
                            : null,
                  ),

                  const SizedBox(height: 15),

                  // CONFIRM PASSWORD
                  TextFormField(
                    controller: confirmPasswordController,
                    obscureText:
                        !isConfirmPasswordVisible,
                    style: const TextStyle(color: Colors.white),

                    decoration: inputStyle(
                      "Confirm Password",
                      Icons.lock_outline,
                    ).copyWith(
                      suffixIcon: IconButton(
                        icon: Icon(
                          isConfirmPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.white70,
                        ),
                        onPressed: () {
                          setState(() {
                            isConfirmPasswordVisible =
                                !isConfirmPasswordVisible;
                          });
                        },
                      ),
                    ),

                    validator: (value) {
                      if (value !=
                          passwordController.text) {
                        return "Passwords do not match";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 15),

                  // PHONE
                  TextFormField(
                    controller: phoneController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white),
                    decoration: inputStyle(
                      "Phone Number",
                      Icons.phone,
                    ),
                    validator: (value) =>
                        value!.length != 10
                            ? "Enter valid phone number"
                            : null,
                  ),

                  const SizedBox(height: 15),

                  // CITY
                  TextFormField(
                    controller: cityController,
                    style: const TextStyle(color: Colors.white),
                    decoration: inputStyle(
                      "City",
                      Icons.location_city,
                    ),
                    validator: (value) =>
                        value!.isEmpty
                            ? "Enter city"
                            : null,
                  ),

                  const SizedBox(height: 15),

                  // COURSE
                  TextFormField(
                    controller: courseController,
                    style: const TextStyle(color: Colors.white),
                    decoration: inputStyle(
                      "Course",
                      Icons.school,
                    ),
                    validator: (value) =>
                        value!.isEmpty
                            ? "Enter course"
                            : null,
                  ),

                  const SizedBox(height: 15),

                  // SEMESTER
                  TextFormField(
                    controller: semesterController,
                    style: const TextStyle(color: Colors.white),
                    decoration: inputStyle(
                      "Semester",
                      Icons.menu_book,
                    ),
                    validator: (value) =>
                        value!.isEmpty
                            ? "Enter semester"
                            : null,
                  ),

                  const SizedBox(height: 25),

                  // REGISTER BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 50,

                    child: ElevatedButton(
                      onPressed:
                          isLoading ? null : registerUser,

                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(12),
                        ),
                      ),

                      child: isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text(
                              "Register",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // LOGIN
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const login(),
                        ),
                      );
                    },
                    child: const Text(
                      "Already have an account? Login",
                      style: TextStyle(
                        color: Colors.white70,
                      ),
                    ),
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
