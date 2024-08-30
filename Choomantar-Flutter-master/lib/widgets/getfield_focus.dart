


import '../configs/imports/import_helper.dart';

getFieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  getUnfocusFieldChange(
      BuildContext context) {

    FocusScope.of(context).unfocus();
  }