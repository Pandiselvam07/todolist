import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist/providers/signup_provider.dart';
import 'package:todolist/widget/custom_button.dart';
import 'login_page.dart';

class SignUpPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    final signupProvider = Provider.of<SignupProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: signupProvider.isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(screenWidth * 0.04),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Logo
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
                      if (signupProvider.errorMessage != null) ...[
                        SizedBox(height: screenHeight * 0.004),
                        Text(
                          signupProvider.errorMessage!,
                          style: TextStyle(color: Colors.red, fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ],
                      SizedBox(height: screenHeight * 0.03),
                      // Email Field
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          prefixIcon:
                              Icon(Icons.email, color: Color(0xFF00008B)),
                          labelText: 'Enter your Email',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.004),
                      // Password Field
                      TextField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          prefixIcon:
                              Icon(Icons.lock, color: Color(0xFF00008B)),
                          labelText: 'Password',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        obscureText: true,
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      // Confirm Password Field
                      TextField(
                        controller: _confirmPasswordController,
                        decoration: InputDecoration(
                          prefixIcon:
                              Icon(Icons.lock, color: Color(0xFF00008B)),
                          labelText: 'Confirm Password',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        obscureText: true,
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      CustomButton(
                        text: "Sign Up",
                        onPressed: () {
                          signupProvider.signUp(
                            _emailController.text.trim(),
                            _passwordController.text.trim(),
                            _confirmPasswordController.text.trim(),
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()),
                          );
                        },
                      ),
                      SizedBox(height: screenHeight * 0.025),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()),
                          );
                        },
                        child: Text('Already Have An Account?'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
