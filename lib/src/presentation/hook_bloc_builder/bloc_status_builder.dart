import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../base_cubit/base_cubit.dart';

///This widget hide or show its child base on the
/// current status of your State.
///
/// Also: Make sure your Cubit extends [BaseActionCubit],
/// State extends [BaseActionState] and FormData
/// extends [BaseFormData]

class BlocStatusBuilder<Cubit extends BaseActionCubit<State>,
    State extends BaseActionState> extends StatelessWidget {
  const BlocStatusBuilder({
    Key? key,
    required this.status,
    required this.builder,
    this.buildWhen,
  }) : super(key: key);
  final ProgressStatus status;
  final Widget Function(State state) builder;
  final BlocBuilderCondition<State>? buildWhen;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Cubit, State>(
      buildWhen: buildWhen ??
          (prev, current) => prev.progressStatus != current.progressStatus,
      builder: (context, state) {
        return (state.progressStatus == status && state.show == true)
            ? builder(state)
            : const SizedBox();
      },
    );
  }
}
