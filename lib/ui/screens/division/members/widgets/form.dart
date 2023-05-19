import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:native_app/store/base/models/store_result.dart';
import 'package:native_app/store/base/models/store_state.dart';
import 'package:native_app/store/state/domain/common/roles/models/role.dart';
import 'package:native_app/store/state/domain/common/users/models/user.dart';
import 'package:native_app/store/state/domain/common/users/models/user_id.dart';
import 'package:native_app/store/state/domain/division/members/models/member.dart';
import 'package:native_app/store/state/domain/division/members/models/member_input.dart';
import 'package:native_app/ui/widgets/atoms/submit_button.dart';
import 'package:native_app/ui/widgets/atoms/validate_dropdown.dart';
import 'package:native_app/ui/widgets/atoms/validate_filter_chip.dart';
import 'package:native_app/ui/widgets/atoms/validate_form_state.dart';

typedef MemberFormCallBack = Future<StoreResult?> Function(MemberInput input);

class MemberForm extends StatefulWidget {
  const MemberForm({
    super.key,
    required this.member,
    required this.users,
    required this.roles,
    required this.status,
    required this.onSubmit,
  });

  final Member? member;
  final List<User> users;
  final List<Role> roles;
  final StateStatus status;
  final MemberFormCallBack onSubmit;

  @override
  ValidateFormState<MemberForm> createState() => _MemberFormState();
}

class _MemberFormState extends ValidateFormState<MemberForm> {
  @override
  Future<StoreResult?> onSubmit() async {
    final input = MemberInput.fromJson(formKey.currentState!.value);
    return widget.onSubmit(input);
  }

  @override
  Widget build(BuildContext context) {
    final member = widget.member;
    final users = widget.users;
    final roles = widget.roles;
    final initialRolesValue = member?.roleNames ?? [];

    final List<DropdownMenuItem<UserId>> userNameItems = [
      const DropdownMenuItem(child: Text('')),
      ...users
          .map((user) =>
              DropdownMenuItem(value: user.id, child: Text(user.name)))
          .toList()
    ];

    final roleItems = roles
        .map((role) => FormBuilderChipOption<String>(
              key: ValueKey('${role.id}'),
              value: role.name,
              child: Text(role.name),
            ))
        .toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 10),
          FormBuilder(
            key: formKey,
            child: Column(
              children: [
                ValidateDropdown(
                  parent: this,
                  name: 'user_id',
                  labelText: 'User',
                  items: userNameItems,
                  initialValue: member?.userId,
                  valueTransformer: (value) => value?.value,
                  validators: [
                    FormBuilderValidators.required(),
                  ],
                  enabled: member == null,
                ),
                ValidateFilterChip(
                  parent: this,
                  name: 'role_names',
                  labelText: 'Roles',
                  options: roleItems,
                  initialValue: initialRolesValue,
                  validators: [
                    FormBuilderValidators.required<List<String>>(),
                  ],
                  spacing: 5,
                  runSpacing: 5,
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
