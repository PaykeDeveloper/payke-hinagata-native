import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:native_app/ui/widgets/atoms/validate_form_state.dart';

class ValidateDateTimePicker<ParentWidget extends StatefulWidget>
    extends StatelessWidget {
  const ValidateDateTimePicker({
    required ValidateFormState<ParentWidget> parent,
    required String name,
    required String labelText,
    DateTime? initialValue,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.datetime,
    InputType inputType = InputType.both,
    List<FormFieldValidator<DateTime>>? validators,
  })  : _parent = parent,
        _name = name,
        _labelText = labelText,
        _initialValue = initialValue,
        _obscureText = obscureText,
        _keyboardType = keyboardType,
        _inputType = inputType,
        _validators = validators;

  final ValidateFormState<ParentWidget> _parent;
  final String _name;
  final String _labelText;
  final DateTime? _initialValue;
  final bool _obscureText;
  final TextInputType _keyboardType;
  final InputType _inputType;
  final List<FormFieldValidator<DateTime>>? _validators;

  String? _checkParentErrors(DateTime? _) {
    final error = _parent.errors?[_name];
    if (error == null || error.isEmpty) {
      return null;
    }

    return error.join(' ');
  }

  void _onChanged(DateTime? _) {
    final shouldRemove = _parent.errors?.containsKey(_name) == true &&
        _parent.errors?.isNotEmpty == true;

    if (!shouldRemove) {
      return;
    }

    // ignore: invalid_use_of_protected_member
    _parent.setState(() {
      _parent.errors?.remove(_name);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 84),
      child: FormBuilderDateTimePicker(
        name: _name,
        initialValue: _initialValue,
        decoration: InputDecoration(labelText: _labelText),
        onChanged: _onChanged,
        obscureText: _obscureText,
        keyboardType: _keyboardType,
        inputType: _inputType,
        validator: FormBuilderValidators.compose(
            [..._validators ?? [], _checkParentErrors]),
      ),
    );
  }
}
