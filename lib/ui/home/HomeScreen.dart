import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:livingmanage/AppColors.dart';
import 'package:livingmanage/data/provider/AuthorizationProvider.dart';
import 'package:livingmanage/data/provider/HomeProvider.dart';
import 'package:livingmanage/ui/authorization/new_authorization/AuthorizationScreen.dart';
import 'package:livingmanage/ui/home/component/AuthorizationPreviewContainer.dart';
import 'package:provider/provider.dart';

import 'component/HomeHeader.dart';

class HomeScreen extends StatelessWidget {

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context)  {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: HomeProvider())
      ],
      child:  CupertinoPageScaffold(
        child: Column(
          children: [
            HomeHeader(),
            _purchaseRequestButton(
                context,
                'assets/images/img_pray.png',
                'make_request_authorization'.tr(),
                    () => Navigator.pushNamed(
                    context,
                    '/AuthorizationScreen'
                )
            ),
            const SizedBox(height: 18),
            _purchaseRequestButton
              (context,
                'assets/images/ic_coin.png',
                'make_request_send_money'.tr(),
                    () => Navigator.pushNamed(
                    context,
                    '/AuthorizationScreen'
                )
            ),
            const SizedBox(height: 50),
            const AuthorizationPreviewContainer()
          ],
        ),
      ),
    );
  }

  Widget _purchaseRequestButton(BuildContext context, String imagePath, String name, GestureTapCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.color_5FE5E5E5,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: Image.asset(imagePath),
            ),
            const SizedBox(width: 10),
            Expanded(
                child: Text(
                  name,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: AppColors.color_FF000000),
                  overflow: TextOverflow.ellipsis,
                ))
          ],
        ),
      ),
    );
  }
}
