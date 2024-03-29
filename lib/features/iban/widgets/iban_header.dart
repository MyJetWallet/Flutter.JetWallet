import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/features/iban/store/iban_store.dart';
import 'package:share_plus/share_plus.dart';
import 'package:simple_kit/modules/bottom_navigation_bar/components/notification_box.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../core/di/di.dart';
import '../../../core/l10n/i10n.dart';
import '../../../core/router/app_router.dart';
import '../../../utils/helpers/check_kyc_status.dart';
import '../../kyc/kyc_service.dart';
import '../../kyc/models/kyc_verified_model.dart';

class IBanHeader extends StatefulObserverWidget {
  const IBanHeader({
    super.key,
    required this.isKyc,
    required this.isShareActive,
    this.textForShare,
  });

  final bool isKyc;
  final bool isShareActive;
  final String? textForShare;

  @override
  State<IBanHeader> createState() => _IBanHeaderState();
}

class _IBanHeaderState extends State<IBanHeader> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      initialIndex: getIt.get<IbanStore>().initTab,
      length: 2,
      vsync: this,
    );
    getIt.get<IbanStore>().setTabController(_tabController);

    _tabController.addListener(saveStateToStore);
  }

  @override
  void dispose() {
    _tabController.removeListener(saveStateToStore);
    super.dispose();
  }

  void saveStateToStore() {
    getIt.get<IbanStore>().setIsReceive(_tabController.index == 0);
  }

  bool canTapShare = true;

  final colors = sKit.colors;

  late bool showAlert;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;
    final kycState = getIt.get<KycService>();

    return Column(
      children: [
        const SpaceH54(),
        Row(
          children: [
            const SpaceW24(),
            Text(
              intl.bottom_bar_account,
              style: sTextH4Style,
            ),
            const Spacer(),
            SizedBox(
              width: 56.0,
              height: 56.0,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SIconButton(
                    defaultIcon: SShareIcon(
                      color: widget.isShareActive ? colors.black : colors.grey3,
                    ),
                    pressedIcon: SShareIcon(
                      color: widget.isShareActive ? colors.black.withOpacity(0.7) : colors.grey3,
                    ),
                    onTap: () {
                      if (widget.isShareActive && widget.textForShare != null && canTapShare) {
                        setState(() {
                          canTapShare = false;
                        });
                        Timer(
                          const Duration(
                            seconds: 1,
                          ),
                          () => setState(() {
                            canTapShare = true;
                          }),
                        );

                        try {
                          Share.share(
                            widget.textForShare!,
                          );
                        } catch (e) {
                          rethrow;
                        }
                      }
                    },
                  ),
                  const Positioned(
                    right: 0,
                    top: -5,
                    child: NotificationBox(
                      notifications: 0,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 56.0,
              height: 56.0,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SIconButton(
                    defaultIcon: SProfileDetailsIcon(
                      color: colors.black,
                    ),
                    pressedIcon: SProfileDetailsIcon(
                      color: colors.black.withOpacity(0.7),
                    ),
                    onTap: () {
                      sRouter.push(const AccountRouter());
                    },
                  ),
                  Positioned(
                    right: 0,
                    top: -5,
                    child: NotificationBox(
                      notifications: _profileNotificationLength(
                        KycModel(
                          depositStatus: kycState.depositStatus,
                          sellStatus: kycState.tradeStatus,
                          withdrawalStatus: kycState.withdrawalStatus,
                          requiredDocuments: kycState.requiredDocuments,
                          requiredVerifications: kycState.requiredVerifications,
                          verificationInProgress: kycState.verificationInProgress,
                        ),
                        true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SpaceW8(),
          ],
        ),
        if (getIt.get<IbanStore>().isIbanOutActive && widget.isKyc) ...[
          SPaddingH24(
            child: Container(
              height: 32,
              width: double.infinity,
              decoration: BoxDecoration(
                color: colors.grey5,
                borderRadius: BorderRadius.circular(16),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: colors.black,
                  borderRadius: BorderRadius.circular(16),
                ),
                labelColor: colors.white,
                labelStyle: sSubtitle3Style,
                unselectedLabelColor: colors.grey1,
                unselectedLabelStyle: sSubtitle3Style,
                splashBorderRadius: BorderRadius.circular(16),
                tabs: [
                  Tab(
                    text: intl.iban_tabbbar_receive,
                  ),
                  Tab(
                    text: intl.iban_tabbar_send,
                  ),
                ],
              ),
            ),
          ),
        ],
        const SpaceH12(),
      ],
    );
  }

  int _profileNotificationLength(KycModel kycState, bool twoFaEnable) {
    var notificationLength = 0;

    final passed = checkKycPassed(
      kycState.depositStatus,
      kycState.sellStatus,
      kycState.withdrawalStatus,
    );

    if (!passed) {
      notificationLength += 1;
    }

    if (!twoFaEnable) {
      notificationLength += 1;
    }

    return notificationLength;
  }
}
