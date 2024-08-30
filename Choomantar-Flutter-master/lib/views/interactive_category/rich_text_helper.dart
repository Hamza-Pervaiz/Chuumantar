import 'package:flutter/material.dart';

import '../../res/app_colors.dart';
import '../../res/reponsive_size.dart';

class RichTextHelper extends StatelessWidget {
  RichTextHelper(
      {super.key, required this.firstText, required this.secondText});

  String firstText;
  String secondText;
  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: firstText,
            style: TextStyle(
              color:
                  Colors.white, // Set the color for the text you're displaying
              fontSize: MySize.size17,
              fontWeight: FontWeight.w700,
            ),
          ),
          TextSpan(
            text: secondText,
            style: TextStyle(
              color: AppColors
                  .secondaryColor, // Set the color for the data from the API
              fontSize: MySize.size17,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
