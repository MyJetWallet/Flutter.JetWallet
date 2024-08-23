import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/crypto_jar/store/jars_store.dart';
import 'package:jetwallet/features/crypto_jar/ui/widgets/jar_list_item_widget.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

class JarsListWidget extends StatelessWidget {
  const JarsListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        final jars = JarsStore.of(context).allJar;

        return CustomScrollView(
          shrinkWrap: true,
          slivers: [
            SliverToBoxAdapter(
              child: _buildFilterListWidget(),
            ),
            SliverList.builder(
              itemCount: jars.length,
              itemBuilder: (context, index) => JarListItemWidget(
                jar: jars[index],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFilterListWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        children: [
          _buildFilterButtonWidget(_JarFilterButton.active, true),
          const SizedBox(
            width: 4.0,
          ),
          _buildFilterButtonWidget(_JarFilterButton.all),
        ],
      ),
    );
  }

  Widget _buildFilterButtonWidget(_JarFilterButton filter, [bool isSelected = false]) {
    return GestureDetector(
      onTap: () {},
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

enum _JarFilterButton { active, all }
