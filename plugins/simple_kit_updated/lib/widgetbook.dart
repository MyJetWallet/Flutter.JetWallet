import 'package:flutter/material.dart';
import 'package:simple_kit_updated/widgets/navigation/top_app_bar/global_basic_appbar.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

void main() {
  runApp(const WidgetbookApp());
}

@widgetbook.App()
class WidgetbookApp extends StatelessWidget {
  const WidgetbookApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(
      directories: [
        WidgetbookComponent(
          name: 'Navigation',
          useCases: [
            WidgetbookUseCase(
              name: 'with green color',
              builder: (context) => const GlobalBasicAppBar(
                title: 'Title',
                subtitle: 'Subtitle',
              ),
            ),
          ],
        ),
      ],
      addons: [],
      integrations: [],
    );
  }
}
