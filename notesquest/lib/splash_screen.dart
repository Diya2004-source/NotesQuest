import 'package:flutter/material.dart';
import 'dart:async'; //for async operations like delay
import 'registration_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin { //imp for animation controller

  late AnimationController _controller; //this is for animation conroller which will control both fade and scale animation

  late Animation<double> _fadeAnimation; //created fade animation

  late Animation<double> _scaleAnimation; // control zoom in and out of logo

  @override
  void initState() {
    super.initState();

    // Animation Controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );

    // Fade Animation
    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 10,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );

    // Scale Animation
    _scaleAnimation = Tween<double>(
      begin: 0.2,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    _controller.forward();

    navigateHome();
  }

  Future<void> navigateHome() async {

    await Future.delayed(const Duration(seconds: 4));

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const registration(),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: const Color(0xFF0F172A),

      body: Container(
        width: double.infinity,

        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0F172A),
              Color(0xFF1E1B4B),
              Color(0xFF312E81),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        child: Center(
          child: FadeTransition(

            opacity: _fadeAnimation,

            child: ScaleTransition(

              scale: _scaleAnimation,

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  // LOGO CONTAINER
                  Container(
                    padding: const EdgeInsets.all(20),

                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF7C4DFF),
                          Color(0xFF38BDF8),
                        ],
                      ),

                      boxShadow: [
                        BoxShadow(
                          color: Colors.blueAccent.withOpacity(0.4),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ],
                    ),

                    child: Image.asset(
                      'assets/Logo.png',
                      height: 120,
                      width: 120,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // APP NAME
                  const Text(
                    "NotesQuest",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      fontFamily: 'NotoSans',
                    ),
                  ),

                  const SizedBox(height: 10),

                  // TAGLINE
                  const Text(
                    "AI Powered Learning",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      letterSpacing: 1,
                    ),
                  ),

                  const SizedBox(height: 50),

                  // LOADING INDICATOR
                  const CircularProgressIndicator(
                    color: Color(0xFF38BDF8),
                    strokeWidth: 3,
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