import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hook_plus_bloc/src/common/data/dto/dto.dart';
import 'package:logger/logger.dart';
import '../base_action_cubit/base_action_cubit.dart';
import 'base_hook_state.dart';

/// A base cubit mixin you can implement
///
/// This mixin accepts a generic type [BaseHookState]
/// and provide [initHooks] method used in
/// [BlocHookFormBuilder] build to
/// initialize [FlutterHooks]
///
/// this mixin also extend BaseActionCubit mixin,
/// meaning it contains all of its methods
/// [performAction] and [performProtectedAction]
///
mixin BaseHookMixin<State extends BaseHookState> on BaseActionCubit<State> {
  final logger = Logger();

  /// Useful for initializing data.
  ///(e.g fetch something from server,
  /// subscribes to a [Stream] or add Listeners.)
  /// This is like initState() for Stateful Widget
  /// By default [initData] is  is called once.
  /// If key is specified, [initData] is called once on the first [initData] call
  /// and whenever something within [keys] change
  initData();

  ///this function will be called when
  ///the Widget disposed
  ///(e.g cancels the subscription from a [Stream]
  ///or remove Listeners.)
  disposeData();

  ///[keys] is specified. In which case [initData] is called again
  ///only if any value inside [keys] has changed.
  List? keys;

  /// This function must be called
  /// from HookWidget's build Function
  void initHooks() {
    ///emit the the state, by adding the base HookForm to
    /// a custom hookForm

    emit(state.initHook().addHookBasicForm as State);

    /// This is like initState() for Stateful Widget
    /// this is where you make all initializations.
    useEffect(() {
      ///init data
      initData();

      ///dispose Data
      return disposeData();
    }, keys ?? []);
  }

  /// A function that process the [futureAction],
  /// [action] or [eitherAction]and emit states
  /// based on the response.
  ///
  ///
  /// [futureAction] a Function that returns
  /// Future<T> value
  ///
  /// [action] a Function that returns T value
  ///
  /// [eitherAction] a Function that returns
  /// Future<Either<Failure, T>> value
  ///
  /// [updatedState] the initial state
  /// e.g( state.copyWith(customStatus: MyOwnStatus.todoList) )
  /// [updatedLoadingState] the initialLoading state to be emitted
  /// e.g( state.copyWith(customStatus: MyOwnStatus.todoLoading) )
  /// [updatedErrorState] the initialError state to be emitted
  /// e.g( state.copyWith(customStatus: MyOwnStatus.todoError) )
  /// [updatedSuccessState] the initialSuccess state to be emitted
  /// e.g( state.copyWith(customStatus: MyOwnStatus.todoSuccess) )
  /// [autoValidate] set to true if you want form to autoValidate.
  /// [handleLoading] if you want to
  /// handle loading behaviour and don't want the function
  /// to fire the default loading action.
  /// [handleError] if you want to
  /// handle error behaviour and don't want the function
  /// to fire the default error action
  /// [handleSuccess] if you want to
  /// handle success behaviour and don't want the function
  /// to fire the default success status.
  @override
  performAction<T>({
    bool autoValidate = false,
    Future<T> Function()? futureAction,
    T Function()? action,
    Future<Either<Failure, T>> Function()? eitherAction,
    required State updatedState,
    State? updatedLoadingState,
    State? updatedErrorState,
    State? updatedSuccessState,
    Function(State)? handleOnLoading,
    Function(T, State)? handleOnSuccess,
    Function(Failure, State)? handleOnError,
    Function(Failure, State)? handleInvalidError,
  }) {
    if (autoValidate) {
      /// if AutoValidate is true, handle it and emit
      /// invalid state
      if (state.formKey?.currentState?.validate() == false) {
        if (handleInvalidError == null) {
          return emitError();
        } else {
          handleError(handleInvalidError);
        }
      }
    }
    super.performAction<T>(
      futureAction: futureAction,
      action: action,
      eitherAction: eitherAction,
      updatedState: updatedState,
      updatedLoadingState: updatedLoadingState,
      updatedSuccessState: updatedSuccessState,
      updatedErrorState: updatedErrorState,
      handleOnLoading: handleOnLoading,
      handleOnSuccess: handleOnSuccess,
      handleOnError: handleOnError,
    );
  }

  /// still the same as [performAction] but
  /// this accept [BuildContext] to trigger
  /// the Transaction Pin for you.
  /// see [performAction] for normal action
  performProtectedAction<T>(
    BuildContext context, {
    bool autoValidate = false,
    Future<T> Function()? futureAction,
    T Function()? action,
    Future<Either<Failure, T>> Function()? eitherAction,
    required State updatedState,
    State? updatedLoadingState,
    State? updatedErrorState,
    State? updatedSuccessState,
    Function(State)? handleOnLoading,
    Function(T, State)? handleOnSuccess,
    Function(Failure, State)? handleOnError,
    Function(Failure, State)? handleInvalidError,
    Function(BuildContext, Function() procceed)? launchGuardScreen,
  }) async {
    if (autoValidate) {
      /// if AutoValidate is true, handle it and emit
      /// invalid state
      if (state.formKey?.currentState?.validate() == false) {
        if (handleInvalidError == null) {
          return emitError();
        } else {
          handleError(handleInvalidError);
        }
      }
    }
    super.performProtectedAction<T>(
      context,
      futureAction: futureAction,
      action: action,
      eitherAction: eitherAction,
      updatedState: updatedState,
      updatedLoadingState: updatedLoadingState,
      updatedSuccessState: updatedSuccessState,
      updatedErrorState: updatedErrorState,
      handleOnLoading: handleOnLoading,
      handleOnSuccess: handleOnSuccess,
      handleOnError: handleOnError,
      launchGuardScreen: launchGuardScreen,
    );
  }

  emitError() {
    ///invalid inputs error
    emit(state.copyInvalidErrorForm<State>(show: true));
    return;
  }

  handleError(Function(Failure, State)? handleInvalidError) {
    ///invalid inputs error
    handleInvalidError?.call(Failure('Invalid Inputs'),
        state.copyInvalidErrorForm<State>(show: false));
  }
}
