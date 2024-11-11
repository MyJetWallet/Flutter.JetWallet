import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/features/crypto_jar/store/jars_banner_store.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

class JarsBannerWidget extends StatelessWidget {
  const JarsBannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final store = JarsBannerStore()..init();

    return Provider(
      create: (context) => store,
      child: Observer(
        builder: (context) => AnimatedSize(
          duration: const Duration(milliseconds: 300),
          child: store.showBanner
              ? Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 24.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    color: SColorsLight().gray2,
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 8.0,
                        right: 8.0,
                        child: InkWell(
                          onTap: () {
                            store.closeBanner();
                          },
                          child: Assets.svg.medium.closeAlt.simpleSvg(),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Simple Crypto Jars makes receiving cryptocurrency a breeze.',
                              style: STStyles.body1Medium,
                              overflow: TextOverflow.visible,
                              softWrap: true,
                            ),
                            const SizedBox(
                              height: 12.0,
                            ),
                            SHyperlink(
                              text: 'Learn more',
                              onTap: () {
                                store.openLanding(context);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox(),
        ),
      ),
    );
  }
}
