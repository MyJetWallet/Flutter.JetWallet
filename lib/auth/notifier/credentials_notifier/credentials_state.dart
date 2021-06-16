import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'credentials_state.freezed.dart';

@freezed
class CredentialsState with _$CredentialsState {
  const factory CredentialsState({
    required TextEditingController emailController,
    required TextEditingController passwordController,
    required TextEditingController repeatPasswordController,
  }) = _CredentialsState;
}
