import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:livingmanage/data/model/SharedPerson.dart';
import 'package:livingmanage/data/provider/HomeProvider.dart';
import 'package:livingmanage/main.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPeopleContainer extends StatefulWidget {

  const SharedPeopleContainer({super.key});

  @override
  State<StatefulWidget> createState() => _SharedPeopleContainerState();
}

class _SharedPeopleContainerState extends State<SharedPeopleContainer> with RouteAware {
  late HomeProvider homeProvider;
  final Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      routeObserver.subscribe(this, ModalRoute.of(context)!);

      prefs.then((value) async {
        homeProvider.reqSharedPeople(value.getString('id') ?? '');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    homeProvider = Provider.of<HomeProvider>(context);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: StreamBuilder(
        stream: homeProvider.onSharedPeopleImagesStream,
        builder: (context, snapshot) {
          List<SharedPerson> sharedPeople = snapshot.data ?? [];

          prefs.then((value) {
            sharedPeople.insert(
                0,
                SharedPerson(
                    id: value.getString('id') ?? '',
                    name: value.getString('name') ?? '',
                    profileUrl: value.getString('profileUrl') ?? ''
                )
            );
          });

          return ListView.separated(
            itemCount: sharedPeople.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              return _profileRoundedImage(sharedPeople[index]);
            },
          );
        },
      ),
    );
  }

  Widget _profileRoundedImage(SharedPerson sharedPerson) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: CachedNetworkImage(
        imageUrl: sharedPerson.profileUrl,
        cacheManager: CacheManager(Config(sharedPerson.profileUrl)),
        cacheKey: sharedPerson.profileUrl,
        fit: BoxFit.cover,
        fadeInDuration: Duration.zero,
        fadeOutDuration: Duration.zero,
        progressIndicatorBuilder: (context, url, progress) {
          if(progress.progress == null) {
            return Container();
          } else {
            return const CupertinoActivityIndicator(
              animating: true,
              radius: 20.0,
            );
          }
        },
      ),
    );
  }
}

