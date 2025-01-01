import 'package:flutter/material.dart';
import 'package:gehnamall/views/authentication/signup_screen.dart';
import 'package:get/get.dart';
import '../../constants/constants.dart';
import '../../main.dart';

import '../../services/auth_service.dart';
import 'otp_screen.dart'; 

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final phoneController = TextEditingController();
  bool isLoading = false;

  void handleLogin() async {
    if (phoneController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter phone number');
      return;
    }

    setState(() => isLoading = true);

    final result = await AuthService.login(phoneController.text);

    setState(() => isLoading = false);

    if (result['success']) {
      Get.to(() => OtpScreen(phoneNumber: phoneController.text));
    } else {
      if (result['data']['message'] == 'User not registered') {
        Get.snackbar(
          'Error',
          'User not registered. Please sign up first.',
        );
        Get.to(() => SignupScreen(
            phoneNumber: phoneController.text)); // Pass phone number to signup
      } else {
        Get.snackbar(
          'Error',
          result['data']['message'] ?? 'Login failed. Please try again.',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          ColorFiltered(
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.5), // Adjust opacity for darkness
              BlendMode.darken, // Blend mode to darken the image
            ),
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/loginbackground.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // Foreground Content
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  Image.asset(
                    'assets/images/applogo.png', // Replace with your logo path
                    height: 270,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Card(
                      color: kWhite,
                      elevation: 5,
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              'Log In',
                              style: TextStyle(
                                fontSize: 50,
                                color: kDark,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            'Shin Bright with exclusive Jewellers',
                            style: TextStyle(fontSize: 20, color: Colors.black),
                          ),
                          const SizedBox(height: 20),
                          // Phone Number Input
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: TextField(
                              controller: phoneController,
                              keyboardType: TextInputType.phone,
                              decoration: const InputDecoration(
                                prefixText: '+91 ',
                                border: OutlineInputBorder(),
                                labelText: 'Enter Phone Number',
                              ),
                            ),
                          ),
                          const SizedBox(height: 35),
                          // Login Button
                          InkWell(
                            onTap: isLoading ? null : handleLogin,
                            child: Container(
                              height: 60,
                              width: 450,
                              decoration: const BoxDecoration(color: kDark),
                              child: Center(
                                child: isLoading
                                    ? const CircularProgressIndicator(
                                        color: Colors.white)
                                    : const Text(
                                        'LOG IN',
                                        style: TextStyle(
                                            fontSize: 22, color: kWhite),
                                      ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  title: const Text(
                                    'Login Required',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                      fontSize: 18,
                                    ),
                                  ),
                                  content: const Text(
                                    'Login to unlock more features.',
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 16,
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pop(); // Close the dialog
                                            Get.to(() => defaultHome);
                                      },
                                      child: const Text(
                                        'Cancel',
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pop(); // Add Login action here
                                      },
                                      child: const Text(
                                        'Login',
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: Container(
                              height: 60,
                              width: 450,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border:
                                    Border.all(color: kDark, width: 4),
                              
                              ),
                              child: const Center(
                                child: Text(
                                  'SKIP',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: kPrimary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(
                            height: 10,
                          ),
                          // Register Link
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextButton(
                              onPressed: () {
                                Get.to(() => const SignupScreen());
                              },
                              child: const Text.rich(
                                TextSpan(
                                  text: "Didn't have an account? ",
                                  style: TextStyle(
                                      color: Colors.blue, fontSize: 20),
                                  children: [
                                    TextSpan(
                                      text: 'Click here',
                                      style: TextStyle(
                                          color: Colors.blue, fontSize: 20),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Title
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
