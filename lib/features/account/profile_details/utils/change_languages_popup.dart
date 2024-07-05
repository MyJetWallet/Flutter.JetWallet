import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/local_storage_service.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/widgets/flag_item.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

class LangItem {
  LangItem(this.countryCode, this.langCode, this.label);

  String countryCode;
  String langCode;
  String label;
}

final availableLanguages = [
  LangItem('gb', 'en', 'English'),
  LangItem('es', 'es', 'Spanish'),
  LangItem('pl', 'pl', 'Polish'),
  LangItem('ua', 'uk', 'Ukrainian'),
  LangItem('fr', 'fr', 'French'),
];

Future<bool?> changeLanguagePopup(BuildContext context) async {
  sShowBasicModalBottomSheet(
    context: context,
    pinned: SBottomSheetHeader(
      name: intl.preferred_language,
    ),
    onDissmis: () {
      return true;
    },
    then: (p0) {
      return true;
    },
    children: [
      Observer(
        builder: (context) {
          return Column(
            children: availableLanguages
                .map(
                  (e) => SimpleTableAsset(
                    label: e.label,
                    assetIcon: FlagItem(
                      countryCode: e.countryCode,
                    ),
                    customRightWidget: getIt.get<AppStore>().locale == Locale.fromSubtags(languageCode: e.langCode)
                        ? Assets.svg.medium.checkmark.simpleSvg()
                        : const SizedBox.shrink(),
                    onTableAssetTap: () async {
                      getIt.get<AppStore>().setLocale(
                            Locale.fromSubtags(languageCode: e.langCode),
                          );
                      unawaited(
                        showNotification(
                          context,
                          intl.lang_change_alert,
                          false,
                          false,
                        ),
                      );

                      Navigator.pop(context);

                      final storage = sLocalStorageService;
                      await storage.setString(userLocale, e.langCode);
                    },
                  ),
                )
                .toList(),
          );
        },
      ),
      const SpaceH54(),
    ],
  );

  return null;
}
