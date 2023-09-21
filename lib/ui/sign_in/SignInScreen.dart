import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:livingmanage/data/provider/SessionProvider.dart';
import 'package:livingmanage/data/provider/SignInProvider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../AppColors.dart';

class SignInScreen extends StatefulWidget {
  SignInProvider signInProvider = SignInProvider();

  @override
  State<StatefulWidget> createState() => _SignInScreenState(signInProvider: signInProvider);
}

class _SignInScreenState extends State<SignInScreen> {
  bool isShowLoading = false;
  TextEditingController idEditController = TextEditingController();
  TextEditingController passwordEditController = TextEditingController();
  final Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  late SessionProvider sessionProvider;
  SignInProvider signInProvider;

  _SignInScreenState({required this.signInProvider });

  @override
  Widget build(BuildContext context) {
    sessionProvider = Provider.of<SessionProvider>(context);

    return MultiProvider(
      providers: [ChangeNotifierProvider.value(value: signInProvider)],
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          backgroundColor: AppColors.color_FFFFFFFF,
          middle: Text(
            'sign_in_title'.tr(),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          padding: EdgeInsetsDirectional.zero,
        ),
        child: Stack(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 200),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 4 / 5,
                    child: CupertinoTextField(
                      cursorColor: AppColors.color_FF000000,
                      controller: idEditController,
                      maxLines: 1,
                      maxLength: 50,
                      keyboardType: TextInputType.text,
                      padding: const EdgeInsets.only(left: 15, top: 20, bottom: 20, right: 15),
                      style:
                      const TextStyle(color: AppColors.color_FF000000, fontSize: 18, fontWeight: FontWeight.w500),
                      placeholder: 'sign_in_id_placeholder'.tr(),
                      placeholderStyle:
                      const TextStyle(color: AppColors.color_FFB9B9BB, fontSize: 18, fontWeight: FontWeight.w600),
                      decoration: BoxDecoration(
                          color: AppColors.color_79ECE9E9,
                          borderRadius: BorderRadius.circular(50.0),
                          border: Border.all(color: AppColors.color_5FE5E5E5)),
                      onChanged: (value) {
                        signInProvider.id = value;
                        signInProvider.password = value;
                      },
                    ),
                  ),
                  const SizedBox(height: 50),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 4 / 5,
                    child: CupertinoButton(
                        onPressed: () async {
                          bool isSuccess = await signInProvider.reqSignIn();

                          if (isSuccess) {
                            prefs.then((prefs) {
                              prefs.setString('id', idEditController.text.toString());
                            });

                            if (context.mounted) {
                              Navigator.pushNamed(
                                context,
                                '/HomeScreen',
                              );
                            }
                          }
                        },
                        color: CupertinoColors.activeBlue,
                        child: Text(
                          'confirm_all'.tr(),
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                        )),
                  ),
                  const SizedBox(height: 50),
                  GestureDetector(
                    onTap: () async {
                      setState(() => isShowLoading = true);
                      UserCredential userCredential = await sessionProvider.signInWithGoogle();
                      prefs.then((value) {
                        User? user = userCredential.user;
                        if (user != null) {
                          value.setString("id", user.email ?? '');
                          value.setString("name", user.displayName ?? 'User');
                          value.setString("profileUrl", user.photoURL ?? 'User');

                          value.setString("hostId", user.email ?? '');
                          value.setString("hostName", user.displayName ?? 'User');
                          value.setString("hostProfileUrl", user.photoURL ?? 'User');

                          Navigator.pushNamed(
                            context,
                            '/HomeScreen',
                          );
                        } else {
                          Fluttertoast.showToast(
                            msg: 'Login Fail.\nPlease retry',
                            toastLength: Toast.LENGTH_LONG,
                            fontSize: 18.0,
                          );
                        }
                      });
                      setState(() => isShowLoading = false);
                    },
                    child: Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                      child: Image.asset(
                        'assets/images/ic_logo_google.png',
                        width: 24,
                        height: 24,
                      ),
                    ),
                  )
                ],
              ),
            ),
            if (isShowLoading)
              Container(
                alignment: Alignment.center,
                child: const CupertinoActivityIndicator(
                  animating: true,
                  radius: 20.0,
                ),
              )
          ],
        ),
      ),
    );
  }
}
