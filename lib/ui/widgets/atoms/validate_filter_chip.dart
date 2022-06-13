import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:native_app/ui/widgets/atoms/validate_form_state.dart';

class ValidateFilterChip<ParentWidget extends StatefulWidget, T>
    extends StatelessWidget {
  const ValidateFilterChip({
    Key? key,
    required ValidateFormState<ParentWidget> parent,
    required String name,
    required String labelText,
    required List<FormBuilderChipOption<T>> options,
    List<T> initialValue = const [],
    bool? enabled,
    ValueTransformer<List<T>?>? valueTransformer,
    List<FormFieldValidator<List<T>>>? validators,
    this.runSpacing = 0.0,
    this.spacing = 0.0,
  })  : _key = key,
        _parent = parent,
        _name = name,
        _labelText = labelText,
        _options = options,
        _initialValue = initialValue,
        _enabled = enabled,
        _valueTransformer = valueTransformer,
        _validators = validators;
  final Key? _key;
  final ValidateFormState<ParentWidget> _parent;
  final String _name;
  final String _labelText;
  final List<FormBuilderChipOption<T>> _options;
  final List<T> _initialValue;
  final bool? _enabled;
  final ValueTransformer<List<T>?>? _valueTransformer;
  final List<FormFieldValidator<List<T>>>? _validators;
  final double runSpacing, spacing;

  String? _checkParentErrors(List<T>? _) {
    final error = _parent.errors?[_name];
    if (error == null || error.isEmpty) {
      return null;
    }

    return error.join(' ');
  }

  void _onChanged(List<T>? _) {
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
      child: FormBuilderFilterChip<T>(
        key: _key ?? ValueKey(_name),
        name: _name,
        initialValue: _initialValue,
        enabled: _enabled ?? !_parent.loading,
        decoration: InputDecoration(labelText: _labelText),
        options: _options,
        onChanged: _onChanged,
        valueTransformer: _valueTransformer,
        validator: FormBuilderValidators.compose(
            [..._validators ?? [], _checkParentErrors]),
        runSpacing: runSpacing,
        spacing: spacing,
      ),
    );
  }
}
