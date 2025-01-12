import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:todolist/presentation/authentication/login_page.dart';
import 'package:todolist/widget/custom_button.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeInAnimation;
  late Animation<Offset> _slideInAnimation;

  bool _isLoading = false;
  String? _errorMessage;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );

    _slideInAnimation =
        Tween<Offset>(begin: Offset(0, 1), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _signUp() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      setState(() {
        _errorMessage = "All fields are required.";
      });
      return;
    }

    if (password != confirmPassword) {
      setState(() {
        _errorMessage = "Passwords do not match.";
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'email': email,
        'createdAt': DateTime.now(),
      });

      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message;
      });
    } catch (e) {
      setState(() {
        _errorMessage = "An unexpected error occurred. Please try again.";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: _isLoading
          ? Center(
              child: SpinKitCubeGrid(
                color: Color(0xffFF0000),
                size: 50.0,
              ),
            )
          : SingleChildScrollView(
              child: Center(
                child: FadeTransition(
                  opacity: _fadeInAnimation,
                  child: SlideTransition(
                    position: _slideInAnimation,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Logo and Title
                          SizedBox(
                            height: 120,
                          ),
                          Container(
                            width: screenWidth * 0.5,
                            height: screenHeight * 0.3,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: AssetImage(
                                        "assets/logo/todolist.png"))),
                          ),

                          if (_errorMessage != null) ...[
                            SizedBox(height: 10),
                            Text(
                              _errorMessage!,
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],

                          SizedBox(height: 20),

                          // Email Field
                          TextField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              prefixIcon:
                                  Icon(Icons.email, color: Color(0xFF00008B)),
                              labelText: 'Enter your Email',
                              labelStyle: TextStyle(
                                color: Color(0xFF00008B),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ).animate().fade(
                              duration: const Duration(milliseconds: 1000),
                              curve: Curves.easeInOut),

                          SizedBox(height: 20),

                          // Password Field
                          TextField(
                            controller: _passwordController,
                            decoration: InputDecoration(
                              prefixIcon:
                                  Icon(Icons.lock, color: Color(0xFF00008B)),
                              labelText: 'Password',
                              labelStyle: TextStyle(
                                color: Color(0xFF00008B),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            obscureText: true,
                          ).animate().fade(
                              delay: const Duration(milliseconds: 200),
                              duration: const Duration(milliseconds: 1000),
                              curve: Curves.easeInOut),

                          SizedBox(height: 20),

                          // Confirm Password Field
                          TextField(
                            controller: _confirmPasswordController,
                            decoration: InputDecoration(
                              prefixIcon:
                                  Icon(Icons.lock, color: Color(0xFF00008B)),
                              labelText: 'Confirm Password',
                              labelStyle: TextStyle(
                                color: Color(0xFF00008B),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            obscureText: true,
                          ).animate().fade(
                              delay: const Duration(milliseconds: 400),
                              duration: const Duration(milliseconds: 1000),
                              curve: Curves.easeInOut),

                          SizedBox(height: 30),

                          // Sign Up Button
                          CustomButton(
                                  text: "Sign Up",
                                  onPressed: () {
                                    _signUp();
                                  })
                              .animate()
                              .move(
                                  delay: const Duration(milliseconds: 600),
                                  duration: const Duration(milliseconds: 1000),
                                  curve: Curves.easeInOut),

                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginScreen()),
                                    );
                                  },
                                  child: Text('Already Have An Account ? '))
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
