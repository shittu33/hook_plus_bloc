import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logger/logger.dart';

import '../base_cubit/base_cubit.dart';

///This return [Form] but with HookWidget
///
///
///
class BlocHookFormBuilder<Cubit extends BaseHookCubit,
    State extends BaseHookState> extends HookWidget {
  const BlocHookFormBuilder({
    Key? key,
    required this.builder,
    this.cubit,
  }) : super(key: key);
  final Cubit? cubit;
  final Widget Function(State state) builder;

  @override
  Widget build(BuildContext context) {
    final logger = Logger();
    var cubitValue = cubit ?? context.read<Cubit>();
    cubitValue.initHooks();
    logger.i("reload hook state");
    return Form(
      key: cubitValue.state.formKey,
      child: builder(cubitValue.state as State),
    );
  }
}
