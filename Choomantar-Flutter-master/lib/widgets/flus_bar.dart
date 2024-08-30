import '../configs/imports/import_helper.dart';

getFlushBar(
  BuildContext context, {
  required String title,
}) {
  return Flushbar(
    message: title,
    icon: const Icon(
      Icons.info_outline,
      size: 28.0,
      color: Colors.blue,
    ),
    margin: const EdgeInsets.all(8),
    borderRadius: BorderRadius.circular(8),
    duration: const Duration(seconds: 3),
  )..show(context);
}

showBar(BuildContext context,
    {required String message, Color color = AppColors.blackColor}) {
  return Center(
    child: Flushbar(
      animationDuration: const Duration(milliseconds: 1500),
      message: message,
      backgroundColor: color,
      flushbarPosition: FlushbarPosition.BOTTOM,
      maxWidth: MySize.screenWidth,
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(MySize.size30),
      duration: const Duration(seconds: 3),
    )..show(context),
  );
}
