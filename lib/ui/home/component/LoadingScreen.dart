import 'package:flutter/cupertino.dart';

class LoadingScreen extends StatelessWidget {

  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CupertinoActivityIndicator(
        animating: true,
        radius: 20.0,
      ),
    );
  }
}