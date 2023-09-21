import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:livingmanage/data/model/AuthorizationItem.dart';
import 'package:livingmanage/data/provider/HomeProvider.dart';
import 'package:livingmanage/ui/authorization/detail_authorization/AuthorizationDetailScreen.dart';
import 'package:livingmanage/ui/home/component/ErrorScreen.dart';
import 'package:livingmanage/ui/home/component/LoadingScreen.dart';
import 'package:livingmanage/ui/home/component/NoDataScreen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../AppColors.dart';
import '../../../main.dart';

class AuthorizationPreviewContainer extends StatefulWidget {

  const AuthorizationPreviewContainer({super.key});


  @override
  State<StatefulWidget> createState() => _AuthorizationPreviewContainerState();
}

class _AuthorizationPreviewContainerState extends State<AuthorizationPreviewContainer> with RouteAware {
  late HomeProvider homeProvider;
  final Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      routeObserver.subscribe(this, ModalRoute.of(context)!);

      prefs.then((value) async {
        homeProvider.reqOnAirAuthorization(value.getString('id') ?? '');
      });
    });
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPushNext() {
    super.didPush();
  }

  @override
  void didPopNext() {
    super.didPopNext();
    prefs.then((value) async {
      homeProvider.reqOnAirAuthorization(value.getString('hostId') ?? '');
    });
  }

  @override
  Widget build(BuildContext context) {
    homeProvider = Provider.of<HomeProvider>(context);

    return Column(
      children: [
        Text(
          'on_air_authorization'.tr(),
          style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: AppColors.color_FF000000
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 300,
          child: StreamBuilder(
            stream: homeProvider.onAirAuthorizationStream,
            builder: (context, snapshot) {
              if(snapshot.connectionState == ConnectionState.waiting) {
                return const LoadingScreen();
              } else if (snapshot.hasError) {
                return const ErrorScreen();
              } else if (!snapshot.hasData || snapshot.data?.isEmpty == true) {
                return const NoDataScreen();
              } else {
                final authorizationItems = snapshot.data!;
                return ListView.builder(
                    itemCount: authorizationItems.length,
                    itemBuilder: (context, index) {
                      return _onAirAuthorizationItem(
                          index,
                          authorizationItems[index],
                          () => Navigator.pushNamed(
                              context,
                              '/AuthorizationDetailScreen',
                              arguments: { AuthorizationDetailScreen.PARAM_AUTHORIZATION_ITEM: authorizationItems[index] }
                          )
                      );
                    });
              }
            },
          ),
        )
      ],
    );
  }

  Widget _onAirAuthorizationItem(int index, AuthorizationItem item, GestureTapCallback gestureTapCallback) {
    return GestureDetector(
      onTap: gestureTapCallback,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
        width: 200,
        child: Row(
          children: [
            Text(
              'title : ${item.title}',
              style: const TextStyle(
                  fontSize: 18
              ),
            )
          ],
        ),
      ),
    );
  }
}