import 'package:get/get.dart';

import '../services/auth_service.dart';

class UserController extends GetxController {

  final Rx<String?> email = Rx<String?>(null);
  final Rx<String?> gender = Rx<String?>(null);
  final Rx<DateTime?> birthDate = Rx<DateTime?>(null);
  final Rx<DateTime?> spouseDate = Rx<DateTime?>(null);
  final Rx<String?> address = Rx<String?>(null);
  final Rx<String?> pinCode = Rx<String?>(null);

  @override
  void onInit() {
    super.onInit();
  }

  void updateUserDetails({
    String? email,
    String? gender, 
    DateTime? birthDate,
    DateTime? spouseDate,
    String? address,
    String? pinCode,
  }) {
    this.email.value = email;
    this.gender.value = gender;
    this.birthDate.value = birthDate;
    this.spouseDate.value = spouseDate;
    this.address.value = address;
    this.pinCode.value = pinCode;
  }

  String formatDate(DateTime? date) {
    if (date == null) return 'Not set';
    return '${date.day}/${date.month}/${date.year}';
  }
}

class ProfileController extends GetxController {
  final RxMap<String, dynamic> userProfile = RxMap();

  Future<void> fetchUserProfile(String userId) async {
    final response = await AuthService.getUserDetails(userId);

    if (response['success']) {
      userProfile.assignAll(response['data']);
    } else {
      Get.snackbar("Error", response['message']);
    }
  }
}
