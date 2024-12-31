import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gehnamall/common/shimmers/Light_categories_shimmer.dart';
import 'package:gehnamall/constants/constants.dart';
import 'package:gehnamall/hooks/fetch_occasion.dart';
import 'package:gehnamall/models/occasion_models.dart';
import 'package:gehnamall/views/home/occasion/occasion_widgets.dart';

class OccasionList extends HookWidget {
  const OccasionList({super.key});

  @override
  Widget build(BuildContext context) {
    final hookResult = useFetchOccasion();
    List<OccasionModels>? occasionList = hookResult.data;
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

    if (occasionList == null || occasionList.isEmpty) {
      return Center(
        child: Text(
          'No categories available.',
          style: TextStyle(fontSize: 16.sp, color: Colors.grey),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.only(left: 12.w, top: 10.h, right: 12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Horizontal scrollable list
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(occasionList.length, (i) {
                OccasionModels occasion = occasionList[i];
                return Padding(
                  padding: EdgeInsets.only(right: 8.w),
                  child: SizedBox(
                    width: (MediaQuery.of(context).size.width - 48) /
                        3, // 3 items per row
                    child: OccasionWidgets(
                      image: occasion.exfield1,
                      title: occasion.giftingName,
                    ),
                  ),
                );
              }),
            ),
          ),
          // Crazy UI: icons and animations for scroll guide
          Padding(
            padding: EdgeInsets.only(top: 1.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Swipe',
                  style: TextStyle(fontSize: 16.sp, color: kDark),
                ),
                // SizedBox(width: 10.w),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 20.sp,
                    color: kDark,
                    // Add a playful animation to the icon if desired
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
