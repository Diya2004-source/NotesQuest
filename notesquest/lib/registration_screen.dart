import 'package:flutter/material.dart';
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

  // Controllers
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

  InputDecoration inputStyle(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    );
  }

  void registerUser() async {
    if (_formKey.currentState!.validate()) {
      // We can implement the API call to register the user

      setState(() => isLoading = true);

      try {
        await FirebaseFirestore.instance.collection('users').add({
          "name": nameController.text.trim(),
          "email": emailController.text.trim(),
          "password": passwordController.text.trim(),
          "phone": phoneController.text.trim(),
          "city": cityController.text.trim(),
          "course": courseController.text.trim(),
          "semester": semesterController.text.trim(),

          //not ask from user
          "role": "User",
          "createdAt": FieldValue.serverTimestamp(),
          "isPremium": false,
          "paymentStatus": "unpaid",
        });
        setState(() => isLoading = false);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Registration Successful")),
        );

        //Redirect to login page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const login()),
        );
      } catch (e) {
        print("Error: $e");
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Registration Successful")));

      print("Name: ${nameController.text}");
      print("Email: ${emailController.text}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),

                  const Text(
                    "Create Account",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Poppins",
                    ),
                  ),

                  const SizedBox(height: 10),

                  Image.asset('assets/Logo.png', height: 120),

                  const SizedBox(height: 20),

                  TextFormField(
                    controller: nameController,
                    decoration: inputStyle("Full Name"),
                    validator: (value) =>
                        value!.isEmpty ? "Enter your name" : null,
                  ),

                  const SizedBox(height: 12),

                  TextFormField(
                    controller: emailController,
                    decoration: inputStyle("Email"),
                    validator: (value) =>
                        value!.contains("@") ? null : "Enter valid email",
                  ),

                  const SizedBox(height: 12),

                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: inputStyle("Password"),
                    validator: (value) =>
                        value!.length < 6 ? "Min 6 characters required" : null,
                  ),

                  const SizedBox(height: 12),

                  TextFormField(
                    controller: confirmPasswordController,
                    obscureText: true,
                    decoration: inputStyle("Confirm Password"),
                    validator: (value) {
                      if (value != passwordController.text) {
                        return "Passwords do not match";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 12),

                  TextFormField(
                    controller: phoneController,
                    keyboardType: TextInputType.number,
                    decoration: inputStyle("Phone Number"),
                    validator: (value) =>
                        value!.length != 10 ? "Enter valid phone number" : null,
                  ),

                  const SizedBox(height: 12),

                  TextFormField(
                    controller: cityController,
                    decoration: inputStyle("City"),
                    validator: (value) => value!.isEmpty ? "Enter city" : null,
                  ),

                  const SizedBox(height: 12),

                  TextFormField(
                    controller: courseController,
                    decoration: inputStyle("Course"),
                    validator: (value) =>
                        value!.isEmpty ? "Enter course" : null,
                  ),

                  const SizedBox(height: 12),

                  TextFormField(
                    controller: semesterController,
                    decoration: inputStyle("Semester"),
                    validator: (value) =>
                        value!.isEmpty ? "Enter semester" : null,
                  ),

                  const SizedBox(height: 25),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: Colors.blue,
                      ),
                      onPressed: registerUser,
                      child: const Text(
                        "Register",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontFamily: "Roboto",
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => login()),
                      );
                    },
                    child: const Text(
                      'If you have an account? login here',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        decoration: TextDecoration
                            .underline, // optional (looks clickable)
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
