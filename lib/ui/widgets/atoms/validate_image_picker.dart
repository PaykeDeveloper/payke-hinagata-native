import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:native_app/ui/widgets/atoms/validate_form_state.dart';

class ValidateImagePicker<ParentWidget extends StatefulWidget>
    extends StatelessWidget {
  const ValidateImagePicker({
    super.key,
    required ValidateFormState<ParentWidget> parent,
    required String name,
    required String labelText,
    List<dynamic>? initialValue,
    bool? enabled,
    int maxImages = 1,
    ValueTransformer<List<dynamic>?>? valueTransformer,
    List<FormFieldValidator<List<dynamic>>>? validators,
  })  : _parent = parent,
        _name = name,
        _labelText = labelText,
        _initialValue = initialValue,
        _enabled = enabled,
        _maxImages = maxImages,
        _valueTransformer = valueTransformer,
        _validators = validators;
  final ValidateFormState<ParentWidget> _parent;
  final String _name;
  final String _labelText;
  final List<dynamic>? _initialValue;
  final bool? _enabled;
  final int _maxImages;
  final ValueTransformer<List<dynamic>?>? _valueTransformer;
  final List<FormFieldValidator<List<dynamic>>>? _validators;

  String? _checkParentErrors(List<dynamic>? _) {
    final error = _parent.errors?[_name];
    if (error == null || error.isEmpty) {
      return null;
    }

    return error.join(' ');
  }

  void _onChanged(List<dynamic>? _) {
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

  dynamic _singleTransfer(List<dynamic>? value) {
    return value?.firstOrNull;
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 84),
      child: FormBuilderImagePicker(
        key: key ?? ValueKey(_name),
        name: _name,
        initialValue: _initialValue,
        enabled: _enabled ?? !_parent.loading,
        decoration: InputDecoration(labelText: _labelText),
        onChanged: _onChanged,
        maxImages: _maxImages,
        valueTransformer:
            _valueTransformer ?? (_maxImages == 1 ? _singleTransfer : null),
        validator: FormBuilderValidators.compose(
            [..._validators ?? [], _checkParentErrors]),
      ),
    );
  }
}
