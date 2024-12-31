import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../controllers/user_controller.dart';
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
  final ProfileController profileController = Get.put(ProfileController());
  final Rx<File?> selectedImage = Rx<File?>(null);

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      selectedImage.value = File(pickedFile.path);
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    final userId = await AuthService.getUserId();
    if (userId != null) {
      await profileController.fetchUserProfile(userId);
    } else {
      Get.snackbar("Error", "User ID not found. Please log in again.");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
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
                        Obx(() => InkWell(
                              onTap: pickImage,
                              child: CircleAvatar(
                                maxRadius: 40.r,
                                backgroundImage: selectedImage.value != null
                                    ? FileImage(selectedImage.value!)
                                    : null,
                                child: selectedImage.value == null
                                    ? Icon(
                                        Icons.add_a_photo,
                                        size: 50.h,
                                      )
                                    : null,
                              ),
                            )),
                        SizedBox(height: 10.h),
                        Obx(() => Text(
                              profileController.userProfile['name'] ?? "User Name",
                              style: TextStyle(
                                fontSize: 20.h,
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                        SizedBox(height: 7.h),
                        Text(
                          "Welcome to Bansal Jewellers Pvt Ltd",
                          style: TextStyle(
                              color: kDark,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w500),
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
                    child: Obx(() => Column(
                          children: [
                            ProfileDetailRow(
                              title: "Email",
                              value: profileController.userProfile['email'] ?? "Not set",
                            ),
                            ProfileDetailRow(
                              title: "DOB",
                              value: profileController.userProfile['birthDate'] ??
                                  "Not set",
                            ),
                            ProfileDetailRow(
                              title: "Spouse DOB",
                              value: profileController.userProfile['spouseDate'] ??
                                  "Not set",
                            ),
                            ProfileDetailRow(
                              title: "Address",
                              value: profileController.userProfile['address'] ??
                                  "Not set",
                            ),
                            ProfileDetailRow(
                              title: "Pincode",
                              value: profileController.userProfile['pinCode'] ??
                                  "Not set",
                            ),
                          ],
                        )),
                  ),
                ),
              ),

              SizedBox(height: 20.h),

              // Edit Button
              ElevatedButton(
                onPressed: () => Get.to(() =>  UserDetailsForm()),
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
                    MaterialPageRoute(builder: (context) => LoginScreen()),
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
