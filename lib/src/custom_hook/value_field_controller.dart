import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// A hook that contain a [GlobalKey] for [FormFieldState]
/// and [useState] hook
///
/// This is a handy hook you can use for validating
/// any Field(e.g [DropdownButton],[Radio], [Checkbox])
ValueFieldController<T> useValueFieldController<T>([T? initialData]) {
  return ValueFieldController<T>(initialData);
}

class ValueFieldController<T> {
  late ValueNotifier<T?> optionController;
  GlobalKey<FormFieldState>? key;

  T? get value => optionController.value;

  set value(T? newValue) {
    if (optionController.value == newValue) return;
    optionController.value = newValue;
    log("value changed ${optionController.value}");
  }

  ValueFieldController([T? initialData])
      : key = GlobalKey<FormFieldState>(),
        optionController = useState<T?>(initialData);
}
