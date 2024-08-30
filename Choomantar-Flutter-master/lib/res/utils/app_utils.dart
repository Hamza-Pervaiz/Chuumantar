import '../../configs/imports/import_helper.dart';

class NavigationUtils {
  static void navigateWithAnimation(BuildContext context, Widget destinationScreen) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500), // Set the duration of the animation
        pageBuilder: (context, animation, secondaryAnimation) => destinationScreen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = const Offset(1.0, 0.0);
          var end = Offset.zero;
          var tween = Tween(begin: begin, end: end);
          var offsetAnimation = animation.drive(tween);
          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
    );
  }
}