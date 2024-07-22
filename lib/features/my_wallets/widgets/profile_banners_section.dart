import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/features/my_wallets/store/banners_store.dart';
import 'package:jetwallet/utils/event_bus_events.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

class ProfileBannersSection extends StatelessWidget {
  const ProfileBannersSection({super.key});

  @override
  Widget build(BuildContext context) {
    final store = BannersStore.of(context);
    return Observer(
      builder: (context) {
        final profileBanners = store.profileBanners;
        return CustomScrollView(
          shrinkWrap: true,
          primary: false,
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverList.separated(
                itemCount: profileBanners.length,
                itemBuilder: (context, index) {
                  final banner = profileBanners[index];

                  return ChipsSuggestionM(
                    title: banner.title != '' ? banner.title : null,
                    subtitle: banner.description != '' ? banner.description : null,
                    onTap: () {
                      getIt.get<EventBus>().fire(EndReordering());
                      store.onBannerTap(banner);
                    },
                    icon: banner.image != null
                        ? Image.network(
                            banner.image ?? '',
                            width: 48,
                            height: 48,
                            fit: BoxFit.cover,
                          )
                        : null,
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 12);
                },
              ),
            ),
            if (profileBanners.isNotEmpty)
              const SliverToBoxAdapter(
                child: SizedBox(height: 20),
              ),
          ],
        );
      },
    );
  }
}
