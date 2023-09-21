import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../AppColors.dart';

class ContentContainer extends StatelessWidget {
  String title;
  String content;
  int timestamp;


  ContentContainer({super.key, required this.title, required this.content, required this.timestamp});

  @override
  Widget build(BuildContext context) {
    var format = DateFormat('yy.MM.dd');
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp);

    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 0, right: 16, bottom: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.color_FF000000
            ),
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Text(
                format.format(date),
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.color_FFB9B9BB
                ),
              ),
              Expanded(child: Container()),
              const SizedBox(width: 16)
            ],
          ),
          const SizedBox(height: 30),
          Text(
            content,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: AppColors.color_FF000000
            ),
          )
        ],
      ),
    );
  }
}