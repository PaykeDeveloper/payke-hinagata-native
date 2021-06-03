import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:native_app/store/base/models/store_result.dart';
import 'package:native_app/store/base/models/store_state.dart';
import 'package:native_app/store/state/domain/sample/projects/models/project.dart';
import 'package:native_app/store/state/domain/sample/projects/models/project_input.dart';
import 'package:native_app/ui/widgets/atoms/submit_button.dart';
import 'package:native_app/ui/widgets/atoms/validate_checkbox.dart';
import 'package:native_app/ui/widgets/atoms/validate_date_time_picker.dart';
import 'package:native_app/ui/widgets/atoms/validate_dropdown.dart';
import 'package:native_app/ui/widgets/atoms/validate_form_state.dart';
import 'package:native_app/ui/widgets/atoms/validate_image_picker.dart';
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

final items = [
  const DropdownMenuItem(
    value: Priority.high,
    child: Text('High'),
  ),
  const DropdownMenuItem(
    value: Priority.middle,
    child: Text('Middle'),
  ),
  const DropdownMenuItem(
    value: Priority.low,
    child: Text('Low'),
  )
];

class _ProjectFormState extends ValidateFormState<ProjectForm> {
  @override
  Future<StoreResult?> onSubmit() async {
    final input = ProjectInput.fromJson(formKey.currentState!.value);
    return widget.onSubmit(input);
  }

  @override
  Widget build(BuildContext context) {
    final project = widget.project;
    final coverUrl = project?.coverUrl;
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
                ValidateTextField(
                  parent: this,
                  name: 'description',
                  labelText: 'Description',
                  initialValue: project?.description,
                  keyboardType: TextInputType.multiline,
                  minHeight: 160,
                  maxLines: 5,
                ),
                ValidateDropdown(
                  parent: this,
                  name: 'priority',
                  labelText: 'Priority',
                  items: items,
                  initialValue: project?.priority,
                ),
                ValidateCheckbox(
                  parent: this,
                  name: 'approved',
                  labelText: 'Approved',
                  initialValue: project?.approved,
                ),
                ValidateDateTimePicker(
                  parent: this,
                  name: 'startDate',
                  labelText: 'Start date',
                  inputType: InputType.date,
                  initialValue: project?.startDate,
                ),
                ValidateDateTimePicker(
                  parent: this,
                  name: 'finishedAt',
                  labelText: 'Finished at',
                  initialValue: project?.finishedAt,
                ),
                ValidateTextField(
                  parent: this,
                  name: 'difficulty',
                  labelText: 'Difficulty',
                  initialValue: project?.difficulty?.toString(),
                  keyboardType: TextInputType.number,
                ),
                ValidateTextField(
                  parent: this,
                  name: 'coefficient',
                  labelText: 'Coefficient',
                  initialValue: project?.coefficient?.toString(),
                  keyboardType: TextInputType.number,
                ),
                ValidateTextField(
                  parent: this,
                  name: 'productivity',
                  labelText: 'Productivity',
                  initialValue: project?.productivity?.toString(),
                  keyboardType: TextInputType.number,
                ),
                ValidateImagePicker(
                  parent: this,
                  name: 'coverUrl',
                  labelText: 'Cover',
                  placeholderImage:
                      coverUrl != null ? NetworkImage(coverUrl) : null,
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