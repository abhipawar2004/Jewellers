// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gehnamall/common/app_style.dart';
import 'package:gehnamall/common/reusable_text.dart';
import 'package:gehnamall/constants/constants.dart';
import 'package:gehnamall/controllers/light_category_controller.dart';
import 'package:gehnamall/models/light_category_models.dart';
import 'package:get/get.dart';

class LightCategoryWidget extends StatelessWidget {
  LightCategoryWidget({
    super.key,
    required this.lightCategories,
  });

  LightCategoryModels lightCategories;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LighhtCategoryController());
    return GestureDetector(
        onTap: () {
          if (controller.lightcategoryValue ==
              lightCategories.categoryId.toString()) {
            controller.updateLightCategory = '';
            controller.updateTitle = '';
            print(lightCategories.categoryId);
          } else {
            controller.updateLightCategory =
                lightCategories.categoryId.toString();
            controller.updateTitle = lightCategories.categoryName;
          }
        },
        child: Obx(
          () => Container(
            margin: EdgeInsets.only(right: 5.w),
            padding: EdgeInsets.only(top: 4.h),
            width: width * 0.19,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(
                    color: controller.lightcategoryValue ==
                            lightCategories.categoryId.toString()
                        ? kDark
                        : kWhite,
                    width: 0.5.w)),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 20.r,
                  backgroundImage: NetworkImage(lightCategories.exfield1),
                  backgroundColor: Colors.grey[200],
                ),
                ReusableText(
                  text: lightCategories.categoryName,
                  style: appStyle(10.sp, kDark, FontWeight.normal),
                  // textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ));
  }
}
