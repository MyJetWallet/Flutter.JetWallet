import 'dart:io';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/prepaid_card/store/choose_country_and_plan_store.dart';
import 'package:jetwallet/features/prepaid_card/utils/show_choose_countre_bottom_shet.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/widgets/flag_item.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/wallet_api/models/prepaid_card/purchase_card_brand_list_response_model.dart';

class ChooseCountryAndPlanScreen extends StatelessWidget {
  const ChooseCountryAndPlanScreen();

  @override
  Widget build(BuildContext context) {
    final store = ChooseCountryAndPlanStore.of(context);
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: SPaddingH24(
            child: Text(
              intl.prepaid_card_choose_prepaid_card,
              style: STStyles.header5,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Observer(
            builder: (context) {
              return _ChoosedContry(
                selectedCountry: store.selectedCountry,
                selectNewCountry: () {
                  showChooseCountreBottomShet(
                    context: context,
                    countries: store.countries,
                    onSelected: ({required SPhoneNumber newCountry}) {
                      sRouter.maybePop();
                      store.setNewCountry(newCountry);
                    },
                  );
                },
              );
            },
          ),
        ),
        const SliverToBoxAdapter(
          child: SpaceH8(),
        ),
        Observer(
          builder: (context) {
            if (store.brandsList.isNotEmpty) {
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return Observer(
                      builder: (context) {
                        return _BranItem(
                          brand: store.brandsList[index],
                          selectedBrandId: store.selectedBrand?.productId ?? 0,
                          onRadioTap: () {
                            store.setSelectedBrand(store.brandsList[index]);
                          },
                        );
                      },
                    );
                  },
                  childCount: store.brandsList.length,
                ),
              );
            } else {
              return SliverToBoxAdapter(
                child: SPlaceholder(
                  size: SPlaceholderSize.l,
                  text: intl.prepaid_card_no_available_tariffs,
                  mood: SPlaceholderMood.sad,
                ),
              );
            }
          },
        ),
        const SliverToBoxAdapter(
          child: SafeArea(
            child: SpaceH120(),
          ),
        ),
      ],
    );
  }
}

class _ChoosedContry extends StatelessWidget {
  const _ChoosedContry({
    required this.selectedCountry,
    required this.selectNewCountry,
  });

  final SPhoneNumber selectedCountry;
  final void Function() selectNewCountry;

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();

    return InkWell(
      onTap: selectNewCountry,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  intl.prepaid_card_choose_residential_country,
                  style: STStyles.captionMedium.copyWith(
                    color: colors.gray8,
                  ),
                ),
                Row(
                  children: [
                    FlagItem(
                      countryCode: selectedCountry.isoCode,
                    ),
                    const SpaceW8(),
                    Flexible(
                      child: Text(
                        selectedCountry.countryName,
                        style: STStyles.subtitle1,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SDivider(),
        ],
      ),
    );
  }
}

class _BranItem extends StatelessWidget {
  const _BranItem({
    required this.brand,
    required this.selectedBrandId,
    required this.onRadioTap,
  });

  final PurchaseCardBrandDtoModel brand;
  final int selectedBrandId;
  final void Function() onRadioTap;

  String getBadgeText() {
    final isMobile = brand.isMobile;
    final isNotMobile = !brand.isMobile;
    final isIos = Platform.isIOS;
    final isAndroid = Platform.isAndroid;
    if (isMobile && isIos) {
      return intl.prepaid_card_apple_pay_available;
    }
    if (isNotMobile && isIos) {
      return intl.prepaid_card_apple_pay_unavailable;
    }
    if (isMobile && isAndroid) {
      return intl.prepaid_card_google_pay_available;
    }
    if (isNotMobile && isAndroid) {
      return intl.prepaid_card_google_pay_unavailable;
    }

    return '';
  }

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();

    return SCheckBoxItemWithTable<int>(
      title: brand.brandName,
      radioValue: brand.productId,
      radioGroupValue: selectedBrandId,
      onRadioTap: (_) {
        onRadioTap.call();
      },
      badge: SBadgeMedium(
        status: brand.isMobile ? SBadgeType.archived : SBadgeType.negative,
        text: getBadgeText(),
        customIcon: brand.isMobile
            ? Assets.svg.medium.mobile.simpleSvg(
                color: colors.black,
                width: 12,
                height: 12,
              )
            : Assets.svg.medium.mobileUnavailable.simpleSvg(
                color: colors.red,
                width: 12,
                height: 12,
              ),
      ),
      rows: [
        (
          lable: intl.prepaid_card_min_amount,
          value: (brand.valueRestrictions?.minVal ?? Decimal.zero).toFormatCount(
            symbol: brand.currency,
          ),
          customValueStyle: STStyles.body2Medium
        ),
        (
          lable: intl.prepaid_card_max_amount,
          value: (brand.valueRestrictions?.maxVal ?? Decimal.zero).toFormatCount(
            symbol: brand.currency,
          ),
          customValueStyle: STStyles.body2Medium
        ),
        (
          lable: intl.prepaid_card_commission,
          value:
              brand.feePercentage == Decimal.zero ? intl.prepaid_card_free : brand.feePercentage.toFormatPercentCount(),
          customValueStyle: STStyles.body2Medium.copyWith(
            color: brand.feePercentage == Decimal.zero ? SColorsLight().green : null,
          ),
        ),
      ],
    );
  }
}
