import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:livingmanage/data/provider/AuthorizationProvider.dart';
import 'package:livingmanage/ui/authorization/new_authorization/component/AuthorizationInputContainer.dart';
import 'package:livingmanage/ui/authorization/new_authorization/component/ImagePickContainer.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../AppColors.dart';


class AuthorizationScreen extends StatefulWidget {

  const AuthorizationScreen({super.key});

  @override
  State<StatefulWidget> createState() => _AuthorizationScreenState();
}

class _AuthorizationScreenState extends State<AuthorizationScreen> {
  AuthorizationProvider authorizationProvider = AuthorizationProvider();
  final Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  @override
  Widget build(BuildContext context) {
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
            trailing: Container(
              padding: const EdgeInsets.only(right: 10),
              child: GestureDetector(
                onTap: () =>
                  prefs.then((value) async {
                    bool isSuccessDataSave = await authorizationProvider.reqNewAuthorization(value.getString('id') ?? '');
                    if(isSuccessDataSave && context.mounted) {
                      Navigator.of(context).pop();
                    }
                  }),
                child: Text(
                  'confirm_all'.tr(),
                  style: TextStyle(
                      color: authorizationProvider.title.isNotEmpty && authorizationProvider.content.isNotEmpty ? AppColors.color_FF4A58E8 : AppColors.color_FFC7C7CB,
                      fontSize: 16,
                      fontWeight: FontWeight.w600
                  ),
                ),
              ),
            ),
            padding: EdgeInsetsDirectional.zero,
          ),
          child: Stack(
            children: [
              Column(
                children: [
                  ImagePickContainer(),
                  AuthorizationInputContainer(
                      onChangedText: () => setState(() {})
                  )
                ],
              ),
              StreamBuilder(
                  stream: authorizationProvider.loadingPublisher.stream,
                  builder: (context, snapshot) {
                    bool isShowLoading = snapshot.data ?? false;
                    if(isShowLoading) {
                      return Container(
                        alignment: Alignment.center,
                        color: AppColors.color_7B000000,
                        child: const CupertinoActivityIndicator(
                          animating: true,
                          radius: 20.0,
                        ),
                      );
                    } else {
                      return Container();
                    }
                  }
              )
            ],
          )
      ),
    );
  }
}