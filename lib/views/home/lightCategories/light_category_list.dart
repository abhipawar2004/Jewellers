import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gehnamall/common/shimmers/Light_categories_shimmer.dart';
import 'package:gehnamall/hooks/fetchLightCategory.dart';
import 'package:gehnamall/models/light_category_models.dart';
import 'package:gehnamall/views/home/lightCategories/light_category_widgets.dart';

class LightCategoryList extends HookWidget {
  const LightCategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    final hookResult = UseFetchLightCategories();
    List<LightCategoryModels>? lightCategoriesList = hookResult.data;
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

    if (lightCategoriesList == null || lightCategoriesList.isEmpty) {
      return Center(
        child: Text(
          'No categories available.',
          style: TextStyle(fontSize: 16.sp, color: Colors.grey),
        ),
      );
    }

    return Container(
      height: 80.h,
      padding: EdgeInsets.only(left: 12.w, top: 10.h),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: List.generate(lightCategoriesList.length, (i) {
          LightCategoryModels lightCategories = lightCategoriesList[i];
          return LightCategoryWidget(lightCategories: lightCategories);
        }),
      ),
    );
  }
}
