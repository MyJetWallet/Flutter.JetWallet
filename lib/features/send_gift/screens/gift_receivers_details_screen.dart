import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';

@RoutePage(name: 'GiftReceiversDetailsRouter')
class GiftReceiversDetailsScreen extends StatelessWidget {
  const GiftReceiversDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SPageFrameWithPadding(
      header: SSmallHeader(
        title: "Receiver's details",
      ),
      child: Center(
        child: Text('Phone/Email'),
      ),
    );
  }
}
