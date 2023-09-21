import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:livingmanage/AppColors.dart';
import 'package:livingmanage/data/model/AuthorizationItem.dart';
import 'package:livingmanage/data/provider/AuthorizationProvider.dart';
import 'package:livingmanage/ui/authorization/detail_authorization/component/AuthorizeButtonContainer.dart';
import 'package:livingmanage/ui/authorization/detail_authorization/component/ContentContainer.dart';
import 'package:livingmanage/ui/authorization/detail_authorization/component/TitleContainer.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'component/ImagePagerContainer.dart';

class AuthorizationDetailScreen extends StatefulWidget {
  static String PARAM_AUTHORIZATION_ITEM = 'authorizationItem';

  const AuthorizationDetailScreen({super.key});

  @override
  State<StatefulWidget> createState() => _AuthorizationDetailScreen();
}

class _AuthorizationDetailScreen extends State<AuthorizationDetailScreen> {
  AuthorizationProvider authorizationProvider = AuthorizationProvider();
  final Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic> map = ModalRoute.of(context)?.settings.arguments as Map<dynamic, dynamic>;
    AuthorizationItem authorizationItem = map[AuthorizationDetailScreen.PARAM_AUTHORIZATION_ITEM];

    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: authorizationProvider)
      ],
      child: CupertinoPageScaffold(
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
            middle: Text(
              'make_request_authorization'.tr(),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            padding: EdgeInsetsDirectional.zero,
          ),
          child: Expanded(
            child: Stack(
              children: [
                Scrollbar(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: [
                        ImagePagerContainer(imageUrls: authorizationItem.imageUrls),
                        // TitleContainer(title: authorizationItem.title),
                        ContentContainer(title: authorizationItem.title, content: authorizationItem.content, timestamp: authorizationItem.timestamp)
                      ],
                    ),
                  ),
                ),
                const Align(
                  alignment: Alignment.bottomCenter,
                  child: AuthorizeButtonContainer(),
                )
              ],
            ),
          )
      ),
    );
  }
}