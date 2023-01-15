import 'package:flutter/material.dart';

import '../base_action_cubit/base_action_state.dart';

abstract class BaseHookState extends BaseActionState {
  final GlobalKey<FormState>? formKey;

  BaseHookState(
      {this.formKey, required super.message, required super.progressStatus, required super.show});

  ///You need to override this initHook
  ///method in your child State and
  /// return the copyWith of your own State
  /// with only the Hook related
  /// state parameters
  ///
  /// see initHook() override in [SampleHookState]
  /// for example.
  ///
  BaseHookState initHook();

  ///You need to override this copyWith
  ///method in your child State and
  /// return the instance of your
  /// own State with all its state
  /// parameters
  ///
  /// see copyWith() override in [SampleHookState]
  /// for example.
  ///

  @override
  BaseHookState copyWith({
    String? message,
    ProgressStatus? progressStatus,
    GlobalKey<FormState>? formKey,
    bool? show,
  });

  BaseHookState get addHookBasicForm {
    return copyWith(
        progressStatus: ProgressStatus.initHook,
        formKey: GlobalKey<FormState>());
  }

  State copyInvalidErrorForm<State>({bool? show}) {
    return copyWith(
        message: 'Invalid Inputs',
        progressStatus: ProgressStatus.invalidFormError,
        show: show ?? false) as State;
  }
}
