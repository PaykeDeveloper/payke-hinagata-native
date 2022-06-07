import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:native_app/ui/widgets/atoms/validate_form_state.dart';

class ValidateCheckbox<ParentWidget extends StatefulWidget>
    extends StatelessWidget {
  const ValidateCheckbox({
    Key? key,
    required ValidateFormState<ParentWidget> parent,
    required String name,
    required String labelText,
    bool? initialValue,
    bool? enabled,
    List<FormFieldValidator<bool>>? validators,
  })  : _key = key,
        _parent = parent,
        _name = name,
        _labelText = labelText,
        _initialValue = initialValue,
        _enabled = enabled,
        _validators = validators;
  final Key? _key;
  final ValidateFormState<ParentWidget> _parent;
  final String _name;
  final String _labelText;
  final bool? _initialValue;
  final bool? _enabled;
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
        key: _key ?? ValueKey(_name),
        name: _name,
        title: Text(_labelText),
        decoration: InputDecoration(
          labelText: _labelText,
          contentPadding: const EdgeInsets.all(8),
        ),
        initialValue: _initialValue ?? false,
        enabled: _enabled ?? !_parent.loading,
        onChanged: _onChanged,
        validator: FormBuilderValidators.compose(
            [..._validators ?? [], _checkParentErrors]),
      ),
    );
  }
}
