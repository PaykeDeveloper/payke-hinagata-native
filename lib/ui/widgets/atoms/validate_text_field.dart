import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:native_app/ui/widgets/atoms/validate_form_state.dart';

class ValidateTextField<T extends StatefulWidget> extends StatelessWidget {
  const ValidateTextField({
    required this.parent,
    required this.name,
    required this.labelText,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
  });

  final ValidateFormState<T> parent;
  final String name;
  final String labelText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      name: name,
      decoration: InputDecoration(
        labelText: labelText,
        errorText: parent.errors?[name]?.join(' '),
      ),
      onChanged: (String? _) {
        // ignore: invalid_use_of_protected_member
        parent.setState(() {
          parent.errors?.remove(name);
        });
      },
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
    );
  }
}
