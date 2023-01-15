import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/util.dart';
import '../base_cubit/base_cubit.dart';

/// To show Loading modal for loading Status
/// wrap the root widget in your screen with this Widget.
///
/// Also: Make sure your Cubit extends [BaseActionCubit],
/// State extends [BaseActionState] and FormData
/// extends [BaseFormData]

class BlocLoadingBuilder<Cubit extends BaseActionCubit<State>,
    State extends BaseActionState> extends StatelessWidget {
  const BlocLoadingBuilder({
    Key? key,
    required this.child,
    this.loaderBuilder,
    this.buildWhen,
  }) : super(key: key);
  final Widget child;
  final Widget Function(State)? loaderBuilder;
  final BlocBuilderCondition<State>? buildWhen;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Cubit, State>(
      buildWhen: buildWhen ??
          (prev, current) => prev.progressStatus != current.progressStatus,
      builder: (context, state) {
        return Stack(
          children: [
            GestureDetector(
              onTap: () => Util.hideKeyboard,
              child: child,
            ),
            if (loaderBuilder != null)
              loaderBuilder!(state)
            else if (state.progressStatus == ProgressStatus.loading &&
                state.show == true)
              const CircularProgressIndicator()
            else
              const SizedBox()
          ],
        );
      },
    );
  }
}
