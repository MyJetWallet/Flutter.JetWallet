import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/nft/nft_receive/store/nft_receive_store.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/modules/headers/simple_small_header.dart';
import 'package:simple_kit/modules/shared/page_frames/simple_page_frame.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../core/services/device_size/device_size.dart';

class ReceiveNFTScreen extends StatelessWidget {
  const ReceiveNFTScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider<NftReceiveStore>(
      create: (context) => NftReceiveStore()..init(),
      builder: (context, child) => const _ReceiveNFTScreenBody(),
    );
  }
}

class _ReceiveNFTScreenBody extends StatelessObserverWidget {
  const _ReceiveNFTScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;
    final deviceSize = sDeviceSize;

    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final qrCodeSize = screenWidth * 0.6;
    var heightWidget = MediaQuery.of(context).size.height - 575;
    deviceSize.when(
      small: () => heightWidget = heightWidget - 75,
      medium: () => heightWidget = heightWidget - 135,
    );

    final store = NftReceiveStore.of(context);

    return SPageFrame(
      loaderText: intl.register_pleaseWait,
      header: SPaddingH24(
        child: SSmallHeader(
          title: intl.nft_receive_header,
          onBackButtonTap: () {
            Navigator.pop(context);
          },
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 104,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SDivider(),
              const SpaceH23(),
              SPaddingH24(
                child: SPrimaryButton2(
                  icon: SShareIcon(
                    color: colors.white,
                  ),
                  active: true,
                  name: intl.cryptoDeposit_share,
                  onTap: () {
                    if (store.canShare) {
                      store.setCanShare(false);

                      Timer(
                        const Duration(
                          seconds: 1,
                        ),
                        () => store.setCanShare(true),
                      );

                      try {
                        Share.share(
                          '${intl.nft_receive_share} '
                          '${store.address} '
                          '${store.tag != null ? ', ${intl.tag}: '
                              '${store.tag}' : ''}',
                        );
                      } catch (e) {
                        rethrow;
                      }
                    }
                  },
                ),
              ),
              const SpaceH24(),
            ],
          ),
        ),
      ),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SPaddingH24(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: colors.grey4,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  width: double.infinity,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SInfoIcon(
                        color: colors.red,
                      ),
                      const SpaceW12(),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.65,
                        child: Text(
                          intl.nft_receive_alert,
                          style: sBodyText1Style,
                          maxLines: 6,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SpaceH24(),
              SPaddingH24(
                child: Align(
                  child: SQrCodeBox(
                    loading: store.address.isEmpty,
                    data: store.address,
                    qrBoxSize: qrCodeSize,
                    logoSize: screenWidth * 0.2,
                  ),
                ),
              ),
              if (heightWidget > 0) ...[
                SizedBox(
                  height: heightWidget,
                ),
              ],
              /*
          Text(
            intl.nft_receive_network,
            style: sTextH5Style.copyWith(
              fontWeight: FontWeight.w500,
              color: colors.grey2,
              fontSize: 12,
            ),
          ),
          Text(
            intl.nft_receive_network,
            style: sSubtitle2Style,
          ),
          const SpaceH24(),
          const SDivider(),
          */

              SAddressFieldWithCopy(
                header: intl.nft_detail_nft_link,
                value: shortAddressForm(store.address),
                realValue: store.address,
                afterCopyText: intl.cryptoDepositWithAddress_addressCopied,
                valueLoading: store.address.isEmpty,
                needPadding: true,
                then: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
