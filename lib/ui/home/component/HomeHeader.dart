import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:livingmanage/AppColors.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeHeader extends StatelessWidget {
  final Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return _homeHeader(context);
  }

  Widget _homeHeader(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Row(
        children: [
          const SizedBox(width: 24),
          Text(
            'app_name'.tr(),
            style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: AppColors.color_FF4A58E8
            ),
          ),
          Expanded(child: Container()),
          GestureDetector(
            onTap: () {
              prefs.then((value) async {
                String id = value.getString('id') ?? '';
                if(id.isEmpty) {
                  return;
                }

                PermissionStatus status = await Permission.camera.request();
                if(!status.isGranted) {
                  Fluttertoast.showToast(
                    msg: '권한 설정을 확인해주세요',
                    toastLength: Toast.LENGTH_SHORT,
                    fontSize: 18
                  );
                } else {
                  if(context.mounted) {
                    Navigator.pushNamed(
                        context,
                        '/ScanQrCodeScreen',
                        arguments: { 'id': id }
                    );
                  }
                }
              });
            },
            child: const Icon(
                CupertinoIcons.qrcode_viewfinder,
                size: 24,
                color: AppColors.color_A3E5E5E8
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () {
              prefs.then((value) {
                String id = value.getString('id') ?? '';
                String name = value.getString('name') ?? '';
                String profileUrl = value.getString('profileUrl') ?? '';
                if(id.isEmpty) {
                  return;
                }

                Navigator.pushNamed(
                    context,
                    '/CreateQrCodeScreen',
                    arguments: {
                      'id' : id,
                      'name' : name,
                      'profileUrl' : profileUrl
                    }
                );
              });
            },
            child: const Icon(
                CupertinoIcons.qrcode,
                size: 24,
                color: AppColors.color_A3E5E5E8
            ),
          ),
          const SizedBox(width: 12),
          const Icon(
            CupertinoIcons.bell_fill,
            size: 24,
            color: AppColors.color_A3E5E5E8
          ),
          const SizedBox(width: 24),
        ],
      ),
    );
  }
}