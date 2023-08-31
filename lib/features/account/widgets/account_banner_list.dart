import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/services/local_storage_service.dart';
import 'package:jetwallet/features/account/widgets/create_banners_list.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class AccountBannerList extends StatefulObserverWidget {
  const AccountBannerList({
    super.key,
    this.onTwoFaBannerTap,
    this.onChatBannerTap,
    this.onKycBannerTap,
    required this.kycPassed,
    required this.kycBlocked,
    required this.twoFaEnabled,
    required this.phoneVerified,
    required this.verificationInProgress,
  });

  final Function()? onTwoFaBannerTap;
  final Function()? onChatBannerTap;
  final Function()? onKycBannerTap;
  final bool kycPassed;
  final bool kycBlocked;
  final bool twoFaEnabled;
  final bool phoneVerified;
  final bool verificationInProgress;

  @override
  State<AccountBannerList> createState() => _AccountBannerListState();
}

class _AccountBannerListState extends State<AccountBannerList> {
  @override
  Widget build(BuildContext context) {
    final controller = PageController(viewportFraction: 0.9);
    final colors = sKit.colors;

    return FutureBuilder(
      future: downloadData(colors, context),
      builder: (BuildContext context, AsyncSnapshot<List<Widget>> snapshot) {
        if ((snapshot.data?.length ?? 0) == 0) {
          return const SizedBox();
        }

        return Column(
          children: [
            SizedBox(
              height: _bannerHeight(),
              child: PageView.builder(
                controller: controller,
                itemCount: snapshot.data?.length,
                itemBuilder: (_, index) {
                  return Container(
                    margin: const EdgeInsets.only(
                      left: 4,
                      right: 4,
                    ),
                    child: snapshot.data?[index],
                  );
                },
              ),
            ),
            if ((snapshot.data?.length ?? 0) > 1)
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: SmoothPageIndicator(
                    controller: controller,
                    count: snapshot.data?.length ?? 0,
                    effect: ScrollingDotsEffect(
                      spacing: 2,
                      radius: 4,
                      dotWidth: 8,
                      dotHeight: 2,
                      maxVisibleDots: 11,
                      activeDotScale: 1,
                      dotColor: colors.black.withOpacity(0.1),
                      activeDotColor: colors.black,
                    ),
                  ),
                ),
              ),
            const SpaceH20(),
          ],
        );
      },
    );
  }

  double _bannerHeight() {
    return 56;
  }

  Future<List<Widget>> downloadData(
    SimpleColors colors,
    BuildContext context,
  ) async {
    final storage = sLocalStorageService;

    final showChatChecker = await storage.getValue(closedSupportBannerKey);
    final banners = createBannersList(
      kycPassed: widget.kycPassed,
      kycBlocked: widget.kycBlocked,
      verificationInProgress: widget.verificationInProgress,
      twoFaEnabled: true,
      phoneVerified: widget.phoneVerified,
      onChatBannerTap: widget.onChatBannerTap,
      onTwoFaBannerTap: widget.onTwoFaBannerTap,
      onKycBannerTap: widget.onKycBannerTap,
      colors: colors,
      showChatChecker: showChatChecker,
      context: context,
    );

    setState(() {});

    return Future.value(banners);
  }
}
