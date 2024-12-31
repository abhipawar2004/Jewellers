import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gehnamall/common/shimmers/Light_categories_shimmer.dart';
import 'package:gehnamall/hooks/fetchGifting.dart';
import 'package:gehnamall/models/gifting_models.dart';
import 'package:gehnamall/views/home/Gifting/gifting_widgets.dart';

class GiftingList extends HookWidget {
  const GiftingList({super.key});

  @override
  Widget build(BuildContext context) {
    final hookResult = UseFetchGifting();
    List<GiftingModels>? giftingList = hookResult.data;
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

    if (giftingList == null || giftingList.isEmpty) {
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
          spacing: 1.w, // Space between items horizontally
          runSpacing: 1.h, // Space between rows
          children: List.generate(giftingList.length, (i) {
            GiftingModels gifting = giftingList[i];
            return SizedBox(
              width: (MediaQuery.of(context).size.width - 48) /
                  3, // 3 items per row
              child: GiftingWidgets(
                image: gifting.exfield1,
                title: gifting.giftingName,
              ),
            );
          }),
        ),
      ),
    );
  }
}
