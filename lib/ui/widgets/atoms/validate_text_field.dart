import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:native_app/ui/widgets/atoms/validate_form_state.dart';

class ValidateTextField<ParentWidget extends StatefulWidget>
    extends StatelessWidget {
  const ValidateTextField({
    required ValidateFormState<ParentWidget> parent,
    required String name,
    required String labelText,
    bool obscureText = false,
    TextInputType? keyboardType,
    List<FormFieldValidator<String>>? validators,
  })  : _parent = parent,
        _name = name,
        _labelText = labelText,
        _obscureText = obscureText,
        _keyboardType = keyboardType,
        _validators = validators;

  final ValidateFormState<ParentWidget> _parent;
  final String _name;
  final String _labelText;
  final bool _obscureText;
  final TextInputType? _keyboardType;
  final List<FormFieldValidator<String>>? _validators;

  String? _checkParentErrors(String? _) {
    final error = _parent.errors?[_name];
    if (error == null || error.isEmpty) {
      return null;
    }

    return error.join(' ');
  }

  void _onChanged(String? _) {
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
    return FormBuilderTextField(
      name: _name,
      decoration: InputDecoration(labelText: _labelText),
      onChanged: _onChanged,
      obscureText: _obscureText,
      keyboardType: _keyboardType,
      validator: FormBuilderValidators.compose(
          [..._validators ?? [], _checkParentErrors]),
    );
  }
}
