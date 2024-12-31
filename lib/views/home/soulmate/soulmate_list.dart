import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gehnamall/common/shimmers/Light_categories_shimmer.dart';
import 'package:gehnamall/hooks/fetchSoulmate.dart';
import 'package:gehnamall/models/solemate_models.dart';
import 'package:gehnamall/views/home/soulmate/soulemate_widgets.dart';

class SoulmateList extends HookWidget {
  const SoulmateList({super.key});

  @override
  Widget build(BuildContext context) {
    final hookResult = UseFetchSoulmate();
    List<SoulmateModels>? soulmateList = hookResult.data;
    final isLoading = hookResult.isloading;
    final error = hookResult.error;

    if (isLoading) {
      return const LightCatergoriesShimmer();
    }

    if (error != null) {
      return Center(
        child: Text(
          'Error: Sorry Plz Try with Good Internet',
          style: TextStyle(fontSize: 16.sp, color: Colors.red),
        ),
      );
    }

    if (soulmateList == null || soulmateList.isEmpty) {
      return Center(
        child: Text(
          'No categories available.',
          style: TextStyle(fontSize: 16.sp, color: Colors.grey),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.only(left: 12.w, top: 10.h, right: 12.w),
      child: SingleChildScrollView(
        child: Wrap(
          spacing: 16
              .w, // Space between items horizontally (adjusted for better spacing)
          runSpacing: 16.h, // Space between rows (adjusted for better spacing)
          children: List.generate(soulmateList.length, (i) {
            SoulmateModels soulmate = soulmateList[i];
            return SizedBox(
              width: (MediaQuery.of(context).size.width - 48) /
                  2, // 2 items per row
              child: ClipRRect(
                borderRadius:
                    BorderRadius.circular(8.0), // Rounded corners for the items
                child: Container(
                  padding:
                      EdgeInsets.all(4.w), // Add padding to avoid cutting off
                  child: SoulmateWidgets(
                    image: soulmate.exfield1,
                    title: soulmate.giftingName,
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
