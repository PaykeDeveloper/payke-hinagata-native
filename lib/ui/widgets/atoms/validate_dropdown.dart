import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:native_app/ui/widgets/atoms/validate_form_state.dart';

class ValidateDropdown<ParentWidget extends StatefulWidget, T>
    extends StatelessWidget {
  const ValidateDropdown({
    Key? key,
    required ValidateFormState<ParentWidget> parent,
    required String name,
    required String labelText,
    required List<DropdownMenuItem<T>> items,
    T? initialValue,
    bool? enabled,
    ValueTransformer<T>? valueTransformer,
    List<FormFieldValidator<T>>? validators,
  })  : _key = key,
        _parent = parent,
        _name = name,
        _labelText = labelText,
        _items = items,
        _initialValue = initialValue,
        _enabled = enabled,
        _valueTransformer = valueTransformer,
        _validators = validators;
  final Key? _key;
  final ValidateFormState<ParentWidget> _parent;
  final String _name;
  final String _labelText;
  final List<DropdownMenuItem<T>> _items;
  final T? _initialValue;
  final bool? _enabled;
  final ValueTransformer<T>? _valueTransformer;
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
        key: _key ?? ValueKey(_name),
        name: _name,
        initialValue: _initialValue,
        enabled: _enabled ?? !_parent.loading,
        decoration: InputDecoration(labelText: _labelText),
        items: _items,
        onChanged: _onChanged,
        valueTransformer: _valueTransformer,
        validator: FormBuilderValidators.compose(
            [..._validators ?? [], _checkParentErrors]),
      ),
    );
  }
}
