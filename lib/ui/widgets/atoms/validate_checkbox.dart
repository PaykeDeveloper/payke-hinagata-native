import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:native_app/ui/widgets/atoms/validate_form_state.dart';

class ValidateCheckbox<ParentWidget extends StatefulWidget>
    extends StatelessWidget {
  const ValidateCheckbox({
    required ValidateFormState<ParentWidget> parent,
    required String name,
    required String labelText,
    bool? initialValue,
    List<FormFieldValidator<bool>>? validators,
  })  : _parent = parent,
        _name = name,
        _labelText = labelText,
        _initialValue = initialValue,
        _validators = validators;

  final ValidateFormState<ParentWidget> _parent;
  final String _name;
  final String _labelText;
  final bool? _initialValue;
  final List<FormFieldValidator<bool>>? _validators;

  String? _checkParentErrors(bool? _) {
    final error = _parent.errors?[_name];
    if (error == null || error.isEmpty) {
      return null;
    }

    return error.join(' ');
  }

  void _onChanged(bool? _) {
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
      child: FormBuilderCheckbox(
        name: _name,
        title: Text(_labelText),
        decoration: InputDecoration(
          labelText: _labelText,
          contentPadding: const EdgeInsets.all(8),
        ),
        initialValue: _initialValue ?? false,
        onChanged: _onChanged,
        validator: FormBuilderValidators.compose(
            [..._validators ?? [], _checkParentErrors]),
      ),
    );
  }
}
