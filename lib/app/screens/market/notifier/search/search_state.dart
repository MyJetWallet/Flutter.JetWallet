import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_state.freezed.dart';

@freezed
class SearchState with _$SearchState {
  const factory SearchState({
    @Default('') String search,
    required TextEditingController searchController,
  }) = _SearchState;

  const SearchState._();

  bool get showSearchErase => search.isNotEmpty;
}
