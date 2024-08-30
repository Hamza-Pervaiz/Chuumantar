// ignore_for_file: must_be_immutable

import 'package:chumanter/configs/imports/import_helper.dart';

class TextFieldWidget extends StatelessWidget {
  TextFieldWidget(
      {super.key,
      required this.controller,
      this.hintText = '',
      this.prefix,
      this.borderColor = AppColors.whiteColor,
      this.borderRadius = 10,
      this.maxLength,
      this.hintTextSize = 14,
      this.autofocus = false,
      this.focusNode,
      this.disable = false,
      this.onfieldSubmit,
      this.textInputType});
  TextEditingController controller;
  String hintText;
  Widget? prefix;
  Color borderColor;
  double borderRadius;
  TextInputType? textInputType;
  int? maxLength;
  double hintTextSize;
  FocusNode? focusNode;
  bool disable;
  bool autofocus;
  void Function(String)? onfieldSubmit;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: disable,
      autofocus: autofocus,
      focusNode: focusNode,
      controller: controller,
      keyboardType: textInputType,
      onFieldSubmitted: onfieldSubmit,
      maxLength: maxLength,
      style: const TextStyle(color: AppColors.whiteColor),
      cursorColor: AppColors.primaryColor,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.zero,
        hintText: hintText,
        hintStyle: TextStyle(
          fontFamily: AppConst.secondaryFont,
          fontSize: hintTextSize,
          color: AppColors.whiteColor.withOpacity(0.8),
        ),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(
              color: borderColor,
            )),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: const BorderSide(
              color: AppColors.whiteColor,
            )),
        prefixIcon: prefix,
      ),
    );
  }
}
