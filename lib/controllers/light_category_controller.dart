// ignore_for_file: prefer_final_fields

import 'package:get/get.dart';

class LighhtCategoryController extends GetxController {
  RxString _lightcategory = ''.obs;

  String get lightcategoryValue => _lightcategory.value;

  set updateLightCategory(String value) {
    _lightcategory.value = value;
  }

  RxString _title = ''.obs;

  String get titleValue => _title.value;

  set updateTitle(String value) {
    _title.value = value;
  }
}
