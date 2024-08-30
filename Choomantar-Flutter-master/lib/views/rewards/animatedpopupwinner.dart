import 'package:flutter/material.dart';

class WinnerPopup extends StatefulWidget {
  @override
  _WinnerPopupState createState() => _WinnerPopupState();
}

class _WinnerPopupState extends State<WinnerPopup>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.bounceInOut,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void showWinnerPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ScaleTransition(
          scale: _scaleAnimation,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            title: Text('Congratulations!'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/trophy.png',
                    height: 100, width: 100), // Replace with your asset
                SizedBox(height: 20),
                Text('You are the winner of the lucky draw!'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Animated Winner Pop-up')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            showWinnerPopup(context);
          },
          child: Text('Show Winner Pop-up'),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: WinnerPopup(),
  ));
}
