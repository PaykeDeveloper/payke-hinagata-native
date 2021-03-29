import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:native_app/store/base/models/state_result.dart';
import 'package:native_app/store/base/models/store_state.dart';
import 'package:native_app/store/state/app/login/models/login_input.dart';
import 'package:native_app/store/state/app/login/notifier.dart';
import 'package:native_app/ui/widgets/atoms/logo.dart';
import 'package:native_app/ui/widgets/atoms/submit_button.dart';
import 'package:native_app/ui/widgets/atoms/validate_form_state.dart';
import 'package:native_app/ui/widgets/atoms/validate_text_field.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: LoginForm());
  }
}

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends ValidateFormState<LoginForm> {
  @override
  Future<StateResult> onSubmit() async {
    final email = formKey.currentState?.value['email'] as String;
    final password = formKey.currentState?.value['password'] as String;
    final notifier = context.read<LoginNotifier>();
    return notifier.login(LoginInput(
      email: email,
      password: password,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final status = context.select((StoreState<Login> state) => state.status);
    return Padding(
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
              children: <Widget>[
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
            children: <Widget>[
              Expanded(
                child: SubmitButton(
                  onPressed: validateAndSubmit,
                  status: status,
                  label: AppLocalizations.of(context)!.login,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
