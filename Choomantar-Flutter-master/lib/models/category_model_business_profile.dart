import 'dart:ui';

class CategoryModelBusinessProfile {
  final String name;
  final String image;
  int? amount;
  bool isCompleted;
  Color iColor;


  CategoryModelBusinessProfile(
      {required this.image,
        required this.name,
        required this.amount,
        required this.isCompleted,
        required this.iColor,
        });
}
