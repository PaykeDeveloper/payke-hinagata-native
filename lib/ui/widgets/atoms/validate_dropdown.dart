import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:native_app/ui/widgets/atoms/validate_form_state.dart';

class ValidateDropdown<ParentWidget extends StatefulWidget, T>
    extends StatelessWidget {
  const ValidateDropdown({
    required ValidateFormState<ParentWidget> parent,
    required String name,
    required String labelText,
    required List<DropdownMenuItem<T>> items,
    T? initialValue,
    List<FormFieldValidator<T>>? validators,
  })  : _parent = parent,
        _name = name,
        _labelText = labelText,
        _items = items,
        _initialValue = initialValue,
        _validators = validators;

  final ValidateFormState<ParentWidget> _parent;
  final String _name;
  final String _labelText;
  final List<DropdownMenuItem<T>> _items;
  final T? _initialValue;
  final List<FormFieldValidator<T>>? _validators;

  String? _checkParentErrors(T? _) {
    final error = _parent.errors?[_name];
    if (error == null || error.isEmpty) {
      return null;
    }

    return error.join(' ');
  }

  void _onChanged(T? _) {
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
      child: FormBuilderDropdown<T>(
        name: _name,
        initialValue: _initialValue,
        decoration: InputDecoration(labelText: _labelText),
        items: _items,
        onChanged: _onChanged,
        validator: FormBuilderValidators.compose(
            [..._validators ?? [], _checkParentErrors]),
      ),
    );
  }
}
