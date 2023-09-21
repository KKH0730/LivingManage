import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:livingmanage/AppColors.dart';

class TitleContainer extends StatelessWidget {
  String title;

  TitleContainer({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          height: 60,
          child: Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: AppColors.color_FF000000
                ),
              )
            ],
          ),
        ),
        Container(
          color: AppColors.color_1A000000,
          height: 1,
        )
      ],
    );
  }
}