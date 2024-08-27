import 'package:auto_route/auto_route.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/crypto_jar/helpers/jar_extension.dart';
import 'package:jetwallet/features/crypto_jar/store/jars_store.dart';
import 'package:jetwallet/features/currency_withdraw/model/withdrawal_model.dart';
import 'package:jetwallet/features/transaction_history/widgets/transaction_list_item.dart';
import 'package:jetwallet/features/transaction_history/widgets/transactions_list.dart';
import 'package:jetwallet/utils/formatting/base/decimal_extension.dart';
import 'package:jetwallet/widgets/action_bottom_sheet_header.dart';
import 'package:simple_kit/modules/bottom_sheets/components/basic_bottom_sheet/show_basic_modal_bottom_sheet.dart';
import 'package:simple_kit/modules/colors/simple_colors.dart';
import 'package:simple_kit/modules/shared/simple_show_alert_popup.dart';
import 'package:simple_kit/simple_kit.dart' as sk;
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/wallet_api/models/jar/jar_response_model.dart';

@RoutePage(name: 'JarRouter')
class JarScreen extends StatefulWidget {
  const JarScreen({
    required this.jar,
    required this.hasLeftIcon,
    super.key,
  });

  final JarResponseModel jar;
  final bool hasLeftIcon;

  @override
  State<JarScreen> createState() => _JarScreenState();
}

class _JarScreenState extends State<JarScreen> {
  @override
  Widget build(BuildContext context) {
    final colors = sk.sKit.colors;

    return sk.SPageFrame(
      loaderText: '',
      color: colors.white,
      header: GlobalBasicAppBar(
        title: '',
        hasLeftIcon: widget.hasLeftIcon,
        hasRightIcon: !widget.hasLeftIcon,
        rightIcon: Assets.svg.medium.close.simpleSvg(),
        onRightIconTap: () {
          getIt<AppRouter>().popUntil((route) {
            return route.settings.name == HomeRouter.name;
          });
        },
      ),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Align(
              child: widget.jar.getIcon(height: 200.0, width: 200.0),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 24,
            ),
          ),
          SliverToBoxAdapter(
            child: sk.SPaddingH24(
              child: Text(
                intl.jar_crypto_jar,
                style: STStyles.body2Semibold.copyWith(
                  color: SColorsLight().gray10,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: sk.SPaddingH24(
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.jar.title,
                      style: STStyles.header5.copyWith(
                        color: SColorsLight().black,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 8.0,
                  ),
                  Text(
                    Decimal.parse(widget.jar.balance.toString()).toFormatCount(
                      accuracy: 2,
                      symbol: widget.jar.assetSymbol,
                    ),
                    style: STStyles.header5.copyWith(
                      color: SColorsLight().black,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: sk.SPaddingH24(
              child: Text(
                '${Decimal.parse(widget.jar.balance.toString()).toFormatCount(
                  accuracy: 2,
                  symbol: widget.jar.assetSymbol,
                )} / ${Decimal.parse(widget.jar.target.toString()).toFormatCount(
                  accuracy: 0,
                  symbol: widget.jar.assetSymbol,
                )}',
                style: STStyles.body1Medium.copyWith(
                  color: SColorsLight().gray10,
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 36.0,
            ),
          ),
          SliverToBoxAdapter(
            child: sk.SPaddingH24(
              child: _buildButtons(colors),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 44.0,
            ),
          ),
          SliverToBoxAdapter(
            child: sk.SPaddingH24(
              child: Text(
                intl.jar_transactions,
                style: STStyles.header5.copyWith(
                  color: SColorsLight().black,
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 12.0,
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              height: 32.0,
              width: double.infinity,
              margin: const EdgeInsets.symmetric(
                horizontal: 24.0,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 6.0,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: SColorsLight().gray2,
              ),
              child: Text(
                intl.jar_transactions_empty,
                style: STStyles.body2Medium.copyWith(
                  color: SColorsLight().gray10,
                ),
              ),
            ),
          ),
          TransactionsList(
            scrollController: ScrollController(),
            jarId: widget.jar.id,
            onItemTapLisener: (symbol) {},
            source: TransactionItemSource.history,
          ),
        ],
      ),
    );
  }

  Widget _buildButtons(SimpleColors colors) {
    if (widget.jar.status != JarStatus.closed) {
      return Row(
        children: [
          const Spacer(),
          _buildButton(
            intl.jar_share,
            Assets.svg.medium.share.simpleSvg(color: SColorsLight().white),
            SColorsLight().blueDark,
            () {
              if (widget.jar.description.isNotEmpty) {
                getIt<AppRouter>().push(
                  JarShareRouter(
                    jar: widget.jar,
                  ),
                );
              } else {
                getIt<AppRouter>().push(
                  EnterJarDescriptionRouter(
                    isOnlyEdit: false,
                    jar: widget.jar,
                  ),
                );
              }
            },
          ),
          const SizedBox(
            width: 8.0,
          ),
          _buildButton(
            intl.jar_withdraw,
            Assets.svg.medium.withdrawal.simpleSvg(color: SColorsLight().white),
            SColorsLight().black,
            () {
              if (widget.jar.balance > 0) {
                sRouter.push(
                  WithdrawRouter(
                    withdrawal: WithdrawalModel(
                      jar: widget.jar,
                    ),
                  ),
                );
              }
            },
            widget.jar.balance > 0,
          ),
          const SizedBox(
            width: 8.0,
          ),
          _buildButton(
            intl.jar_close,
            Assets.svg.medium.close.simpleSvg(color: SColorsLight().white),
            SColorsLight().black,
            () {
              sShowAlertPopup(
                sRouter.navigatorKey.currentContext!,
                image: Assets.svg.brand.small.infoBlue.simpleSvg(),
                primaryText: '',
                secondaryText: intl.jar_action_close_jar('"${widget.jar.title}"'),
                primaryButtonName: intl.jar_confirm,
                onPrimaryButtonTap: () {
                  getIt.get<JarsStore>().closeJar(widget.jar.id);
                  getIt<AppRouter>().push(
                    JarClosedConfirmationRouter(
                      name: widget.jar.title,
                    ),
                  );
                },
                secondaryButtonName: intl.jar_cancel,
                onSecondaryButtonTap: () {
                  Navigator.pop(context);
                },
              );
            },
          ),
          const SizedBox(
            width: 8.0,
          ),
          _buildButton(
            intl.jar_more,
            Assets.svg.medium.more.simpleSvg(color: SColorsLight().white),
            SColorsLight().black,
            () {
              sShowBasicModalBottomSheet(
                context: context,
                color: colors.white,
                pinned: ActionBottomSheetHeader(
                  name: intl.jar_actions,
                ),
                horizontalPinnedPadding: 0.0,
                removePinnedPadding: true,
                children: [
                  SafeGesture(
                    onTap: () {
                      getIt<AppRouter>().push(
                        EnterJarNameRouter(
                          isCreatingNewJar: false,
                          jar: widget.jar,
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24.0,
                        vertical: 16.0,
                      ),
                      child: Row(
                        children: [
                          Assets.svg.medium.jar.simpleSvg(
                            color: SColorsLight().blue,
                          ),
                          const SizedBox(width: 15.0),
                          Text(
                            intl.jar_change_jar_name,
                            style: STStyles.subtitle1.copyWith(
                              color: SColorsLight().black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SafeGesture(
                    onTap: () {
                      getIt<AppRouter>().push(
                        EnterJarGoalRouter(
                          name: widget.jar.title,
                          isCreatingNewJar: false,
                          jar: widget.jar,
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24.0,
                        vertical: 16.0,
                      ),
                      child: Row(
                        children: [
                          Assets.svg.medium.goal.simpleSvg(
                            color: SColorsLight().blue,
                          ),
                          const SizedBox(width: 15.0),
                          Text(
                            intl.jar_change_jar_goal,
                            style: STStyles.subtitle1.copyWith(
                              color: SColorsLight().black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SafeGesture(
                    onTap: () {
                      getIt<AppRouter>().push(
                        EnterJarDescriptionRouter(
                          jar: widget.jar,
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24.0,
                        vertical: 16.0,
                      ),
                      child: Row(
                        children: [
                          Assets.svg.medium.edit.simpleSvg(
                            color: SColorsLight().blue,
                          ),
                          const SizedBox(width: 15.0),
                          Text(
                            intl.jar_change_jar_description,
                            style: STStyles.subtitle1.copyWith(
                              color: SColorsLight().black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 58.0),
                ],
              );
            },
          ),
          const Spacer(),
        ],
      );
    } else {
      return Container(
        height: 36.0,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 6.0,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: SColorsLight().gray2,
        ),
        child: Row(
          children: [
            Assets.svg.medium.closeAlt.simpleSvg(
              height: 20.0,
              width: 20.0,
              color: SColorsLight().gray8,
            ),
            const Spacer(),
            Text(
              intl.jar_closed,
              style: STStyles.body1Bold.copyWith(
                color: SColorsLight().gray8,
              ),
            ),
            const Spacer(),
            const SizedBox(
              width: 20.0,
            ),
          ],
        ),
      );
    }
  }

  Widget _buildButton(String text, Widget icon, Color color, Function() onTap, [bool active = true]) {
    return SafeGesture(
      onTap: onTap,
      child: Opacity(
        opacity: active ? 1 : 0.2,
        child: SizedBox(
          height: 76.0,
          width: 76.0,
          child: Column(
            children: [
              Container(
                height: 48.0,
                width: 48.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color,
                ),
                child: Center(
                  child: icon,
                ),
              ),
              const SizedBox(
                height: 12.0,
              ),
              Text(
                text,
                style: STStyles.captionSemibold.copyWith(
                  color: SColorsLight().black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
