import 'package:flutter/material.dart';
import 'package:native_app/store/base/models/state_error.dart';

abstract class ValidateFormState<T extends StatefulWidget> extends State<T> {
  Map<String, List<String>>? errors;

  void setError(StateError? error) {
    if (error == null) {
      setState(() {
        errors = null;
      });
      return;
    }

    setState(() {
      errors = _getErrors(error);
    });

    final message = _getMessage(error);
    if (message != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).errorColor,
      ));
    }
  }

  void resetError() {
    if (errors == null) {
      return;
    }

    setState(() {
      errors = null;
    });
  }

  String? _getMessage(StateError error) {
    if (error is BadRequest) {
      return error.result.message;
    }
    return null;
  }

  Map<String, List<String>>? _getErrors(StateError error) {
    if (error is BadRequest) {
      return error.result.errors;
    }
    return null;
  }
}
