import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/banner_controller.dart';
import '../../../models/banner_models.dart';

class BannerWidget extends StatelessWidget {
  final BannerModel banner;

  BannerWidget({required this.banner});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BannerController());
    return Obx(
      () => GestureDetector(
        onTap: () => controller.banner.value = banner.bannerId.toString(),
        child: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 4,
          ), // Reduced vertical margin for less padding
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              // Overlapping container background color
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.blueGrey.withOpacity(0.3), // Background color
                  borderRadius: BorderRadius.circular(15), // Rounded corners
                ),
              ),
              ClipRRect(
                borderRadius:
                    BorderRadius.circular(15), // Rounded corners for the image
                child: Image.network(
                  banner.imageUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit
                      .cover, // Ensures the image covers the available space
                ),
              ),
              if (controller.banner.value == banner.bannerId)
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
