import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:hook_plus_bloc/src/common/data/dto/dto.dart';

import 'base_action_state.dart';


/// A base cubit mixin you can implement
///
/// This mixin accepts a generic type [BaseActionState]
/// and provide 2 methods  [performAction]
/// and [performProtectedAction] you can use
/// to trigger any action in your cubit
///
/// this mixin automatically handle status:
///   [ProgressStatus.success],
///   [ProgressStatus.error],
///   [ProgressStatus.loading],
///   [ProgressStatus.idle],
///   [ProgressStatus.init],
///   but you also provide you the flexibility
///   to modify the actions.
///
mixin BaseActionCubit<State extends BaseActionState> on Cubit<State> {
  final logger = Logger();

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
  /// please ensure you change this to your own state
  /// [updatedLoadingState] the initialLoading state to be emitted
  /// e.g( state.copyWith(customStatus: MyOwnStatus.todoLoading) )
  /// [updatedErrorState] the initialError state to be emitted
  /// e.g( state.copyWith(customStatus: MyOwnStatus.todoError) )
  /// [updatedSuccessState] the initialSuccess state to be emitted
  /// e.g( state.copyWith(customStatus: MyOwnStatus.todoSuccess) )
  /// [handleLoading] if you want to
  /// handle loading behaviour and don't want the function
  /// to fire the default loading action.
  /// [handleError] if you want to
  /// handle error behaviour and don't want the function
  /// to fire the default error action
  /// [handleSuccess] if you want to
  /// handle success behaviour and don't want the function
  /// to fire the default success status.
  performAction<T>({
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

  }) async {
    _performAction<T>(
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
        Function(BuildContext, Function() procceed)? launchGuardScreen,

      }) async {
    _performAction<T>(
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
      launchGuardScreen: (proceed) => launchGuardScreen?.call(context, proceed),
    );
  }

  /// see [performAction] for details
  _performAction<T>({
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
    Function(Function() procceed)? launchGuardScreen,
  }) async {
    ///assert that either [actionResponse] or [action] is not null
    assert(eitherAction != null || action != null || futureAction != null,
        'either actionResponse, action, or futureAction shouldn\'t be null ');

    assert(
        (eitherAction != null && futureAction == null && action == null) ||
            (eitherAction == null && futureAction != null && action == null) ||
            (eitherAction == null && futureAction == null && action != null),
        'only of the actionResponse, action, or futureAction should be passed');

    var state = updatedState;
    void _handleLoading() {
      if (updatedLoadingState != null) {
        state = updatedLoadingState;
      }
      if (handleOnLoading == null) {
        logger.i("start Loading...");
        emit(
          state.copyLoading<State>(show: true),
        );
        logger.i("Loading fired!");
        logger.i(state.progressStatus);
        logger.i(state.show);
      } else {
        emit(state.copyIdle(show: false) as State);
        handleOnLoading.call(state);
      }
    }

    ///call [HandleActionUseCase] and assign
    ///it to a variable
    var _handleAction = HandleActionUseCase<T>().call(
      eitherAction: eitherAction,
      futureAction: futureAction,
      action: action,
      handleSuccess: (T response) {
        var message;

        logger.i("success fired!");
        if (updatedSuccessState != null) {
          state = updatedSuccessState;
        }
        if (handleOnSuccess == null) {
          if (response is MessageResponse) {
            message = response.message;
          } else {
            emit(state.copySuccess<State>(show: true));
            return;
          }
          emit(state.copyWith(message: message).copySuccess<State>(show: true));
        } else {
          emit(state.copyIdle(show: false) as State);
          handleOnSuccess.call(response, state.copySuccess<State>(show: false));
        }
      },
      handleError: (Failure failure) {
        ///if DioError is thrown
        ///emit the error state
        logger.e("error fired!");
        if (updatedErrorState != null) {
          state = updatedErrorState;
        }
        if (handleOnError == null) {
          emit(state
              .copyError<State>(show: true)
              .copyWith(message: failure.message) as State);
          logger.e("Cubit Error");
        } else {
          emit(state.copyIdle(show: false) as State);
          handleOnError.call(
            failure,
            state
                .copyError<State>(show: false)
                .copyWith(message: failure.message) as State,
          );
        }
      },
    );

    ///Start Loading
    _handleLoading();

    ///handle Action
    if (launchGuardScreen != null)

      ///if performProtectedAction
      ///first launch the TransactionPin
      ///then proceed with the action
      launchGuardScreen.call(() => _handleAction);
    else {
      ///if not a just call the action straight up.
      _handleAction;
    }
  }
}

class HandleActionUseCase<T> {
  call({
    Future<Either<Failure, T>> Function()? eitherAction,
    Future<T> Function()? futureAction,
    T Function()? action,
    required Function(T) handleSuccess,
    required Function(Failure) handleError,
  }) async {
    var logger = Logger();

    ///check if actionResponse is not null
    if (futureAction != null || action != null) {
      var response;
      try {
        if (futureAction != null) {
          response = await futureAction();
        } else {
          response = action?.call();
        }

        handleSuccess(response);
        logger.i("UseCase Success");
      } on DioError catch (e) {
        handleError(Failure(errorObject: e, e.message));
        logger.e("UseCase Error");
      } on StateError catch (e) {
        if (e.message == "No element") {
          handleError(Failure(
              errorObject: e, "No Data currently available for this feature."));
        }
      } catch (e) {
        var filteredException = e.toString().replaceFirst("Exception:", "");
        handleError(Failure(errorObject: e, filteredException));
        logger.e("UseCase Error");
        logger.e(filteredException);
      }
      return;
    }

    return (await eitherAction?.call())?.fold(
      (l) {
        handleError(l);
      },
      (r) {
        handleSuccess(r);
      },
    );
  }
}
