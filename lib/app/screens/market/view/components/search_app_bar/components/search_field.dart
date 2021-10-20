import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../notifier/search/search_notipod.dart';
import 'search_field_suffix.dart';

class SearchField extends HookWidget {
  const SearchField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = useProvider(searchNotipod);
    final notifier = useProvider(searchNotipod.notifier);

    return Expanded(
      child: TextFormField(
        controller: state.searchController,
        onChanged: (String text) => notifier.updateSearch(text),
        cursorColor: Colors.grey,
        keyboardType: TextInputType.text,
        style: TextStyle(
          fontSize: 18.sp,
        ),
        decoration: InputDecoration(
          hintText: 'What are you looking for?',
          hintStyle: TextStyle(
            fontSize: 18.sp,
            color: Colors.grey[400],
          ),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(5.r),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(5.r),
          ),
          contentPadding: EdgeInsets.zero,
          prefixIcon: InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {},
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 4.5.w,
              ),
              child: Icon(
                Icons.search,
                color: Colors.grey[700],
                size: 20.r,
              ),
            ),
          ),
          suffixIcon: SearchFieldSuffix(
            showErase: state.search.isNotEmpty,
            onErase: () {
              notifier.updateSearch('');
              state.searchController.clear();
            },
          ),
        ),
      ),
    );
  }
}
