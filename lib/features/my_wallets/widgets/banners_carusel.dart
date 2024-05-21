import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/services/deep_link_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_kit_updated/widgets/navigation/carousel/carousel_widget.dart';
import 'package:simple_networking/modules/signal_r/models/baner_model.dart';
import 'package:simple_networking/modules/wallet_api/models/banners/close_banner_request_model.dart';

class BannerCarusel extends StatefulWidget {
  const BannerCarusel({super.key});

  @override
  State<BannerCarusel> createState() => _BannerCaruselState();
}

class _BannerCaruselState extends State<BannerCarusel> with TickerProviderStateMixin {
  late final TabController controller;

  @override
  void initState() {
    controller = TabController(
      length: banners.length,
      vsync: this,
    );
    controller.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  var banners = [...sSignalRModules.banersListMessage.banners];

  @override
  Widget build(BuildContext context) {
    return banners.isEmpty
        ? const Offstage()
        : Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width * 0.281346,
                child: TabBarView(
                  controller: controller,
                  children: [
                    for (final baner in banners)
                      SPromoBanner(
                        onBannerTap: () {
                          sAnalytics.tapOnTheBanner(
                            bannerId: baner.bannerId,
                            bannerTitle: baner.title,
                          );
                          final action = baner.action;
                          if (action != null) {
                            getIt.get<DeepLinkService>().handle(Uri.parse(action));
                          }
                        },
                        onCloseBannerTap: () async {
                          sAnalytics.closeBanner(
                            bannerId: baner.bannerId,
                            bannerTitle: baner.title,
                          );
                          setState(() {
                            banners.removeWhere((element) => element.bannerId == baner.bannerId);
                          });

                          await sNetwork.getWalletModule().postCloseBanner(
                                CloseBannerRequestModel(
                                  bannerId: baner.bannerId,
                                ),
                              );
                        },
                        title: baner.title,
                        description: baner.description,
                        promoImage: CachedNetworkImageProvider(
                          baner.image ?? '',
                        ),
                        textWidthPercent: baner.align,
                        hasCloseButton: baner.type == BanerType.closable,
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
                child: CarouselWidget(
                  itemsCount: banners.length,
                  pageIndex: controller.index,
                ),
              ),
            ],
          );
  }
}
