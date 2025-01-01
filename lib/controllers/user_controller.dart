import 'package:get/get.dart';

class UserController extends GetxController {
  final Rx<String?> email = Rx<String?>(null);
  final Rx<String?> gender = Rx<String?>(null);
  final Rx<DateTime?> birthDate = Rx<DateTime?>(null);
  final Rx<DateTime?> spouseDate = Rx<DateTime?>(null);
  final Rx<String?> address = Rx<String?>(null);
  final Rx<String?> pinCode = Rx<String?>(null);

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
