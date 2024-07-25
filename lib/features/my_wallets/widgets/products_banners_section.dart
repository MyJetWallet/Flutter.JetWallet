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
                    height: 120,
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
                                title: banner.title ?? '',
                                onTap: () {
                                  getIt.get<EventBus>().fire(EndReordering());
                                  store.onBannerTap(banner);
                                },
                                icon: banner.image != null
                                    ? Image.network(
                                        banner.image ?? '',
                                        fit: BoxFit.cover,
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
    required this.title,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final Widget icon;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();
    return SafeGesture(
      onTap: onTap,
      child: Container(
        width: 140,
        height: 120,
        padding: const EdgeInsets.all(16),
        decoration: ShapeDecoration(
          color: colors.extraLightsPurple,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: icon,
            ),
            const SizedBox(height: 9),
            Text(
              title,
              style: STStyles.body1Semibold,
            ),
          ],
        ),
      ),
    );
  }
}
