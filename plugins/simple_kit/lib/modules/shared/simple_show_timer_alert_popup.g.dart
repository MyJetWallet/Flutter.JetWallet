// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'simple_show_timer_alert_popup.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$_TimerState on __TimerStateBase, Store {
  late final _$durationAtom =
      Atom(name: '__TimerStateBase.duration', context: context);

  @override
  Duration get duration {
    _$durationAtom.reportRead();
    return super.duration;
  }

  bool _durationIsInitialized = false;

  @override
  set duration(Duration value) {
    _$durationAtom
        .reportWrite(value, _durationIsInitialized ? super.duration : null, () {
      super.duration = value;
      _durationIsInitialized = true;
    });
  }

  @override
  String toString() {
    return '''
duration: ${duration}
    ''';
  }
}
