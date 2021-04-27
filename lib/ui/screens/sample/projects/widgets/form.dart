import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:native_app/store/base/models/store_result.dart';
import 'package:native_app/store/base/models/store_state.dart';
import 'package:native_app/store/state/domain/sample/projects/models/project.dart';
import 'package:native_app/store/state/domain/sample/projects/models/project_input.dart';
import 'package:native_app/ui/widgets/atoms/submit_button.dart';
import 'package:native_app/ui/widgets/atoms/validate_form_state.dart';
import 'package:native_app/ui/widgets/atoms/validate_text_field.dart';

typedef ProjectFormCallBack = Future<StoreResult?> Function(ProjectInput input);

class ProjectForm extends StatefulWidget {
  const ProjectForm({
    required this.project,
    required this.status,
    required this.onSubmit,
  });

  final Project? project;
  final StateStatus status;
  final ProjectFormCallBack onSubmit;

  @override
  _ProjectFormState createState() => _ProjectFormState();
}

class _ProjectFormState extends ValidateFormState<ProjectForm> {
  @override
  Future<StoreResult?> onSubmit() async {
    final input = ProjectInput.fromJson(formKey.currentState!.value);
    return widget.onSubmit(input);
  }

  @override
  Widget build(BuildContext context) {
    final project = widget.project;
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
                  initialValue: project?.name,
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
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
