import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:native_app/store/base/models/state_error.dart';
import 'package:native_app/store/base/models/state_result.dart';

abstract class ValidateFormState<T extends StatefulWidget> extends State<T> {
  final formKey = GlobalKey<FormBuilderState>();

  Map<String, List<String>>? errors;

  Future<StateResult?> onSubmit() async {}

  void validateAndSubmit() {
    _resetError();
    if (formKey.currentState?.saveAndValidate() == true) {
      _handleSubmit();
    }
  }

  void _resetError() {
    if (errors == null) {
      return;
    }

    setState(() {
      errors = null;
    });
  }

  Future _handleSubmit() async {
    final result = await onSubmit();
    if (result != null) {
      _reflectResult(result);
    }
  }

  void _reflectResult(StateResult result) {
    final error = result is Failure ? result.error : null;
    _setError(error);
    formKey.currentState?.validate();
  }

  void _setError(StateError? error) {
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
    if (message != null && message.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).errorColor,
      ));
    }
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
