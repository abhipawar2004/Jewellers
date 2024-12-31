import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/user_controller.dart';
import '../../services/auth_service.dart';

class UserDetailsForm extends StatefulWidget {
  const UserDetailsForm({Key? key}) : super(key: key);

  @override
  _UserDetailsFormState createState() => _UserDetailsFormState();
}

class _UserDetailsFormState extends State<UserDetailsForm> {
  final _formKey = GlobalKey<FormState>();
  final UserController userController = Get.find<UserController>();

  // Form field controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController pinCodeController = TextEditingController();

  // Other variables
  String gender = 'Male';
  DateTime? birthDate;
  DateTime? spouseDate;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing values
    emailController.text = userController.email.value ?? '';
    addressController.text = userController.address.value ?? '';
    pinCodeController.text = userController.pinCode.value ?? '';
    gender = userController.gender.value ?? 'Male';
    birthDate = userController.birthDate.value;
    spouseDate = userController.spouseDate.value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: Colors.red[900],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLabel('Email'),
                _buildEmailField(),

                const SizedBox(height: 16),

                _buildLabel('Gender'),
                _buildGenderDropdown(),

                const SizedBox(height: 16),

                _buildLabel('Birth Date'),
                _buildDateField(
                  date: birthDate,
                  onDateSelected: (date) => setState(() => birthDate = date),
                  hintText: 'Select Date',
                ),

                const SizedBox(height: 16),

                _buildLabel('Spouse Date'),
                _buildDateField(
                  date: spouseDate,
                  onDateSelected: (date) => setState(() => spouseDate = date),
                  hintText: 'Select Date',
                ),

                const SizedBox(height: 16),

                _buildLabel('Address'),
                _buildTextField(
                  controller: addressController,
                  hint: 'Enter your address',
                ),

                const SizedBox(height: 16),

                _buildLabel('Pin Code'),
                _buildTextField(
                  controller: pinCodeController,
                  hint: 'Enter your pin code',
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your pin code';
                    } else if (!RegExp(r'^\d{6}$').hasMatch(value)) {
                      return 'Pin code must be 6 digits';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 24),

                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: emailController,
      decoration: _inputDecoration('Enter your email'),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
        } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
          return 'Enter a valid email address';
        }
        return null;
      },
    );
  }

  Widget _buildGenderDropdown() {
    return DropdownButtonFormField<String>(
      value: gender,
      decoration: _inputDecoration('Select Gender'),
      items: ['Male', 'Female', 'Other']
          .map((g) => DropdownMenuItem(value: g, child: Text(g)))
          .toList(),
      onChanged: (value) => setState(() => gender = value!),
    );
  }

  Widget _buildDateField({
    required DateTime? date,
    required ValueChanged<DateTime> onDateSelected,
    required String hintText,
  }) {
    return TextFormField(
      readOnly: true,
      decoration: _inputDecoration(date?.toString().split(' ')[0] ?? hintText),
      onTap: () async {
        final selectedDate = await showDatePicker(
          context: context,
          initialDate: date ?? DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        if (selectedDate != null) {
          onDateSelected(selectedDate);
        }
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    String? hint,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: _inputDecoration(hint ?? ''),
      validator: validator,
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _handleSubmit,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red.shade900,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text(
          'Update Details',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[400]),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.red),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.red),
      ),
    );
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      try {
        final userId = await AuthService.getUserId();

        if (userId == null || userId.isEmpty) {
          Get.snackbar("Error", "User ID not found. Please log in again.");
          return;
        }

        final response = await AuthService.updateUserDetails(
          userId: userId,
          email: emailController.text,
          gender: gender,
          address: addressController.text,
          pinCode: pinCodeController.text,
          birthDate: birthDate!,
          spouseDate: spouseDate,
        );

        if (response['success']) {
          userController.updateUserDetails(
            email: emailController.text,
            gender: gender,
            address: addressController.text,
            pinCode: pinCodeController.text,
            birthDate: birthDate,
            spouseDate: spouseDate,
          );

          Get.back();
          Get.snackbar("Success", "User details updated successfully.");
        } else {
          final message = response['data']['message'] ??
              "Failed to update details. Please try again.";
          Get.snackbar("Error", message);
        }
      } catch (e) {
        Get.snackbar("Error", "An error occurred: ${e.toString()}");
      }
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    addressController.dispose();
    pinCodeController.dispose();
    super.dispose();
  }
}
