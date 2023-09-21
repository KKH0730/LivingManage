import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:livingmanage/AppColors.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ImagePagerContainer extends StatelessWidget with RouteAware {
  List<String> imageUrls;
  final PageController pageController = PageController(initialPage: 0);

  ImagePagerContainer({super.key, required this.imageUrls});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height:MediaQuery.of(context).size.width * 4 / 5,
      child: Stack(
        children: [
          PageView.builder(
              controller: pageController,
              itemCount: imageUrls.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () async {
                    final result = await Navigator.pushNamed(
                        context,
                      '/ImageDetailScreen',
                      arguments: {
                        'imageUrls': imageUrls,
                        'prevSelectedIndex': index
                      }
                    ) as int;

                    pageController.animateToPage(result, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                  },
                  child: Hero(
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
                  ),
                );
              }
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: SmoothPageIndicator(
                  controller: pageController,
                  count: imageUrls.length,
                  effect: const WormEffect(
                      activeDotColor: AppColors.color_FFFFFFFF,
                      dotColor: AppColors.color_FFC7C7CB,
                      radius: 100,
                      dotHeight: 8,
                      dotWidth: 8,
                      spacing: 10
                  ),
                  onDotClicked: (index) {}),
            ),
          )
        ],
      ),
    );
  }
}