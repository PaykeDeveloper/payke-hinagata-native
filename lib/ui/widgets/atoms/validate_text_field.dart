import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:native_app/ui/widgets/atoms/validate_form_state.dart';

class ValidateTextField<ParentWidget extends StatefulWidget>
    extends StatelessWidget {
  const ValidateTextField({
    required this.parent,
    required this.name,
    required this.labelText,
    this.obscureText = false,
    this.keyboardType,
    this.validators,
  });

  final ValidateFormState<ParentWidget> parent;
  final String name;
  final String labelText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final List<FormFieldValidator<String>>? validators;

  String? checkParentErrors(String? _) {
    final error = parent.errors?[name];
    if (error == null || error.isEmpty) {
      return null;
    }

    return error.join(' ');
  }

  void onChanged(String? _) {
    final shouldRemove = parent.errors?.containsKey(name) == true &&
        parent.errors?.isNotEmpty == true;

    if (!shouldRemove) {
      return;
    }

    // ignore: invalid_use_of_protected_member
    parent.setState(() {
      parent.errors?.remove(name);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      name: name,
      decoration: InputDecoration(labelText: labelText),
      onChanged: onChanged,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: FormBuilderValidators.compose(
          [...validators ?? [], checkParentErrors]),
    );
  }
}
