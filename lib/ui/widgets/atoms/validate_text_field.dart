import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:native_app/ui/widgets/atoms/validate_form_state.dart';

class ValidateTextField<ParentWidget extends StatefulWidget>
    extends StatelessWidget {
  const ValidateTextField({
    Key? key,
    required ValidateFormState<ParentWidget> parent,
    required String name,
    required String labelText,
    String? initialValue,
    bool? enabled,
    bool obscureText = false,
    TextInputType? keyboardType,
    double minHeight = 84,
    int maxLines = 1,
    ValueTransformer<String?>? valueTransformer,
    List<FormFieldValidator<String>>? validators,
  })  : _key = key,
        _parent = parent,
        _name = name,
        _labelText = labelText,
        _initialValue = initialValue,
        _enabled = enabled,
        _obscureText = obscureText,
        _keyboardType = keyboardType,
        _minHeight = minHeight,
        _maxLines = maxLines,
        _valueTransformer = valueTransformer,
        _validators = validators;
  final Key? _key;
  final ValidateFormState<ParentWidget> _parent;
  final String _name;
  final String _labelText;
  final String? _initialValue;
  final bool? _enabled;
  final bool _obscureText;
  final TextInputType? _keyboardType;
  final double _minHeight;
  final int _maxLines;
  final ValueTransformer<String?>? _valueTransformer;
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
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: _minHeight),
      child: FormBuilderTextField(
        key: _key ?? ValueKey(_name),
        name: _name,
        initialValue: _initialValue,
        enabled: _enabled ?? !_parent.loading,
        decoration: InputDecoration(labelText: _labelText),
        onChanged: _onChanged,
        obscureText: _obscureText,
        keyboardType: _keyboardType,
        maxLines: _maxLines,
        valueTransformer: _valueTransformer,
        validator: FormBuilderValidators.compose(
            [..._validators ?? [], _checkParentErrors]),
      ),
    );
  }
}
