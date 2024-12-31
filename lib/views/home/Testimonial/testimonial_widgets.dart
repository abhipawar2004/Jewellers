import 'package:flutter/material.dart';
import 'package:gehnamall/models/testimonial_models.dart';
import 'package:get/get.dart';

import '../../../controllers/banner_controller.dart';

class TestimonialWidget extends StatelessWidget {
  final TestimonialModels testimonial;

  TestimonialWidget({required this.testimonial});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BannerController());
    return Obx(
      () => GestureDetector(
        onTap: () =>
            controller.banner.value = testimonial.testimonialId.toString(),
        child: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 4,
          ), // Reduced vertical margin for less padding
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              ClipRRect(
                borderRadius:
                    BorderRadius.circular(15), // Rounded corners for the image
                child: Image.network(
                  testimonial.imageUrl,
                  height: 300,
                  width: double.infinity,
                  fit: BoxFit
                      .contain, // Ensures the image covers the available space
                ),
              ),
              if (controller.banner.value == testimonial.testimonialId)
                Positioned(
                  bottom:
                      20, // Increase the bottom padding to avoid overlap with image or other content
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Selected',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
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
