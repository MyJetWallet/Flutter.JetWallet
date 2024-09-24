import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/crypto_jar/store/jars_store.dart';
import 'package:jetwallet/features/crypto_jar/ui/widgets/create_jar_button_widget.dart';
import 'package:jetwallet/features/crypto_jar/ui/widgets/jar_list_item_widget.dart';
import 'package:jetwallet/features/crypto_jar/ui/widgets/no_active_jars_placeholder_widget.dart';
import 'package:jetwallet/features/kyc/kyc_service.dart';
import 'package:jetwallet/utils/helpers/check_kyc_status.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart' as sk;
import 'package:simple_kit_updated/simple_kit_updated.dart';

enum _JarFilterButton { active, all }

@RoutePage(name: 'AllJarsRouter')
class AllJarsScreen extends StatefulWidget {
  const AllJarsScreen({super.key});

  @override
  State<AllJarsScreen> createState() => _AllJarsScreenState();
}

class _AllJarsScreenState extends State<AllJarsScreen> {
  _JarFilterButton selectedFilter = _JarFilterButton.active;

  @override
  void initState() {
    super.initState();

    if (getIt.get<JarsStore>().activeJar.isEmpty) {
      setState(() {
        selectedFilter = _JarFilterButton.all;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final kycState = getIt.get<KycService>();
    final kycBlocked = checkKycBlocked(
      kycState.depositStatus,
      kycState.tradeStatus,
      kycState.withdrawalStatus,
    );

    final isAddButtonDisabled = kycBlocked;

    return sk.SPageFrame(
      loaderText: '',
      color: sk.sKit.colors.white,
      header: GlobalBasicAppBar(
        title: intl.jar_jars,
        hasRightIcon: false,
      ),
      child: Observer(
        builder: (context) {
          final store = getIt.get<JarsStore>();

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 16.0,
                ),
                _buildFilterListWidget(),
                const SizedBox(
                  height: 16.0,
                ),
                if (selectedFilter == _JarFilterButton.active) ...[
                  if (store.activeJar.isNotEmpty) ...[
                    ListView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(bottom: 16.0),
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: store.activeJar.length,
                      itemBuilder: (context, index) => JarListItemWidget(
                        jar: store.activeJar[index],
                      ),
                    ),
                  ] else ...[
                    const NoActiveJarsPlaceholderWidget(),
                    CreateJarButtonWidget(
                      isAddButtonDisabled: isAddButtonDisabled,
                      scrollToTitle: null,
                    ),
                  ],
                ] else ...[
                  ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(bottom: 16.0),
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: store.allJar.length,
                    itemBuilder: (context, index) => JarListItemWidget(
                      jar: store.allJar[index],
                    ),
                  ),
                ],
                SizedBox(
                  height: MediaQuery.of(context).padding.bottom,
                ),
              ],
            ),
          );
        },
      ),
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
