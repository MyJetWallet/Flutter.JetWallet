import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_ui_kit/flutter_ui_kit.dart';
import 'package:flutter_ui_kit/widgets/navigation/carousel/carousel_widget.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/features/my_wallets/store/banners_store.dart';
import 'package:jetwallet/utils/event_bus_events.dart';
import 'package:simple_networking/modules/signal_r/models/baner_model.dart';

class BannerCarusel extends StatefulWidget {
  const BannerCarusel({super.key});

  @override
  State<BannerCarusel> createState() => _BannerCaruselState();
}

class _BannerCaruselState extends State<BannerCarusel> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final store = BannersStore.of(context);
    return Observer(
      builder: (context) {
        return store.marketingBanners.isEmpty
            ? const Offstage()
            : Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: (MediaQuery.of(context).size.width - 48) * 0.281346,
                    child: TabBarView(
                      controller: store.controller,
                      children: [
                        for (final baner in store.marketingBanners)
                          SPromoBanner(
                            onBannerTap: () {
                              getIt.get<EventBus>().fire(EndReordering());
                              store.onBannerTap(baner);
                            },
                            onCloseBannerTap: () {
                              store.onCloseBannerTap(baner);
                            },
                            title: baner.title ?? '',
                            description: baner.description ?? '',
                            promoImage: CachedNetworkImageProvider(
                              baner.image ?? '',
                            ),
                            textWidthPercent: baner.align,
                            hasCloseButton: baner.type == BanerType.closable,
                          ),
                      ],
                    ),
                  ),
                  if (store.marketingBanners.length > 1)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 14,
                      ),
                      child: CarouselWidget(
                        itemsCount: store.marketingBanners.length,
                        pageIndex: store.selectedIndex,
                      ),
                    )
                  else
                    const SizedBox(height: 20),
                ],
              );
      },
    );
  }
}
