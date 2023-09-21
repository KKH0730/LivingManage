import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../AppColors.dart';

class ScanQrCodeScreen extends StatefulWidget {

  const ScanQrCodeScreen({super.key});

  @override
  State<StatefulWidget> createState() => ScanQrCodeScreenState();
}

class ScanQrCodeScreenState extends State<ScanQrCodeScreen> with SingleTickerProviderStateMixin{
  final Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  late AnimationController animationController;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

  @override
  void initState() {
    animationController = BottomSheet.createAnimationController(this);
    animationController
      ..addListener(() {
        print('listen : ${animationController.value}, : ${animationController.status}');
      })
      ..duration = const Duration(milliseconds: 500);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if(scanData.code != null) {
        List<String> strs = scanData.code!.split("|");
        if(strs.length >= 2) {
          String hostId = strs[0];
          String hostName = strs[1];
          String hostProfileUrl = '';
          if(strs.length == 3) {
            hostProfileUrl = strs[2];
          }

          if(animationController.status == AnimationStatus.dismissed) {
            showModalBottomSheet(
                context: context,
                enableDrag: true,
                isDismissible: true,
                useSafeArea: false,
                transitionAnimationController: animationController,
                builder: (context) {
                  return Container(
                    height: 150,
                    decoration: const BoxDecoration(
                      color: Colors.white, // 모달 배경색
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30), // 모달 좌상단 라운딩 처리
                        topRight: Radius.circular(30), // 모달 우상단 라운딩 처리
                      ),
                    ),
                    child: Center(
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          Text(
                              '${hostName}님이 당신을 초대했습니다!',
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.color_FF000000
                              )
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: [
                                Expanded(
                                    child: _inviteButton(
                                        Colors.grey,
                                        '취소',
                                        () => animationController.reverse()
                                    )
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                    child: _inviteButton(
                                        Colors.blue,
                                        '수락',
                                        () {
                                          prefs.then((value) {
                                            value.setString('hostId', hostId);
                                            value.setString('hostName', hostName);
                                            value.setString('hostProfileUrl', hostProfileUrl);
                                          });
                                          animationController.reverse();
                                          Navigator.pop(context);
                                        }
                                    )
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ), // 모달 내부 디자인 영역
                  );
                }
            );
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
      child: Column(
        children: [
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderRadius: 10.0,
                borderLength: 50,
                borderWidth: 5,
                borderColor: AppColors.color_FF4A58E8,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _inviteButton(Color color, String content, GestureTapCallback gestureTapCallback) {
    return GestureDetector(
      onTap: gestureTapCallback,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
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
            color: color
        ),
        child: Text(
            content,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.color_FFFFFFFF
            ),
            textAlign: TextAlign.center
        ),
      ),
    );
  }
}