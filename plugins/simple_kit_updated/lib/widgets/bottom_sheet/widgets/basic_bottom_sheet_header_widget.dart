part of '../basic_bottom_sheet.dart';

class BasicBottomSheetHeaderWidget extends StatefulWidget {
  const BasicBottomSheetHeaderWidget({
    this.title,
    this.searchOptions,
    super.key,
  });

  final String? title;
  final SearchOptions? searchOptions;

  @override
  State<BasicBottomSheetHeaderWidget> createState() => _BasicBottomSheetHeaderWidgetState();
}

class _BasicBottomSheetHeaderWidgetState extends State<BasicBottomSheetHeaderWidget> {
  final TextEditingController searchController = TextEditingController();
  bool showCloseSearchButton = false;

  @override
  void initState() {
    super.initState();

    searchController.addListener(() {
      widget.searchOptions?.onChange(searchController.text);

      if (searchController.text.isNotEmpty) {
        if (!showCloseSearchButton) {
          setState(() {
            showCloseSearchButton = true;
          });
        }
      } else {
        if (showCloseSearchButton) {
          setState(() {
            showCloseSearchButton = false;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          const SizedBox(
            height: 8.0,
          ),
          Container(
            width: 32,
            height: 6,
            decoration: ShapeDecoration(
              color: SColorsLight().gray4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
          const SizedBox(
            height: 24.0,
          ),
          if (widget.title != null) ...[
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.title!,
                style: STStyles.header6.copyWith(
                  color: SColorsLight().black,
                ),
              ),
            ),
            const SizedBox(
              height: 24.0,
            ),
          ],
          if (widget.searchOptions != null) ...[
            SInput(
              height: 44.0,
              hasCloseIcon: showCloseSearchButton,
              hint: widget.searchOptions?.hint,
              withoutVerticalPadding: true,
              onCloseIconTap: () {
                searchController.clear();
              },
              controller: searchController,
            ),
          ],
        ],
      ),
    );
  }
}

class SearchOptions {
  const SearchOptions({
    required this.hint,
    required this.onChange,
  });

  final String hint;
  final Function(String) onChange;
}
