import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';
import 'package:native_app/ui/widgets/atoms/validate_form_state.dart';

class ValidateImagePicker<ParentWidget extends StatefulWidget>
    extends StatelessWidget {
  const ValidateImagePicker({
    required ValidateFormState<ParentWidget> parent,
    required String name,
    required String labelText,
    ImageProvider? placeholderImage,
    List<FormFieldValidator<List<dynamic>>>? validators,
  })  : _parent = parent,
        _name = name,
        _labelText = labelText,
        _placeholderImage = placeholderImage,
        _validators = validators;

  final ValidateFormState<ParentWidget> _parent;
  final String _name;
  final String _labelText;
  final ImageProvider? _placeholderImage;
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

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 84),
      child: FormBuilderImagePicker(
        name: _name,
        placeholderImage: _placeholderImage,
        decoration: InputDecoration(labelText: _labelText),
        onChanged: _onChanged,
        validator: FormBuilderValidators.compose(
            [..._validators ?? [], _checkParentErrors]),
      ),
    );
  }
}
