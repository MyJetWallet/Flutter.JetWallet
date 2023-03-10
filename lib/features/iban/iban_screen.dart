import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/features/iban/widgets/iban_header.dart';
import 'package:simple_kit/modules/shared/page_frames/simple_page_frame.dart';

import '../../core/l10n/i10n.dart';

class IBanScreen extends StatelessObserverWidget {
  const IBanScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return SPageFrame(
      loaderText: intl.register_pleaseWait,
      header: const IBanHeader(),
      child: Text('Account here'),
    );
  }
}
