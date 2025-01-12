import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist/presentation/authentication/signup_page.dart';
import 'package:todolist/providers/login_provider.dart';
import 'package:todolist/widget/bottom_nav_bar.dart';
import 'package:todolist/widget/custom_button.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeInAnimation;
  late Animation<Offset> _slideInAnimation;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context);

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: loginProvider.isLoading
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
                      padding: EdgeInsets.all(screenWidth * 0.04),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: screenHeight * 0.13),
                          Container(
                            width: screenWidth * 0.5,
                            height: screenHeight * 0.3,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                image: AssetImage("assets/logo/todolist.png"),
                              ),
                            ),
                          ),
                          if (loginProvider.errorMessage != null) ...[
                            SizedBox(height: screenHeight * 0.003),
                            Text(
                              loginProvider.errorMessage!,
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                          SizedBox(height: screenHeight * 0.01),
                          TextField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              prefixIcon:
                                  Icon(Icons.person, color: Color(0xFF00008B)),
                              labelText: 'Enter you Email',
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
                          ),
                          SizedBox(height: screenHeight * 0.01),
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
                          ),
                          SizedBox(height: screenHeight * 0.015),
                          CustomButton(
                            text: "Login",
                            onPressed: () {
                              loginProvider.login(
                                _emailController.text.trim(),
                                _passwordController.text.trim(),
                                context,
                              );
                            },
                          ),
                          SizedBox(height: screenHeight * 0.015),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SignUpPage(),
                                    ),
                                  );
                                },
                                child: Text(' New User ? '),
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
