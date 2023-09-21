import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../AppColors.dart';

class CreateQrCodeScreen extends StatelessWidget {
  String email = '';

  CreateQrCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic> map = ModalRoute.of(context)?.settings.arguments as Map<dynamic, dynamic>;
    String id = map['id'] as String;
    String name = map['name'] as String;
    String profileUrl = map['profileUrl'] as String;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: AppColors.color_FFFFFFFF,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
              padding: const EdgeInsets.only(left: 10),
              child: const Icon(
                Icons.arrow_back_outlined,
                size: 28,
                color: AppColors.color_FF000000,
              )),
        ),
      ),
      child: Center(
        child: QrImageView(
          data: '$id|$name|$profileUrl',
          version: QrVersions.auto,
          size: 200,
        ),
      ),
    );
  }
}