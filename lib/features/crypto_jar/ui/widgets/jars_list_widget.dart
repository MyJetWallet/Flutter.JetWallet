import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/crypto_jar/store/jars_store.dart';
import 'package:jetwallet/features/crypto_jar/ui/widgets/jar_list_item_widget.dart';
import 'package:jetwallet/features/kyc/helper/kyc_alert_handler.dart';
import 'package:jetwallet/features/kyc/kyc_service.dart';
import 'package:jetwallet/features/kyc/models/kyc_operation_status_model.dart';
import 'package:jetwallet/features/my_wallets/helper/show_wallet_verify_account.dart';
import 'package:jetwallet/utils/event_bus_events.dart';
import 'package:jetwallet/utils/helpers/check_kyc_status.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/wallet_api/models/jar/jar_response_model.dart';

class JarsListWidget extends StatefulWidget {
  const JarsListWidget({
    required this.titleKey,
    required this.scrollToTitle,
    super.key,
  });

  final GlobalKey titleKey;
  final Function() scrollToTitle;

  @override
  State<JarsListWidget> createState() => _JarsListWidgetState();
}

class _JarsListWidgetState extends State<JarsListWidget> {
  _JarFilterButton selectedFilter = _JarFilterButton.active;

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
        STableHeader(
          key: widget.titleKey,
          size: SHeaderSize.m,
          title: intl.jar_jars,
        ),
        Observer(
          builder: (context) {
            final store = getIt.get<JarsStore>();
            final allJar = store.allJar;
            final activeJar = store.activeJar;

            List<JarResponseModel> jars;
            if (activeJar.isEmpty) {
              jars = allJar;
            } else {
              jars = selectedFilter == _JarFilterButton.all ? allJar : activeJar;
            }

            if (allJar.isNotEmpty) {
              return CustomScrollView(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                slivers: [
                  if (activeJar.isNotEmpty) ...[
                    const SliverToBoxAdapter(
                      child: SizedBox(
                        height: 24.0,
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: _buildFilterListWidget(),
                    ),
                    const SliverToBoxAdapter(
                      child: SizedBox(
                        height: 16.0,
                      ),
                    ),
                  ] else ...[
                    const SliverToBoxAdapter(
                      child: SizedBox(
                        height: 10.0,
                      ),
                    ),
                  ],
                  SliverList.builder(
                    itemCount: jars.length,
                    itemBuilder: (context, index) => JarListItemWidget(
                      jar: jars[index],
                    ),
                  ),
                ],
              );
            } else {
              return Column(
                children: [
                  const SizedBox(
                    height: 7.0,
                  ),
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
                ],
              );
            }
          },
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 16.0,
            bottom: 40.0,
            left: 24.0,
            right: 24.0,
          ),
          child: SButtonContext(
            type: SButtonContextType.iconedSmall,
            text: intl.jar_add_jar,
            isDisabled: isAddButtonDisabled,
            onTap: () {
              getIt.get<EventBus>().fire(EndReordering());

              getIt.get<JarsStore>().refreshJarsStore();

              sAnalytics.jarTapOnButtonAddCryptoJarOnDashboard();

              final kycState = getIt.get<KycService>();
              if (checkKycPassed(
                kycState.depositStatus,
                kycState.tradeStatus,
                kycState.withdrawalStatus,
              )) {
                widget.scrollToTitle();

                getIt<AppRouter>().push(EnterJarNameRouter());
              } else {
                final kycHandler = getIt.get<KycAlertHandler>();

                if (kycState.depositStatus == kycOperationStatus(KycStatus.kycInProgress)) {
                  kycHandler.handle(
                    status: kycState.depositStatus,
                    isProgress: kycState.verificationInProgress,
                    currentNavigate: () {},
                    requiredDocuments: kycState.requiredDocuments,
                    requiredVerifications: kycState.requiredVerifications,
                  );
                } else {
                  showWalletVerifyAccount(
                    context,
                    after: () {
                      getIt<AppRouter>().push(EnterJarNameRouter());
                    },
                    isBanking: false,
                  );
                }
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFilterListWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        children: [
          _buildFilterButtonWidget(_JarFilterButton.active, selectedFilter == _JarFilterButton.active),
          const SizedBox(
            width: 4.0,
          ),
          _buildFilterButtonWidget(_JarFilterButton.all, selectedFilter == _JarFilterButton.all),
        ],
      ),
    );
  }

  Widget _buildFilterButtonWidget(_JarFilterButton filter, [bool isSelected = false]) {
    return GestureDetector(
      onTap: () {
        getIt.get<EventBus>().fire(EndReordering());

        getIt.get<JarsStore>().refreshJarsStore();

        if (filter == _JarFilterButton.all) {
          sAnalytics.jarTapOnButtonAllJarsItemOnDashboard();
        } else {
          sAnalytics.jarTapOnButtonActiveJarsItemsOnDashboard();
        }

        setState(() {
          selectedFilter = filter;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 4.0,
          horizontal: 12.0,
        ),
        decoration: BoxDecoration(
          color: isSelected ? SColorsLight().black : SColorsLight().gray2,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          filter == _JarFilterButton.active ? intl.jar_active : intl.jar_all,
          style: STStyles.body2Bold.copyWith(
            color: isSelected ? SColorsLight().white : SColorsLight().black,
          ),
        ),
      ),
    );
  }
}

enum _JarFilterButton { active, all }