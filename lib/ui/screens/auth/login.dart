import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:native_app/store/base/models/store_result.dart';
import 'package:native_app/store/base/models/store_state.dart';
import 'package:native_app/store/state/app/login/notifier.dart';
import 'package:native_app/ui/widgets/atoms/logo.dart';
import 'package:native_app/ui/widgets/atoms/submit_button.dart';
import 'package:native_app/ui/widgets/atoms/validate_form_state.dart';
import 'package:native_app/ui/widgets/atoms/validate_text_field.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future<StoreResult> onSubmit(String email, String password) async {
      final notifier = context.read<LoginNotifier>();
      return notifier.login(email, password);
    }

    final status = context.select((LoginState state) => state.status);

    return Scaffold(
      body: Login(
        onSubmit: onSubmit,
        status: status,
      ),
    );
  }
}

typedef _OnSubmit = Future<StoreResult> Function(String email, String password);

class Login extends StatefulWidget {
  const Login({
    required _OnSubmit onSubmit,
    required StateStatus status,
  })  : _onSubmit = onSubmit,
        _status = status;
  final _OnSubmit _onSubmit;
  final StateStatus _status;

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends ValidateFormState<Login> {
  @override
  Future<StoreResult> onSubmit() async {
    final email = formKey.currentState!.value['email'] as String;
    final password = formKey.currentState!.value['password'] as String;
    return widget._onSubmit(email, password);
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
            child: Logo(),
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
                    FormBuilderValidators.required(context),
                    FormBuilderValidators.email(context),
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
                    FormBuilderValidators.required(context),
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
                  status: widget._status,
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
