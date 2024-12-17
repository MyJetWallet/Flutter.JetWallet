import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_ui_kit/flutter_ui_kit.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/crypto_card/store/crypto_card_linked_assets_store.dart';
import 'package:jetwallet/features/crypto_card/utils/show_choose_linked_asset_bottom_sheet.dart';
import 'package:jetwallet/widgets/network_icon_widget.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';

@RoutePage(name: 'CryptoCardLinkedAssetsRoute')
class CryptoCardLinkedAssetsScreen extends StatefulWidget {
  const CryptoCardLinkedAssetsScreen({
    super.key,
  });

  @override
  State<CryptoCardLinkedAssetsScreen> createState() => _CryptoCardLinkedAssetsScreenState();
}

class _CryptoCardLinkedAssetsScreenState extends State<CryptoCardLinkedAssetsScreen> {
  @override
  void initState() {
    super.initState();
    sAnalytics.viewLinkedAssetsScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => CryptoCardlinkedAssetsStore()..init(),
      child: const _LinkedAssetsBody(),
    );
  }
}

class _LinkedAssetsBody extends StatelessWidget {
  const _LinkedAssetsBody();

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<CryptoCardlinkedAssetsStore>(context);

    return Observer(
      builder: (context) {
        return SPageFrame(
          loaderText: intl.loader_please_wait,
          loading: store.loader,
          header: GlobalBasicAppBar(
            title: intl.crypto_card_linked_assets,
            hasRightIcon: false,
          ),
          child: Column(
            children: [
              const SpaceH7(),
              if (store.avaibleAssets.isNotEmpty)
                SuggestionButton(
                  title: store.selectedAsset.description,
                  subTitle: intl.crypto_card_linked_asset,
                  trailing: getIt<AppStore>().isBalanceHide
                      ? '**** ${store.selectedAsset.symbol}'
                      : store.selectedAsset.volumeAssetBalance,
                  icon: NetworkIconWidget(
                    store.selectedAsset.iconUrl,
                  ),
                  onTap: () {
                    showChooseLinkedAssetBottomSheet(
                      context: context,
                      store: store,
                    );
                  },
                )
              else
                SSkeletonLoader(
                  width: MediaQuery.of(context).size.width - 48,
                  height: 56,
                  borderRadius: BorderRadius.circular(12),
                ),
            ],
          ),
        );
      },
    );
  }
}
