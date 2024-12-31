import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gehnamall/common/app_style.dart';
import 'package:gehnamall/common/reusable_text.dart';
import 'package:gehnamall/constants/constants.dart';

class CustomeAppbar extends StatelessWidget {
  const CustomeAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      height: 100.h,
      width: width,
      color: kDark,
      child: Container(
        margin: EdgeInsets.only(top: 20.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment:
              CrossAxisAlignment.center, // Align items in the center vertically
          children: [
            // MENU BUTTON
            IconButton(
              icon: Icon(Icons.menu, color: kOffWhite),
              onPressed: () {
                // Add your menu action here
                print('Menu button pressed');
              },
            ),
            // SPACING
            SizedBox(width: 8.w),
            // TEXT
            ReusableText(
              text: "BANSAL & SONS JEWELLERS PVT LTD.",
              style: appStyle(13, kOffWhite, FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
