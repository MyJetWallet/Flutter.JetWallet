import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/utils/constants.dart';
import 'package:simple_kit/simple_kit.dart';

class CpowerBlock extends StatelessWidget {
  const CpowerBlock({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SpaceH32(),
        Text(
          intl.cpower_market_value_invetors,
          style: sTextH4Style.copyWith(
            fontFamily: 'Gilroy',
          ),
        ),
        const SpaceH19(),
        Text(
          intl.cpower_market_value_text_1,
          style: sBodyText1Style.copyWith(
            fontFamily: 'Gilroy',
          ),
          maxLines: 6,
        ),
        const SpaceH25(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '1.',
              style: sBodyText1Style.copyWith(
                fontFamily: 'Gilroy',
              ),
              maxLines: 6,
            ),
            const SpaceW6(),
            Flexible(
              child: Text(
                intl.cpower_market_value_text_2,
                style: sBodyText1Style.copyWith(
                  fontFamily: 'Gilroy',
                ),
                maxLines: 6,
              ),
            ),
          ],
        ),
        const SpaceH25(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '2.',
              style: sBodyText1Style.copyWith(
                fontFamily: 'Gilroy',
              ),
              maxLines: 6,
            ),
            const SpaceW6(),
            Flexible(
              child: Text(
                intl.cpower_market_value_text_3,
                style: sBodyText1Style.copyWith(
                  fontFamily: 'Gilroy',
                ),
                maxLines: 6,
              ),
            ),
          ],
        ),
        const SpaceH25(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '3.',
              style: sBodyText1Style.copyWith(
                fontFamily: 'Gilroy',
              ),
              maxLines: 6,
            ),
            const SpaceW6(),
            Flexible(
              child: Text(
                intl.cpower_market_value_text_4,
                style: sBodyText1Style.copyWith(
                  fontFamily: 'Gilroy',
                ),
                maxLines: 6,
              ),
            ),
          ],
        ),
        const SpaceH13(),
        SvgPicture.asset(
          cpowerBanner1Asset,
          width: MediaQuery.of(context).size.width - 48,
        ),
        const SpaceH32(),
        Text(
          intl.cpower_market_value_crypto,
          style: sTextH4Style.copyWith(
            fontFamily: 'Gilroy',
          ),
          maxLines: 2,
        ),
        const SpaceH32(),
        Text(
          intl.cpower_market_crypto_text_1,
          style: sBodyText1Style.copyWith(
            fontFamily: 'Gilroy',
          ),
          maxLines: 6,
        ),
        const SpaceH25(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '1.',
              style: sBodyText1Style.copyWith(
                fontFamily: 'Gilroy',
              ),
              maxLines: 6,
            ),
            const SpaceW6(),
            Flexible(
              child: Text(
                intl.cpower_market_crypto_text_2,
                style: sBodyText1Style.copyWith(
                  fontFamily: 'Gilroy',
                ),
                maxLines: 6,
              ),
            ),
          ],
        ),
        const SpaceH25(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '2.',
              style: sBodyText1Style.copyWith(
                fontFamily: 'Gilroy',
              ),
              maxLines: 6,
            ),
            const SpaceW6(),
            Flexible(
              child: Text(
                intl.cpower_market_crypto_text_3,
                style: sBodyText1Style.copyWith(
                  fontFamily: 'Gilroy',
                ),
                maxLines: 6,
              ),
            ),
          ],
        ),
        const SpaceH25(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '3.',
              style: sBodyText1Style.copyWith(
                fontFamily: 'Gilroy',
              ),
              maxLines: 6,
            ),
            const SpaceW6(),
            Flexible(
              child: Text(
                intl.cpower_market_crypto_text_4,
                style: sBodyText1Style.copyWith(
                  fontFamily: 'Gilroy',
                ),
                maxLines: 6,
              ),
            ),
          ],
        ),
        const SpaceH25(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '4.',
              style: sBodyText1Style.copyWith(
                fontFamily: 'Gilroy',
              ),
              maxLines: 6,
            ),
            const SpaceW6(),
            Flexible(
              child: Text(
                intl.cpower_market_crypto_text_5,
                style: sBodyText1Style.copyWith(
                  fontFamily: 'Gilroy',
                ),
                maxLines: 6,
              ),
            ),
          ],
        ),
        const SpaceH25(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '5.',
              style: sBodyText1Style.copyWith(
                fontFamily: 'Gilroy',
              ),
              maxLines: 6,
            ),
            const SpaceW6(),
            Flexible(
              child: Text(
                intl.cpower_market_crypto_text_6,
                style: sBodyText1Style.copyWith(
                  fontFamily: 'Gilroy',
                ),
                maxLines: 6,
              ),
            ),
          ],
        ),
        const SpaceH25(),
        Text(
          intl.cpower_market_crypto_text_7,
          style: sBodyText1Style.copyWith(
            fontFamily: 'Gilroy',
          ),
          maxLines: 6,
        ),
        const SpaceH13(),
        SvgPicture.asset(
          cpowerBanner2Asset,
          width: MediaQuery.of(context).size.width - 48,
        ),
        const SpaceH24(),
      ],
    );
  }
}
