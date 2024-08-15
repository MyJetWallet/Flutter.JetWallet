import 'package:auto_route/auto_route.dart';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/intercom/intercom_service.dart';
import 'package:jetwallet/core/services/remote_config/remote_config_values.dart';
import 'package:jetwallet/features/auth/user_data/ui/widgets/country/country_item/country_profile_item.dart';
import 'package:jetwallet/features/kyc/kyc_verify_your_profile/store/kyc_aid_countries_store.dart';
import 'package:jetwallet/widgets/empty_search_result.dart';
import 'package:jetwallet/widgets/flag_item.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/modules/buttons/basic_buttons/primary_button/public/simple_primary_button_4.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

@RoutePage(name: 'KycAidChooseCountryRouter')
class KycAidChooseCountryScreen extends StatefulWidget {
  const KycAidChooseCountryScreen({required this.initCountryCode});

  final String initCountryCode;

  @override
  State<KycAidChooseCountryScreen> createState() => __ChooseCountryState();
}

class __ChooseCountryState extends State<KycAidChooseCountryScreen> {
  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();

    return Provider(
      create: (context) => KycAidCountriesStore(),
      builder: (context, child) {
        final store = KycAidCountriesStore.of(context);
        return Observer(
          builder: (context) {
            return SPageFrame(
              loaderText: intl.loader_please_wait,
              loading: store.loader,
              color: colors.gray2,
              header: SimpleLargeAppbar(
                title: intl.kyc_identity_verification,
                hasRightIcon: true,
                rightIcon: SafeGesture(
                  onTap: () async {
                    if (showZendesk) {
                      await getIt.get<IntercomService>().showMessenger();
                    } else {
                      await sRouter.push(
                        CrispRouter(
                          welcomeText: intl.crispSendMessage_hi,
                        ),
                      );
                    }
                  },
                  child: Assets.svg.medium.chat.simpleSvg(),
                ),
              ),
              child: CustomScrollView(
                physics: const ClampingScrollPhysics(),
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Column(
                      children: [
                        const CountryProfileField(),
                        if (store.activeCountry?.isBlocked ?? false)
                          OneColumnCell(
                            color: colors.red,
                            icon: Assets.svg.small.warning,
                            text: intl.kyc_blocked_country,
                          ),
                        const Spacer(),
                        SPaddingH24(
                          child: SPrimaryButton4(
                            name: intl.register_continue,
                            onTap: () {
                              store.applyCountry();
                            },
                            active: store.activeCountry != null && !store.activeCountry!.isBlocked,
                          ),
                        ),
                        const SpaceH42(),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class CountryProfileField extends StatelessObserverWidget {
  const CountryProfileField();

  @override
  Widget build(BuildContext context) {
    final countryInfo = KycAidCountriesStore.of(context);
    final colors = sKit.colors;

    return ColoredBox(
      color: colors.white,
      child: GestureDetector(
        onTap: () {
          showUserDataCountryPicker(context);
        },
        child: AbsorbPointer(
          child: SPaddingH24(
            child: Stack(
              children: [
                if (countryInfo.activeCountry != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: Row(
                      children: [
                        FlagItem(
                          countryCode: countryInfo.activeCountry!.countryCode,
                        ),
                        const SpaceW10(),
                        Expanded(
                          child: Text(
                            countryInfo.activeCountry!.countryName,
                            style: sSubtitle2Style.copyWith(
                              color: colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                SStandardField(
                  hideClearButton: true,
                  readOnly: true,
                  controller: TextEditingController()..text = countryInfo.activeCountry != null ? ' ' : '',
                  labelText: intl.user_data_country,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> showUserDataCountryPicker(BuildContext context) async {
  final profileCountriesStore = KycAidCountriesStore.of(context);

  profileCountriesStore.initCountrySearch();

  sShowBasicModalBottomSheet(
    context: context,
    scrollable: true,
    pinned: _SearchPinned(
      store: profileCountriesStore as KycAidCountriesStore,
    ),
    expanded: true,
    removeBarPadding: true,
    removePinnedPadding: true,
    children: [
      _Countries(
        store: profileCountriesStore,
      ),
      const SpaceH40(),
    ],
  );
}

class _SearchPinned extends StatelessObserverWidget {
  const _SearchPinned({
    required this.store,
  });

  final KycAidCountriesStore store;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SpaceH20(),
        Text(
          intl.kycCountry_countryOfIssue,
          style: sTextH4Style,
        ),
        SStandardField(
          controller: TextEditingController(),
          autofocus: true,
          labelText: intl.showKycCountryPicker_search,
          onChanged: (value) {
            store.updateCountryNameSearch(value);
          },
          maxLines: 1,
        ),
        const SDivider(),
      ],
    );
  }
}

class _Countries extends StatelessObserverWidget {
  const _Countries({
    required this.store,
  });

  final KycAidCountriesStore store;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: store.sortedCountries.length,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final country = store.sortedCountries[index];
        if (store.sortedCountries.isEmpty) {
          EmptySearchResult(
            text: store.countryNameSearch,
          );
        }

        return CountryProfileItem(
          onTap: () {
            store.pickCountryFromSearch(country);
            sRouter.maybePop();
          },
          countryCode: country.countryCode,
          countryName: country.countryName,
          isBlocked: country.isBlocked,
        );
      },
    );
  }
}
