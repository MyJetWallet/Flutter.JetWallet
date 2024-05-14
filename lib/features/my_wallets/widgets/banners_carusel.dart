import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/services/deep_link_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_kit_updated/widgets/navigation/carousel/carousel_widget.dart';

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
      length: 2,
      vsync: this,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final banners = sSignalRModules.banersListMessage?.list ?? [];
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 92,
          child: TabBarView(
            controller: controller,
            children: [
              for (final baner in banners)
                SPromoBanner(
                  onBannerTap: () {
                    getIt.get<DeepLinkService>().handle(Uri.parse(baner.action));
                  },
                  onCloseBannerTap: () {},
                  title: baner.title,
                  description: baner.description,
                  promoImage: CachedNetworkImageProvider(
                    baner.image,
                  ),
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
