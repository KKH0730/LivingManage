import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../AppColors.dart';

class ImageDetailScreen extends StatelessWidget {
  late PageController pageController;
  int selectedIndex = 0;

  ImageDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic> map = ModalRoute.of(context)?.settings.arguments as Map<dynamic, dynamic>;
    List<String> imageUrls = map['imageUrls'] as List<String>;
    int prevSelectedIndex = map['prevSelectedIndex'] as int;
    selectedIndex = prevSelectedIndex;

    pageController = PageController(initialPage: prevSelectedIndex);
    pageController.addListener(() {
      selectedIndex = pageController.page?.round() ?? 0;
    });

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: AppColors.color_FFFFFFFF,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context, selectedIndex),
          child: Container(
              padding: const EdgeInsets.only(left: 10),
              child: const Icon(
                Icons.arrow_back_outlined,
                size: 28,
                color: AppColors.color_FF000000,
              )),
        ),
      ),
      child: Stack(
        children: [
          PageView.builder(
              controller: pageController,
              itemCount: imageUrls.length,
              itemBuilder: (context, index) {
                return Hero(
                  tag: 'image',
                  child: CachedNetworkImage(
                    imageUrl: imageUrls[index],
                    cacheManager: CacheManager(Config(imageUrls[index])),
                    cacheKey: imageUrls[index],
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
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: SmoothPageIndicator(
                  controller: pageController, // PageController
                  count: imageUrls.length,
                  effect: const WormEffect(
                      activeDotColor: AppColors.color_FFFFFFFF,
                      dotColor: AppColors.color_FFC7C7CB,
                      radius: 100,
                      dotHeight: 8,
                      dotWidth: 8,
                      spacing: 10
                  ), // your preferred effect
                  onDotClicked: (index) {}),
            ),
          )
        ],
      ),
    );
  }
}