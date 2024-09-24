import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/crypto_jar/store/jars_store.dart';
import 'package:jetwallet/features/crypto_jar/ui/widgets/create_jar_button_widget.dart';
import 'package:jetwallet/features/crypto_jar/ui/widgets/jar_list_item_widget.dart';
import 'package:jetwallet/features/crypto_jar/ui/widgets/no_active_jars_placeholder_widget.dart';
import 'package:jetwallet/features/earn/widgets/basic_header.dart';
import 'package:jetwallet/features/kyc/kyc_service.dart';
import 'package:jetwallet/utils/event_bus_events.dart';
import 'package:jetwallet/utils/helpers/check_kyc_status.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

class JarsListWidget extends StatelessWidget {
  const JarsListWidget({
    required this.titleKey,
    required this.scrollToTitle,
    super.key,
  });

  final GlobalKey titleKey;
  final Function() scrollToTitle;

  @override
  Widget build(BuildContext context) {
    final kycState = getIt.get<KycService>();
    final kycBlocked = checkKycBlocked(
      kycState.depositStatus,
      kycState.tradeStatus,
      kycState.withdrawalStatus,
    );

    final isAddButtonDisabled = kycBlocked;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Observer(
          builder: (context) {
            final store = getIt.get<JarsStore>();

            if (store.shownJars.isNotEmpty) {
              return CustomScrollView(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                slivers: [
                  SliverToBoxAdapter(
                    child: _buildJarsHeader(store),
                  ),
                  const SliverToBoxAdapter(
                    child: SizedBox(
                      height: 10.0,
                    ),
                  ),
                  SliverList.builder(
                    itemCount: store.shownJars.length,
                    itemBuilder: (context, index) => JarListItemWidget(
                      jar: store.shownJars[index],
                    ),
                  ),
                ],
              );
            } else {
              return Column(
                children: [
                  _buildJarsHeader(store),
                  const SizedBox(
                    height: 7.0,
                  ),
                  if (store.allJar.isEmpty) ...[
                    Row(
                      children: [
                        const Spacer(),
                        SPlaceholder(
                          text: intl.jar_empty_list,
                          size: null,
                        ),
                        const Spacer(),
                      ],
                    ),
                  ] else ...[
                    const NoActiveJarsPlaceholderWidget(),
                  ],
                ],
              );
            }
          },
        ),
        CreateJarButtonWidget(
          isAddButtonDisabled: isAddButtonDisabled,
          scrollToTitle: scrollToTitle,
        ),
      ],
    );
  }

  Widget _buildJarsHeader(JarsStore store) {
    return SBasicHeader(
      key: titleKey,
      title: intl.jar_jars,
      buttonTitle: store.shownJars.isNotEmpty
          ? intl.jar_view_all
          : store.allJar.isNotEmpty
              ? intl.jar_view_closed_jars
              : '',
      showLinkButton: store.shownJars.isNotEmpty || store.allJar.isNotEmpty,
      onTap: () {
        getIt.get<EventBus>().fire(EndReordering());

        sAnalytics.jarTapOnButtonViewAllJarsOnDashboard();

        sRouter.push(
          const AllJarsRouter(),
        );
      },
    );
  }
}
