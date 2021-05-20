import 'package:hooks_riverpod/hooks_riverpod.dart';

enum AuthScreen { signIn, signUp }

final authScreenStpod = StateProvider<AuthScreen>((ref) {
  return AuthScreen.signIn;
});
