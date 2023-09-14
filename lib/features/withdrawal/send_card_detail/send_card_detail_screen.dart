import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/remote_config/remote_config_values.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/withdrawal/send_card_detail/store/send_card_detail_store.dart';
import 'package:jetwallet/features/withdrawal/send_card_detail/widgets/payment_method_input.dart';
import 'package:jetwallet/utils/helpers/launch_url.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/global_send_methods_model.dart';

@RoutePage(name: 'SendCardDetailRouter')
class SendCardDetailScreen extends StatelessWidget {
  const SendCardDetailScreen({
    super.key,
    required this.method,
    required this.countryCode,
    required this.currency,
  });

  final GlobalSendMethodsModelMethods method;
  final String countryCode;
  final CurrencyModel currency;

  @override
  Widget build(BuildContext context) {
    return Provider<SendCardDetailStore>(
      create: (context) =>
          SendCardDetailStore()..init(method, countryCode, currency.symbol),
      builder: (context, child) => SendCardDetailScreenBody(
        countryCode: countryCode,
        currency: currency,
        method: method,
      ),
    );
  }
}

class SendCardDetailScreenBody extends StatefulObserverWidget {
  const SendCardDetailScreenBody({
    super.key,
    required this.method,
    required this.countryCode,
    required this.currency,
  });

  final GlobalSendMethodsModelMethods method;
  final String countryCode;
  final CurrencyModel currency;

  @override
  State<SendCardDetailScreenBody> createState() =>
      _SendCardDetailScreenBodyState();
}

class _SendCardDetailScreenBodyState extends State<SendCardDetailScreenBody> {
  TextEditingController cardNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    final store = SendCardDetailStore.of(context);

    return SPageFrame(
      loaderText: intl.loader_please_wait,
      color: colors.grey5,
      header: SPaddingH24(
        child: SSmallHeader(
          title: intl.global_send_title,
          subTitle: widget.method.name,
          subTitleStyle: sBodyText2Style.copyWith(
            color: colors.grey1,
          ),
          onBackButtonTap: () => Navigator.pop(context),
        ),
      ),
      child: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return PaymentMethodInput.getInput(
                  store.methodList[index],
                );
              },
              childCount: store.methodList.length,
            ),
          ),

          //1. I confirm that information above is accurate and complete.
          //2. I agree with T&C Send Globally program.
          //3. I understand that this money transfer is processed via P2P
          //   network more. P2P transfers are orchestrated by Payport LLC.
          //   More details.
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              children: [
                SPaddingH24(
                  child: SPolicyCheckbox(
                    height: 174,
                    isSendGlobal: true,
                    firstText: intl.send_globally_cond_text_1,
                    firstAdditionalText: intl.send_globally_cond_text_add_1,
                    userAgreementText: ' ${intl.send_globally_cond_text_2}',
                    betweenText: '',
                    privacyPolicyText: '',
                    secondText: '.\n',
                    activeText: '',
                    thirdText: intl.send_globally_cond_text_6,
                    activeText2: '${intl.send_globally_cond_text_7}.',
                    isChecked: getIt<AppStore>().isAcceptedGlobalSendTC,
                    onCheckboxTap: () {
                      sAnalytics.globalSendTCCheckbox(
                        asset: store.currency,
                        sendMethodType: '1',
                        destCountry: store.countryCode,
                        paymentMethod: store.method?.name ?? '',
                      );

                      getIt<AppStore>().setIsAcceptedGlobalSendTC(
                        !getIt<AppStore>().isAcceptedGlobalSendTC,
                      );
                    },
                    onUserAgreementTap: () {
                      launchURL(context, p2pTerms);
                    },
                    onPrivacyPolicyTap: () {
                      launchURL(
                        context,
                        'https://globalltd.xyz/terms-and-conditions',
                      );
                    },
                    onActiveTextTap: () {
                      launchURL(
                        context,
                        'https://globalltd.xyz/privacy-policy',
                      );
                    },
                    onActiveText2Tap: () {
                      sAnalytics.globalSendMoreDetailsButton(
                        asset: store.currency,
                        sendMethodType: '1',
                        destCountry: store.countryCode,
                        paymentMethod: store.method?.name ?? '',
                      );

                      sAnalytics.globalSendMoreDetailsPopup(
                        asset: store.currency,
                        sendMethodType: '1',
                        destCountry: store.countryCode,
                        paymentMethod: store.method?.name ?? '',
                      );

                      sShowAlertPopup(
                        context,
                        primaryText: '',
                        secondaryText: intl.global_send_popup_details,
                        primaryButtonName: intl.global_send_got_it,
                        image: Image.asset(
                          infoLightAsset,
                          height: 80,
                          width: 80,
                          package: 'simple_kit',
                        ),
                        primaryButtonType: SButtonType.primary1,
                        onPrimaryButtonTap: () {
                          sAnalytics.globalSendGotItButton(
                            asset: store.currency,
                            sendMethodType: '1',
                            destCountry: store.countryCode,
                            paymentMethod: store.method?.name ?? '',
                          );

                          Navigator.pop(context);
                        },
                        isNeedCancelButton: false,
                        cancelText: intl.profileDetails_cancel,
                        onCancelButtonTap: () => {Navigator.pop(context)},
                      );
                    },
                  ),
                ),
                const SpaceH40(),
                SPaddingH24(
                  child: Material(
                    color: colors.grey5,
                    child: SPrimaryButton2(
                      active: store.isContinueAvailable &&
                          getIt<AppStore>().isAcceptedGlobalSendTC,
                      name: intl.addCircleCard_continue,
                      onTap: () {
                        sAnalytics.globalSendContinueReceiveDetail(
                          asset: store.currency,
                          sendMethodType: '1',
                          destCountry: store.countryCode,
                          paymentMethod: store.method?.name ?? '',
                          globalSendType: store.method?.methodId ?? '',
                        );

                        store.submit();
                      },
                    ),
                  ),
                ),
                const SpaceH42(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
