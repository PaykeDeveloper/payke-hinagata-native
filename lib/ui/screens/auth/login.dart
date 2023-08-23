import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:native_app/store/base/models/store_result.dart';
import 'package:native_app/store/base/models/store_state.dart';
import 'package:native_app/store/state/app/login/notifier.dart';
import 'package:native_app/store/state/app/login/selectors.dart';
import 'package:native_app/ui/widgets/atoms/logo.dart';
import 'package:native_app/ui/widgets/atoms/submit_button.dart';
import 'package:native_app/ui/widgets/atoms/validate_form_state.dart';
import 'package:native_app/ui/widgets/atoms/validate_text_field.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<StoreResult> onSubmit(String email, String password) async {
      final notifier = ref.read(loginStateProvider.notifier);
      return notifier.login(email, password);
    }

    final status = ref.watch(loginStatusSelector);

    return Scaffold(
      body: _Login(
        onSubmit: onSubmit,
        status: status,
      ),
    );
  }
}

typedef _OnSubmit = Future<StoreResult> Function(String email, String password);

class _Login extends StatefulWidget {
  const _Login({
    required this.onSubmit,
    required this.status,
  });

  final _OnSubmit onSubmit;
  final StateStatus status;

  @override
  ValidateFormState<_Login> createState() => _LoginState();
}

class _LoginState extends ValidateFormState<_Login> {
  @override
  Future<StoreResult> onSubmit() async {
    final email = formKey.currentState!.value['email'] as String;
    final password = formKey.currentState!.value['password'] as String;
    return widget.onSubmit(email, password);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          const SizedBox(height: 100),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(10),
            child: const Logo(),
          ),
          FormBuilder(
            key: formKey,
            child: Column(
              children: [
                ValidateTextField(
                  parent: this,
                  name: 'email',
                  labelText: AppLocalizations.of(context)!.email,
                  keyboardType: TextInputType.emailAddress,
                  validators: [
                    FormBuilderValidators.required(),
                    FormBuilderValidators.email(),
                  ],
                ),
                const SizedBox(height: 10),
                ValidateTextField(
                  parent: this,
                  name: 'password',
                  labelText: AppLocalizations.of(context)!.password,
                  obscureText: true,
                  keyboardType: TextInputType.visiblePassword,
                  validators: [
                    FormBuilderValidators.required(),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              Expanded(
                child: SubmitButton(
                  onPressed: validateAndSubmit,
                  status: widget.status,
                  label: AppLocalizations.of(context)!.login,
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
