import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
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

                  return ProfileBannerWidget(
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

class ProfileBannerWidget extends HookWidget {
  const ProfileBannerWidget({
    this.title,
    this.subtitle,
    this.value,
    required this.onTap,
    this.icon,
    super.key,
  });
  final String? title;
  final String? subtitle;
  final String? value;
  final void Function()? onTap;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();
    final isHighlated = useState(false);

    return SafeGesture(
      onTap: onTap,
      highlightColor: colors.gray2,
      onHighlightChanged: (p0) {
        isHighlated.value = p0;
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isHighlated.value ? colors.gray4 : Colors.transparent,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: colors.gray4),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              if (icon != null) ...[
                icon ?? const SizedBox(),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (title != null)
                      Text(
                        title ?? '',
                        style: STStyles.subtitle2,
                      ),
                    if (subtitle != null)
                      Text(
                        subtitle ?? '',
                        style: STStyles.body2Medium.copyWith(
                          color: colors.gray10,
                        ),
                      ),
                  ],
                ),
              ),
              if (value != null) ...[
                Text(
                  value ?? '',
                  style: STStyles.body2Semibold.copyWith(
                    color: colors.gray10,
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Assets.svg.medium.shevronRight.simpleSvg(
                width: 20,
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
