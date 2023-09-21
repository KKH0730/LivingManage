import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../AppColors.dart';

class AuthorizeButtonContainer extends StatelessWidget {

  const AuthorizeButtonContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.4),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3)
            )
          ],
          color: AppColors.color_FFFFFFFF
      ),
      height: 80,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _authorizeNegativeButton(),
          const SizedBox(width: 15),
          _authorizePositiveButton(),
          const SizedBox(width: 15)
        ],
      ),
    );
  }

  Widget _authorizePositiveButton() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3)
          )
        ],
        color: Colors.blue
      ),
      child: Text(
        'authorization_positive'.tr(),
        style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.color_FFFFFFFF
        ),
      ),
    );
  }

  Widget _authorizeNegativeButton() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3)
            )
          ],
          color: Colors.grey
      ),
      child: Text(
        'authorization_negative'.tr(),
        style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.color_FFFFFFFF
        ),
      ),
    );
  }
}