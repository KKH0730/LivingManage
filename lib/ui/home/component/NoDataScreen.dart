import 'package:flutter/cupertino.dart';

class NoDataScreen extends StatelessWidget {

  const NoDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('데이터가 없습니다'),
    );
  }
}