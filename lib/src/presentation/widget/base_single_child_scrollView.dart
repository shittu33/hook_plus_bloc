import 'package:flutter/material.dart';

class SingleChildAppBarScrollView extends StatelessWidget {
  /// A convenient [SingleChildScrollView] wrapper
  /// with a Custom AppBar
  ///
  /// to add an appBar you can either pass
  /// [appBarTitle] or [appBar] but not both
  ///
  const SingleChildAppBarScrollView({
    Key? key,
    required this.child,
    this.appBarTitle,
    this.appBar,
  })  : assert((appBar == null && appBarTitle != null) ||
            (appBar != null && appBarTitle == null)),
        super(key: key);

  final Widget child;

  /// if [appBar] isn null, this widget
  /// create a default appBar of widget[SimpleHeaderWidget]
  /// for you with this [appBarTitle]
  final Text? appBarTitle;

  ///
  final Widget? appBar;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ///AppBar
          if (appBar != null && appBarTitle == null) appBar!,
          if (appBarTitle != null && appBar == null)
            AppBar(title: appBarTitle!),
          const SizedBox(height: 16),
          child
        ],
      ),
    );
  }
}
