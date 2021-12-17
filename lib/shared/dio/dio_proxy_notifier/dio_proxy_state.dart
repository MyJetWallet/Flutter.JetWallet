import 'package:freezed_annotation/freezed_annotation.dart';

part 'dio_proxy_state.freezed.dart';

@freezed
class DioProxyState with _$DioProxyState {
  const factory DioProxyState({
    @Default('') String proxyName,
  }) = _DioProxyState;

  const DioProxyState._();

  bool get isProxyEnabled => proxyName.isNotEmpty;
}
