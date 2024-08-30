import 'package:flutter/material.dart';

import '../../res/app_const.dart';
import '../../res/reponsive_size.dart';

class ReusablePaymentContainer extends StatelessWidget {
  String text;
  String image;
  ReusablePaymentContainer(
      {super.key, required this.text, required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14.0),
      margin: EdgeInsets.symmetric(
        vertical: MySize.size10,
        horizontal: MySize.size42,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(MySize.size16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(0, 3),
          ),
        ],
        image: const DecorationImage(
          image: AssetImage(AppConst.eyeBg),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey, // Border color
                    width: 1, // Border width
                  ),
                  borderRadius: BorderRadius.circular(MySize.size8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(MySize.size8),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Image.asset(
                      image, // Replace with your asset path for EasyPaisa logo
                      width: MySize.size48,
                      height: MySize.size48,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              SizedBox(width: MySize.size40),
              Text(
                text,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: MySize.size18,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
