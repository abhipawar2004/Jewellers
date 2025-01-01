import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/auth_service.dart';
import '../authentication/login_screen.dart';
import 'edit_detail.dart';
import '../../common/custome_appbar.dart';
import '../../constants/constants.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? selectedImage; // Variable for selected image
  String userName = "Loading..."; // Initial loading state for username
  String email = "Loading..."; // Initial loading state for email
  String dob = "Loading..."; // Initial loading state for dob
  String spouseDob = "Loading..."; // Initial loading state for spouse dob
  String address = "Loading..."; // Initial loading state for address
  String pincode = "Loading..."; // Initial loading state for pincode

  @override
  void initState() {
    super.initState();
    _loadUserDetails(); // Load user details when the profile page is initialized
  }

  // Method to load user details using userId from SharedPreferences
  _loadUserDetails() async {
    final userId = await AuthService.getUserId();
    if (userId != null) {
      final response = await AuthService.getUserDetails(userId);

      if (response['success']) {
        setState(() {
          final data = response['data'];
          userName = data['name'] ?? "No Name"; 
          email = data['email'] ?? "Not set"; 
          dob = data['dateOfBirth'] ?? "Not set"; 
          spouseDob = data['spouseDob'] ?? "Not set"; 
          address = data['address'] ?? "Not set"; 
          pincode = data['pincode'] ?? "Not set"; 
        });
      } else {
        // Handle failure (e.g., show an error message)
        setState(() {
          userName = "Error loading data";
          email = "Error loading data";
        });
      }
    } else {
      setState(() {
        userName = "No user ID found";
      });
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(130.h),
        child: const CustomeAppbar(),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.r),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile Information Card
              SizedBox(
                height: 200.h,
                width: 400.w,
                child: Card(
                  color: kWhite,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: pickImage,
                          child: CircleAvatar(
                            maxRadius: 40.r,
                            backgroundImage: selectedImage != null
                                ? FileImage(selectedImage!)
                                : null,
                            child: selectedImage == null
                                ? Icon(
                                    Icons.add_a_photo,
                                    size: 50.h,
                                  )
                                : null,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          userName, // Dynamic username
                          style: TextStyle(
                            fontSize: 20.h,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 7.h),
                        Text(
                          "Welcome to Bansal Jewellers Pvt Ltd",
                          style: TextStyle(
                            color: kDark,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.h),

              // User Details Card
              SizedBox(
                width: 400.w,
                child: Card(
                  color: kWhite,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        ProfileDetailRow(
                          title: "Email",
                          value: email,
                        ),
                        ProfileDetailRow(
                          title: "DOB",
                          value: dob,
                        ),
                        ProfileDetailRow(
                          title: "Spouse DOB",
                          value: spouseDob,
                        ),
                        ProfileDetailRow(
                          title: "Address",
                          value: address,
                        ),
                        ProfileDetailRow(
                          title: "Pincode",
                          value: pincode,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.h),

              // Edit Button
              ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const UserDetailsForm()),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[900],
                  minimumSize: Size(double.infinity, 48.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: Text(
                  "Edit Details",
                  style: TextStyle(color: kWhite, fontSize: 16.sp),
                ),
              ),
              SizedBox(height: 12.h),

              // Logout Button
              ElevatedButton(
                onPressed: () async {
                  await AuthService.logout();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) =>  LoginScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[100],
                  minimumSize: Size(double.infinity, 48.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: Text(
                  "Logout",
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.red[900],
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

class ProfileDetailRow extends StatelessWidget {
  final String title;
  final String value;

  const ProfileDetailRow({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            "$title:",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 20),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
