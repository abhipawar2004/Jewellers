import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/constants.dart';
import '../../services/auth_service.dart';
import 'login_screen.dart';


class SignupScreen extends StatefulWidget {
  final String? phoneNumber;

  const SignupScreen({super.key, this.phoneNumber});  
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    if (widget.phoneNumber != null) {
      phoneController.text = widget.phoneNumber!;
    }
  }

 void handleSignup() async {
  if (nameController.text.isEmpty || phoneController.text.isEmpty) {
    Get.snackbar('Error', 'Please fill all fields');
    return;
  }

  setState(() => isLoading = true);

  final result = await AuthService.signUp(
    phoneController.text,
    nameController.text,
  );

  setState(() => isLoading = false);

  if (result['success']) {
    Get.snackbar('Success', 'User registered successfully!');
    Get.to(() => LoginScreen());
  } else {
    if (result['data']['message'] == 'User already exists') {
      Get.snackbar(
        'Error',
        'User already exists. Please log in.',
      );
      Get.to(() => LoginScreen()); // Navigate back to login
    } else {
      Get.snackbar(
        'Error',
        result['data']['message'] ?? 'Signup failed. Please try again.',
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
                              'Sign Up',
                              style: TextStyle(
                                fontSize: 50,
                                color: kDark,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            'Welcome to Our Gold Please Fill Details',
                            style: TextStyle(fontSize: 20, color: Colors.black),
                          ),
                          const SizedBox(height: 25),
                          // Phone Number Input
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: TextField(
                              controller: nameController,
                              keyboardType: TextInputType.name,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  label: Text('Name'),
                                  hintText: 'Full Name'),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: TextField(
                              controller: phoneController,
                              keyboardType: TextInputType.phone,
                              decoration: const InputDecoration(
                                prefixText: '+91 ',
                                border: OutlineInputBorder(),
                                labelText: 'Mobile Number',
                              ),
                            ),
                          ),
                          const SizedBox(height: 35),

                          InkWell(
                            onTap: isLoading ? null : handleSignup,
                            child: Container(
                              height: 65,
                              width: 450,
                              decoration: const BoxDecoration(color: kDark),
                              child: Center(
                                child: isLoading
                                    ? const CircularProgressIndicator(
                                        color: Colors.white)
                                    : const Text(
                                        'SIGN UP',
                                        style: TextStyle(
                                            fontSize: 22, color: kWhite),
                                      ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          // Terms and Conditions
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 10.0),
                            child: Text(
                              'By registering, you agree to our Terms and Conditions and Privacy Policy. Please read them carefully before proceeding.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade800,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
