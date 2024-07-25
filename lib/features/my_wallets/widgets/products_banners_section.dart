import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/features/my_wallets/store/banners_store.dart';
import 'package:jetwallet/utils/event_bus_events.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

class ProductsBannersSection extends StatelessWidget {
  const ProductsBannersSection({super.key});

  @override
  Widget build(BuildContext context) {
    final store = BannersStore.of(context);
    return Observer(
      builder: (context) {
        final productBanners = store.productBanners;
        return productBanners.isNotEmpty
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 144,
                    child: CustomScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const AlwaysScrollableScrollPhysics(),
                      slivers: [
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          sliver: SliverList.separated(
                            itemCount: productBanners.length,
                            itemBuilder: (context, index) {
                              final banner = productBanners[index];

                              return ProductBannerWidget(
                                onTap: () {
                                  getIt.get<EventBus>().fire(EndReordering());
                                  store.onBannerTap(banner);
                                },
                                icon: banner.image != null
                                    ? CachedNetworkImage(
                                        imageUrl: banner.image ?? '',
                                        fadeInDuration: Duration.zero,
                                        fadeOutDuration: Duration.zero,
                                      )
                                    : const SizedBox(),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return const SizedBox(width: 8);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (productBanners.isNotEmpty) const SizedBox(height: 16),
                ],
              )
            : const Offstage();
      },
    );
  }
}

class ProductBannerWidget extends StatelessWidget {
  const ProductBannerWidget({
    super.key,
    required this.icon,
    required this.onTap,
  });

  final Widget icon;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();
    return SafeGesture(
      onTap: onTap,
      child: Container(
        width: 140,
        height: 144,
        decoration: ShapeDecoration(
          color: colors.extraLightsPurple,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: icon,
      ),
    );
  }
}
