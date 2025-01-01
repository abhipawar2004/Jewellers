import 'package:flutter/material.dart';
import 'package:gehnamall/views/entrypoint.dart';
import 'package:get/get.dart';

import '../../constants/constants.dart';
import '../../services/auth_service.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;
  const OtpScreen({super.key, required this.phoneNumber});

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> otpFields =
      List.generate(3, (index) => TextEditingController());
  final List<FocusNode> focusNodes = List.generate(3, (index) => FocusNode());

  bool isLoading = false;

  // Add a new variable to control OTP resend status
  bool isResendLoading = false;

  void handleOtpVerification() async {
    String otp = otpFields.map((controller) => controller.text).join();

    if (otp.length != 3) {
      Get.snackbar('Error', 'Please enter complete OTP');
      return;
    }

    setState(() => isLoading = true);

    final result = await AuthService.verifyOtp(widget.phoneNumber, otp);

    setState(() => isLoading = false);

    if (result['success']) {
      Get.offAll(() => MainScreen()); // Replace with your home screen
    } else {
      // Show error message
      String message = result['data']['message'] ?? 'Failed to verify OTP';
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  // Resend OTP handler
  void handleResendOtp() async {
    setState(() {
      isResendLoading = true; // Show loading indicator
    });

    final result = await AuthService.resendOtp(widget.phoneNumber);

    setState(() {
      isResendLoading = false; // Hide loading indicator
    });

    if (result['success']) {
      Get.snackbar('Success', 'OTP has been resent to your phone');
    } else {
      String message = result['data']['message'] ?? 'Failed to resend OTP';
      Get.snackbar('Error', message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Image.asset('assets/images/applogo.png',
                  height: 100), // Add your logo asset
              const SizedBox(height: 20),
              Text(
                "OTP Verification",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.red[700],
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Almost there! Please enter the OTP sent to\nyour device to verify your identity",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 10),
              Text(
                widget.phoneNumber,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),

              // OTP Input Fields
              SizedBox(
                width: 240,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(3, (index) {
                    return SizedBox(
                      width: 60,
                      height: 60,
                      child: TextField(
                        controller: otpFields[index],
                        focusNode: focusNodes[index],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        decoration: const InputDecoration(
                          counterText: "",
                        ),
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            if (index < 2) {
                              FocusScope.of(context)
                                  .requestFocus(focusNodes[index + 1]);
                            } else {
                              FocusScope.of(context).unfocus();
                            }
                          }
                        },
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 20),

              // Resend OTP Button
              isResendLoading
                  ? const CircularProgressIndicator()
                  : InkWell(
                      onTap: handleResendOtp,
                      child: const Text.rich(
                        TextSpan(
                          text: "Didn't receive OTP? ",
                          style: TextStyle(fontSize: 18, color: Colors.black54),
                          children: [
                            TextSpan(
                              text: "Resend OTP",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.blue),
                            ),
                          ],
                        ),
                      ),
                    ),
              const SizedBox(height: 20),

              // Verify Button
              InkWell(
                onTap: isLoading ? null : handleOtpVerification,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: kWhite,
                      border: Border.all(color: kDark, width: 3),
                    ),
                    child: Center(
                      child: isLoading
                          ? const CircularProgressIndicator(color: kPrimary)
                          : const Text(
                              'VERIFY',
                              style: TextStyle(fontSize: 20, color: kPrimary),
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
