import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// A hook that contain a [GlobalKey] for [FormFieldState]
/// and [useTextEditingController] hook
///
/// This is a handy hook you can use for validating
/// any [TextFormField]
TextFieldController useTextFieldController<T>() {
  return TextFieldController();
}

class TextFieldController {
  late TextEditingController controller;
  GlobalKey<FormFieldState>? key;

  String get text => controller.text;

  set text(String value) {
    controller.text = value;
    log("value changed ${controller.text}");
  }

  TextFieldController()
      : key = GlobalKey<FormFieldState>(),
        controller = useTextEditingController();
}
