// FIXME: SAMPLE CODE
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:native_app/store/base/models/store_result.dart';
import 'package:native_app/store/base/models/store_state.dart';
import 'package:native_app/store/state/domain/division/divisions/models/division.dart';
import 'package:native_app/store/state/domain/division/divisions/models/division_input.dart';
import 'package:native_app/ui/widgets/atoms/submit_button.dart';
import 'package:native_app/ui/widgets/atoms/validate_form_state.dart';
import 'package:native_app/ui/widgets/atoms/validate_text_field.dart';

typedef DivisionFormCallBack = Future<StoreResult?> Function(
    DivisionInput input);

class DivisionForm extends StatefulWidget {
  const DivisionForm({
    required this.division,
    required this.status,
    required this.onSubmit,
  });

  final Division? division;
  final StateStatus status;
  final DivisionFormCallBack onSubmit;

  @override
  _DivisionFormState createState() => _DivisionFormState();
}

class _DivisionFormState extends ValidateFormState<DivisionForm> {
  @override
  Future<StoreResult?> onSubmit() async {
    final input = DivisionInput.fromJson(formKey.currentState!.value);
    return widget.onSubmit(input);
  }

  @override
  Widget build(BuildContext context) {
    final division = widget.division;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 10),
          FormBuilder(
            key: formKey,
            child: Column(
              children: [
                ValidateTextField(
                  parent: this,
                  name: 'name',
                  labelText: 'Name',
                  initialValue: division?.name,
                  validators: [
                    FormBuilderValidators.required(context),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: SubmitButton(
                  onPressed: validateAndSubmit,
                  status: widget.status,
                  enabled: !loading,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
