import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:native_app/store/base/models/store_error.dart';
import 'package:native_app/store/base/models/store_result.dart';
import 'package:native_app/ui/extensions/state_error.dart';

abstract class ValidateFormState<T extends StatefulWidget> extends State<T> {
  final formKey = GlobalKey<FormBuilderState>();

  Map<String, List<String>>? errors;
  bool loading = false;

  Future<StoreResult?> onSubmit() async {
    return null;
  }

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
    _setLoading(true);
    final result = await onSubmit();
    if (result != null) {
      _reflectResult(result);
    }
    _setLoading(false);
  }

  void _reflectResult(StoreResult result) {
    final error = switch (result) {
      Success() => null,
      Failure(error: final error) => error,
    };
    _setError(error);
    formKey.currentState?.validate();
  }

  void _setError(StoreError? error) {
    if (error == null) {
      setState(() {
        errors = null;
      });
      return;
    }

    setState(() {
      errors = _getErrors(error);
    });

    final message = error.getContextMessage(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Theme.of(context).colorScheme.error,
    ));
  }

  Map<String, List<String>>? _getErrors(StoreError error) {
    return switch (error) {
      BadRequest(result: final result) => result.errors,
      _ => null,
    };
  }

  void _setLoading(bool value) {
    if (loading == value) {
      return;
    }

    setState(() {
      loading = value;
    });
  }
}
