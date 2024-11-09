import 'package:auto_route/auto_route.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/prepaid_card/store/prepaid_card_details_store.dart';
import 'package:jetwallet/features/prepaid_card/utils/show_commision_explanation_bottom_sheet.dart';
import 'package:jetwallet/features/prepaid_card/utils/show_country_explanation_bottom_sheet.dart';
import 'package:jetwallet/features/transaction_history/widgets/history_copy_icon.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/utils/helpers/launch_url.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/wallet_api/models/prepaid_card/buy_prepaid_card_intention_dto_list_response_model.dart';
import 'package:simple_networking/modules/wallet_api/models/prepaid_card/get_purchase_card_list_request_model.dart';
import 'package:url_launcher/url_launcher.dart';

@RoutePage(name: 'PrepaidCardDetailsRouter')
class PrepaidCardDetailsScreen extends StatelessWidget {
  const PrepaidCardDetailsScreen({super.key, this.voucher, this.orderId});

  final PrapaidCardVoucherModel? voucher;
  final String? orderId;

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => PrepaidCardDetailsStore(
        voucher: voucher,
        orderId: orderId,
      ),
      lazy: false,
      dispose: (context, store) {
        store.dispose();
      },
      child: const _PrepaidCardDetailsBody(),
    );
  }
}

class _PrepaidCardDetailsBody extends StatelessWidget {
  const _PrepaidCardDetailsBody();

  @override
  Widget build(BuildContext context) {
    final store = PrepaidCardDetailsStore.of(context);

    final colors = SColorsLight();
    return SPageFrame(
      loaderText: '',
      header: GlobalBasicAppBar(
        title: '',
        hasLeftIcon: false,
        onRightIconTap: () {
          sRouter.maybePop();
        },
      ),
      child: Stack(
        children: [
          Observer(
            builder: (context) {
              return CustomScrollView(
                slivers: [
                  const SliverToBoxAdapter(
                    child: _TopPartWidget(),
                  ),
                  if (store.voucher?.status != BuyPrepaidCardIntentionStatus.purchasing)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 24,
                          right: 24,
                          bottom: 24,
                        ),
                        child: SBadge(
                          type: SBadgeType.neutral,
                          lable: intl.transactionDetailsStatus_balanceInProcess,
                          icon: Padding(
                            padding: const EdgeInsets.only(left: 2),
                            child: SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                color: colors.blue,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  else
                    SliverToBoxAdapter(
                      child: _VoucherCodeField(
                        code: store.voucher?.voucherCode ?? '•••••••',
                      ),
                    ),
                  const SliverToBoxAdapter(
                    child: SPaddingH24(child: SDivider()),
                  ),
                  SliverToBoxAdapter(
                    child: _InfoGrid(
                      voucher: store.voucher,
                      isLoading: store.isLoading,
                    ),
                  ),
                  const SliverToBoxAdapter(
                    child: SPaddingH24(child: SDivider()),
                  ),
                  if (store.voucher?.status == BuyPrepaidCardIntentionStatus.purchasing)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 24,
                        ),
                        child: Text(
                          intl.prepaid_card_the_issuance,
                          style: STStyles.captionMedium.copyWith(
                            color: colors.gray8,
                          ),
                          maxLines: 4,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.only(
                left: 24,
                right: 24,
                bottom: MediaQuery.of(context).padding.bottom + 16,
              ),
              child: Observer(
                builder: (context) {
                  return SButton.black(
                    text: intl.prepaid_card_issue_card,
                    callback: store.voucher?.status != BuyPrepaidCardIntentionStatus.purchasing
                        ? () {
                            launchURL(
                              context,
                              store.voucher?.voucherUrl ?? '',
                              launchMode: LaunchMode.externalApplication,
                            );
                          }
                        : null,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TopPartWidget extends StatelessWidget {
  const _TopPartWidget();

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();
    return SPaddingH24(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            intl.prepaid_card_prepaid_card_activation,
            style: STStyles.header5,
            maxLines: 3,
          ),
          const SpaceH16(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ' 1.  ',
                style: STStyles.body1Medium.copyWith(
                  color: colors.gray10,
                ),
              ),
              Flexible(
                child: Text(
                  intl.prepaid_card_activation_1,
                  style: STStyles.body1Medium.copyWith(
                    color: colors.gray10,
                  ),
                  maxLines: 4,
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ' 2.  ',
                style: STStyles.body1Medium.copyWith(
                  color: colors.gray10,
                ),
              ),
              Flexible(
                child: Text(
                  intl.prepaid_card_activation_2,
                  style: STStyles.body1Medium.copyWith(
                    color: colors.gray10,
                  ),
                  maxLines: 4,
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ' 3.  ',
                style: STStyles.body1Medium.copyWith(
                  color: colors.gray10,
                ),
              ),
              Flexible(
                child: Text(
                  intl.prepaid_card_activation_3,
                  style: STStyles.body1Medium.copyWith(
                    color: colors.gray10,
                  ),
                  maxLines: 4,
                ),
              ),
            ],
          ),
          const SpaceH16(),
        ],
      ),
    );
  }
}

class _VoucherCodeField extends StatelessWidget {
  const _VoucherCodeField({required this.code});

  final String code;

  @override
  Widget build(BuildContext context) {
    return SCopyable(
      lable: intl.prepaid_card_security_code,
      value: code,
      onIconTap: () {
        Clipboard.setData(
          ClipboardData(
            text: code,
          ),
        );

        sNotification.showError(
          intl.copy_message,
          id: 1,
          isError: false,
        );
      },
    );
  }
}

class _InfoGrid extends StatelessWidget {
  const _InfoGrid({
    required this.voucher,
    this.isLoading = false,
  });

  final PrapaidCardVoucherModel? voucher;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final status = isLoading ? TwoColumnCellType.loading : TwoColumnCellType.def;

    return Column(
      children: [
        const SizedBox(height: 19),
        TwoColumnCell(
          label: intl.prepaid_card_card_type,
          value: voucher?.productName,
          leftValueIcon: (voucher?.productName ?? '').contains('Mastercard')
              ? Assets.svg.other.medium.mastercard.simpleSvg(
                  width: 20,
                  height: 20,
                )
              : Assets.svg.other.medium.visa.simpleSvg(
                  width: 20,
                  height: 20,
                ),
          type: status,
          valueMaxLines: 3,
        ),
        TwoColumnCell(
          label: intl.prepaid_card_card_balance,
          value: getIt<AppStore>().isBalanceHide
              ? '**** ${voucher?.cardAsset ?? ''}'
              : (voucher?.cardAmount ?? Decimal.zero).toFormatSum(
                  symbol: voucher?.cardAsset ?? '',
                  accuracy: 2,
                ),
          type: status,
        ),
        if (voucher?.status != BuyPrepaidCardIntentionStatus.purchasing)
          TwoColumnCell(
            label: intl.prepaid_card_order_id,
            value: shortTxhashFrom(voucher?.orderId ?? ''),
            type: status,
            rightValueIcon: HistoryCopyIcon(voucher?.orderId ?? ''),
          ),
        TwoColumnCell(
          label: intl.prepaid_card_country,
          value: voucher?.productCountry,
          haveInfoIcon: true,
          type: status,
          onTab: () {
            showCountryExplanationBottomSheet(context);
          },
        ),
        TwoColumnCell(
          label: intl.prepaid_card_commission,
          value: getIt<AppStore>().isBalanceHide
              ? '**** ${voucher?.feeAsset ?? ''}'
              : (voucher?.feeAmount ?? Decimal.zero) == Decimal.zero
                  ? intl.prepaid_card_free
                  : (voucher?.feeAmount ?? Decimal.zero).toFormatSum(
                      symbol: voucher?.feeAsset ?? '',
                      accuracy: 2,
                    ),
          haveInfoIcon: true,
          type: status,
          onTab: () {
            showCommisionExplanationBottomSheet(context);
          },
          customValueStyle: STStyles.subtitle2.copyWith(
            color: ((voucher?.feeAmount ?? Decimal.zero) == Decimal.zero && !getIt<AppStore>().isBalanceHide)
                ? SColorsLight().green
                : null,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
