import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/remote_config/remote_config_values.dart';
import 'package:jetwallet/core/services/user_info/user_info_service.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/phone_verification/ui/phone_verification.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../store/change_base_asset_store.dart';

class DefaultAssetChange extends StatelessObserverWidget {
  const DefaultAssetChange({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final baseAsset = getIt.get<ChangeBaseAssetStore>();

    return SPageFrame(
      header: SPaddingH24(
        child: SSmallHeader(
          title: intl.profileDetails_defaultCurrency,
          onBackButtonTap: () => Navigator.pop(context),
        ),
      ),
      child: Column(
        children: [
          for (final asset in baseAsset.assetsList)
            SProfileDetailsButton(
              label: '',
              value: asset,
              onTap: () {
                baseAsset.setBaseAsset(asset);
              },
            ),
        ],
      ),
    );
  }
}
