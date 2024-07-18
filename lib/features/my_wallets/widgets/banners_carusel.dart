import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/features/my_wallets/store/banners_store.dart';
import 'package:jetwallet/utils/event_bus_events.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_kit_updated/widgets/navigation/carousel/carousel_widget.dart';
import 'package:simple_networking/modules/signal_r/models/baner_model.dart';

class BannerCarusel extends StatefulWidget {
  const BannerCarusel({super.key});

  @override
  State<BannerCarusel> createState() => _BannerCaruselState();
}

class _BannerCaruselState extends State<BannerCarusel> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => BannersStore(vsync: this),
      dispose: (context, store) => store.dispose(),
      builder: (context, child) {
        final store = BannersStore.of(context);

        return Observer(
          builder: (context) {
            return store.banners.isEmpty
                ? const Offstage()
                : Column(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: (MediaQuery.of(context).size.width - 48) * 0.281346,
                        child: TabBarView(
                          controller: store.controller,
                          children: [
                            for (final baner in store.banners)
                              SPromoBanner(
                                onBannerTap: () {
                                  getIt.get<EventBus>().fire(EndReordering());
                                  store.onBannerTap(baner);
                                },
                                onCloseBannerTap: () {
                                  store.onCloseBannerTap(baner);
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
                          itemsCount: store.banners.length,
                          pageIndex: store.selectedIndex,
                        ),
                      ),
                    ],
                  );
          },
        );
      },
    );
  }
}
