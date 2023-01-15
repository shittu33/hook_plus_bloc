import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../base_cubit/base_cubit.dart';
import 'bloc_status_listener.dart';
import 'bloc_loading_builder.dart';

///This combine Status Listener with Loading Builder
///
/// Also: Make sure your Cubit extends [BaseActionCubit],
/// State extends [BaseActionState] and FormData
/// extends [BaseFormData]

class BlocStatusConsumer<Cubit extends BaseActionCubit<State>,
    State extends BaseActionState> extends StatelessWidget {
  const BlocStatusConsumer({
    Key? key,
    required this.child,
    this.loaderBuilder,
    this.buildWhen,
    this.onLoading,
    this.onSuccess,
    this.onError,
    this.onFormInvalid,
    this.listener,
    this.listenWhen,
  }) : super(key: key);
  final Widget child;
  final Widget Function(State)? loaderBuilder;
  final BlocBuilderCondition<State>? buildWhen;
  final Function(State)? onLoading;
  final Function(State)? onSuccess;
  final Function(State)? onError;
  final Function(State)? onFormInvalid;
  final BlocWidgetListener<State>? listener;
  final BlocListenerCondition<State>? listenWhen;

  @override
  Widget build(BuildContext context) {
    return BlocStatusListener<Cubit, State>(
      listener: listener,
      listenWhen: listenWhen,
      onLoading: onLoading,
      onSuccess: onSuccess,
      onError: onError,
      onFormInvalid: onFormInvalid,
      child: BlocLoadingBuilder<Cubit, State>(
        loaderBuilder: loaderBuilder,
        buildWhen: buildWhen,
        child: child,
      ),
    );
  }
}
