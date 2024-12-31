import 'package:flutter/material.dart';
import 'package:gehnamall/models/sub_categories_models.dart';

class GenderSelection extends StatefulWidget {
  final Function(Gender) onGenderSelected;

  const GenderSelection({Key? key, required this.onGenderSelected})
      : super(key: key);

  @override
  _GenderSelectionState createState() => _GenderSelectionState();
}

class _GenderSelectionState extends State<GenderSelection> {
  Gender? _selectedGender;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50], // Light background for the screen
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Row to place both images in one row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Column for Men
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedGender = Gender.MEN;
                    });
                    widget.onGenderSelected(Gender.MEN);
                  },
                  child: _buildGenderCard(
                    'assets/images/mens.jpg',
                    'Men',
                  ),
                ),
                SizedBox(width: 20), // Space between images
                // Column for Women
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedGender = Gender.WOMEN;
                    });
                    widget.onGenderSelected(Gender.WOMEN);
                  },
                  child: _buildGenderCard(
                    'assets/images/womens.jpg',
                    'Women',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderCard(String imagePath, String genderLabel) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              imagePath,
              width: 150,
              height: 150,
              fit: BoxFit.contain, // Ensure the image is not cropped
            ),
          ),
        ),
        const SizedBox(height: 12), // Space between image and label
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            genderLabel,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
