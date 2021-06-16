import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:native_app/base/utils.dart';
import 'package:native_app/store/base/models/store_result.dart';
import 'package:native_app/store/base/models/store_state.dart';
import 'package:native_app/store/state/domain/common/roles/models/role.dart';
import 'package:native_app/store/state/domain/common/roles/models/role_id.dart';
import 'package:native_app/store/state/domain/common/users/models/user.dart';
import 'package:native_app/store/state/domain/common/users/models/user_id.dart';
import 'package:native_app/store/state/domain/division/members/models/member.dart';
import 'package:native_app/ui/widgets/atoms/submit_button.dart';
import 'package:native_app/ui/widgets/atoms/validate_dropdown.dart';
import 'package:native_app/ui/widgets/atoms/validate_filter_chip.dart';
import 'package:native_app/ui/widgets/atoms/validate_form_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

typedef MemberFormCallBack = Future<StoreResult?> Function(
    Map<String, dynamic> input);

class MemberForm extends StatefulWidget {
  const MemberForm({
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
  _MemberFormState createState() => _MemberFormState();
}

class _MemberFormState extends ValidateFormState<MemberForm> {
  @override
  Future<StoreResult?> onSubmit() async {
    final input = Map<String, dynamic>.from(formKey.currentState!.value);
    return widget.onSubmit(input);
  }

  @override
  Widget build(BuildContext context) {
    final member = widget.member;
    final List<User?> users = widget.users;
    final List<Role> roles = widget.roles;
    final rolesMap = convertListToMap(roles, (Role role) => role.id.value);

    final initialUserValue = users.firstWhere(
        (element) => element?.id == member?.userId,
        orElse: () => null)?.id;

    final initialRolesValue = member?.roleNames ?? [];

    final List<DropdownMenuItem> userNameItems = [
      const DropdownMenuItem(child: Text('')),
      ...users
          .map((user) =>
              DropdownMenuItem(value: user?.id, child: Text(user!.name)))
          .toList()
    ];

    final roleItems = [
      ...roles.map((role) => FormBuilderFieldOption(
            key: Key('${role.id}'),
            value: rolesMap[role.id.value]!.name,
            child: Text(role.name),
          ))
    ];

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
                  labelText: 'Name',
                  items: userNameItems,
                  initialValue: initialUserValue,
                  valueTransformer: (value) => (value as UserId?)?.value,
                  validators: [
                    FormBuilderValidators.required(context),
                  ],
                ),
                ValidateFilterChip(
                  parent: this,
                  name: 'role_names',
                  labelText: 'Roles',
                  options: roleItems,
                  initialValue: initialRolesValue,
                  // valueTransformer: (value) => (value as List<String>,
                  validators: [
                    (List<String>? selected) {
                      if (selected == null || selected.isEmpty) {
                        return AppLocalizations.of(context)!.noRoleSelected;
                      }
                      return null;
                    }
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
