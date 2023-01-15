import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import '../../common/util.dart';
import '../base_cubit/base_cubit.dart';

///This widget fire listeners based on the
/// current status of your State.
///
/// Also: Make sure your Cubit extends [BaseActionCubit],
/// State extends [BaseActionState] and FormData
/// extends [BaseFormData]

class BlocStatusListener<Cubit extends BaseActionCubit<State>,
    State extends BaseActionState> extends StatelessWidget {
  const BlocStatusListener({
    Key? key,
    required this.child,
    this.listener,
    this.listenWhen,
    this.onLoading,
    this.onSuccess,
    this.onError,
    this.onFormInvalid,
  }) : super(key: key);
  final Widget child;
  final Function(State)? onLoading;
  final Function(State)? onSuccess;
  final Function(State)? onError;
  final Function(State)? onFormInvalid;
  final BlocWidgetListener<State>? listener;
  final BlocListenerCondition<State>? listenWhen;

  @override
  Widget build(BuildContext context) {
    final logger = Logger();
    return BlocListener<Cubit, State>(
      listenWhen: listenWhen ??
          (prev, current) => prev.progressStatus != current.progressStatus,
      listener: listener ??
          (ctx, state) {
            state.maybeWhenProgress(
              loading: (State state) {
                logger.i("onLoading");
                if (state.show == true) onLoading?.call(state);
              },
              success: <State>(state) {
                if (state.show == false) return;
                if (onSuccess != null) {
                  onSuccess!(state);
                  return;
                }
                Util.showSnackBar(
                  context,
                  state.message ?? "",
                );
              },
              error: <State>(state) {
                logger.d(state.message);

                logger.i("onError");
                if (state.show == false) return;
                if (onError != null) {
                  onError!(state);
                  return;
                }
                logger.e("Listener Error");
                Util.showSnackBar(
                  context,
                  error:true,
                  state.message ?? "Oops we encountered an error",
                );
              },
              formInvalid: <State>(state) {
                logger.i("onFormInvalid");
                if (state.show == false) return;
                if (onFormInvalid != null) {
                  onFormInvalid!(state);
                  return;
                }
                Util.showSnackBar(
                  context,
                  state.message ?? "",
                );
              },
              orElse: () {},
            );

            // if (state.progressStatus == ProgressStatus.loading &&
            //     state.show == true) {
            //   logger.i("Loading...");
            //   onLoading?.call(state);
            // }
            // if (state.progressStatus == ProgressStatus.error &&
            //     state.show == true) {
            //   if (onError != null) {
            //     onError!(state);
            //     return;
            //   }
            //   logger.e("Listener Error");
            //   Util.showErrorModal(
            //     context,
            //     state.message ?? "Oops we encountered an error",
            //   );
            // } else if (state.progressStatus == ProgressStatus.success &&
            //     state.show == true) {
            //   if (onSuccess != null) {
            //     onSuccess!(state);
            //     return;
            //   }
            //   Util.showSuccessModal(
            //     context,
            //     state.message ?? "",
            //   );
            // } else if (state.progressStatus ==
            //     ProgressStatus.invalidFormError) {
            //   if (onFormInvalid != null) {
            //     onFormInvalid!(state);
            //     return;
            //   }
            //   Util.showSnackBar(
            //     context,
            //     state.message ?? "",
            //   );
            // }
          },
      child: child,
    );
  }
}
