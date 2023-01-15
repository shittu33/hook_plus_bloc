import 'dart:developer';

import 'package:logger/logger.dart';

/// Common Status you may likely need
/// to handle in states
enum ProgressStatus {
  success,
  error,
  invalidFormError,
  loading,
  idle,
  init,
  initHook;

  bool get isInit => this == ProgressStatus.init;

  bool get isInitHook => this == ProgressStatus.initHook;

  bool get isIdle => this == ProgressStatus.idle;

  bool get isLoading => this == ProgressStatus.loading;

  bool get isSuccess => this == ProgressStatus.success;

  bool get isError => this == ProgressStatus.error;

  bool get isInvalidFormError => this == ProgressStatus.invalidFormError;
}

/// A Base state class you can extend
/// This class used
///   [ProgressStatus.success],
///   [ProgressStatus.error],
///   [ProgressStatus.loading],
///   [ProgressStatus.idle],
///   [ProgressStatus.init],
///   to handle basic ProgressStatus
///   and message to explicitly fire Success
///   and Error Action
///
///  [BaseActionState] need to be used
///  in [BaseActionCubit]

abstract class BaseActionState /*extends Equatable*/ {
  final String message;
  final ProgressStatus progressStatus;
  final bool show;

  BaseActionState({
    required this.message,
    required this.progressStatus,
    required this.show,
  });

  ///You need to override this copyWith
  ///method in your child State and
  /// return the instance of your
  /// own State with all its state
  /// parameters
  ///
  /// see copyWith() override in [SampleHookState]
  /// for example.
  ///
  BaseActionState copyWith({
    String? message,
    ProgressStatus? progressStatus,
    bool? show,
  });

  State copyLoading<State>({bool? show}) =>
      copyWith(progressStatus: ProgressStatus.loading, show: show ?? false)
          as State;

  State copySuccess<State>({bool? show}) =>
      copyWith(progressStatus: ProgressStatus.success, show: show ?? false)
          as State;

  State copyError<State>({bool? show}) =>
      copyWith(progressStatus: ProgressStatus.error, show: show ?? false)
          as State;

  State copyShowProgress<State>(bool show) => copyWith(show: show) as State;

  State copyIdle<State>({bool? show}) =>
      copyWith(progressStatus: ProgressStatus.idle, show: show ?? false)
          as State;

  // @optionalTypeArgs
  TResult maybeWhenProgress<TResult extends Object?,
      State extends BaseActionState>({
    TResult Function(State state)? loading,
    TResult Function(State state)? success,
    TResult Function(State state)? error,
    TResult Function(State state)? formInvalid,
    required TResult Function() orElse,
  }) {
    var logger = Logger();
    if (progressStatus.isLoading && loading != null) {
      logger.i('maybe when loading');
      return loading(this as State);
    } else if (progressStatus.isSuccess && success != null) {
      logger.i('onSuccess');
      logger.i('onSuccess AFFIRM');
      return success(this as State);
    } else if (progressStatus.isError && error != null) {
      log('maybe when error');
      return error(this as State);
    } else if (progressStatus.isInvalidFormError && formInvalid != null) {
      return formInvalid(this as State);
    } else {
      logger.i('maybe when called');
      return orElse.call();
    }
  }

  // @optionalTypeArgs
  TResult? maybeWhen<TResult extends Object?>({
    required TResult Function() orElse,
  });
}
