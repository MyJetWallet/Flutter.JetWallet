import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/earn/store/earn_store.dart';
import 'package:jetwallet/features/earn/widgets/deposit_card.dart';
import 'package:jetwallet/features/earn/widgets/earn_archives_skeleton_list.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/shared/page_frames/simple_page_frame.dart';
import 'package:simple_kit/utils/constants.dart';
import 'package:simple_kit_updated/widgets/navigation/top_app_bar/global_basic_appbar.dart';
import 'package:simple_kit_updated/widgets/table/placeholder/simple_placeholder.dart';

@RoutePage(name: 'EarnsArchiveRouter')
class EarnsArchiveScreen extends StatefulWidget {
  const EarnsArchiveScreen({
    super.key,
  });

  @override
  State<EarnsArchiveScreen> createState() => _EarnsArchiveScreenState();
}

class _EarnsArchiveScreenState extends State<EarnsArchiveScreen> {
  final scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Provider<EarnStore>(
      create: (context) => EarnStore(),
      child: Observer(
        builder: (context) {
          final store = Provider.of<EarnStore>(context);
          final colors = sKit.colors;

          scrollController.addListener(() {
            if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
              store.loadMoreClosedPositions();
            }
          });
          return SPageFrame(
            loaderText: '',
            color: colors.white,
            header: GlobalBasicAppBar(
              title: intl.earn_earns_archive,
              hasRightIcon: false,
            ),
            child: store.isLoadingInitialData
                ? const EarnArchivesSceletonList()
                : CustomScrollView(
                    controller: scrollController,
                    slivers: [
                      if (store.earnPositionsClosed.isEmpty)
                        SliverFillRemaining(
                          child: SPlaceholder(
                            size: SPlaceholderSize.l,
                            text: intl.wallet_simple_account_empty,
                          ),
                        ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            return SDepositCard(
                              earnPosition: store.earnPositionsClosed[index],
                              onTap: () {
                                sRouter.push(
                                  EarnPositionActiveRouter(earnPosition: store.earnPositionsClosed[index]),
                                );
                              },
                              isShowDate: true,
                            );
                          },
                          childCount: store.earnPositionsClosed.length,
                        ),
                      ),
                      if (store.isLoadingPagination)
                        SliverToBoxAdapter(
                          child: Container(
                            width: 24.0,
                            height: 24.0,
                            decoration: BoxDecoration(
                              color: colors.grey5,
                              shape: BoxShape.circle,
                            ),
                            child: const RiveAnimation.asset(
                              loadingAnimationAsset,
                            ),
                          ),
                        ),
                      SliverToBoxAdapter(
                        child: SizedBox(
                          height: MediaQuery.paddingOf(context).bottom,
                        ),
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }
}
