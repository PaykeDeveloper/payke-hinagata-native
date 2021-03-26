import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:native_app/store/base/models/store_state.dart';
import 'package:native_app/store/state/app/login/models/login_input.dart';
import 'package:native_app/store/state/app/login/notifier.dart';
import 'package:native_app/ui/widgets/atoms/validate_form_state.dart';
import 'package:native_app/ui/widgets/atoms/validate_text_field.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  static String routeName = '/login';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login page')),
      body: LoginForm(),
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends ValidateFormState<LoginForm> {
  @override
  Future onSubmit() async {
    final email = formKey.currentState?.value['email'] as String;
    final password = formKey.currentState?.value['password'] as String;
    final notifier = context.read<LoginNotifier>();
    final result = await notifier.login(LoginInput(
      email: email,
      password: password,
    ));
    reflectResult(result);
  }

  @override
  Widget build(BuildContext context) {
    final status = context.select((StoreState<Login> state) => state.status);
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(10),
            child: const Text(
              'Test',
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.w500,
                fontSize: 30,
              ),
            ),
          ),
          FormBuilder(
            key: formKey,
            child: Column(
              children: <Widget>[
                ValidateTextField(
                  parent: this,
                  name: 'email',
                  labelText: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  validators: [
                    FormBuilderValidators.required(context),
                    FormBuilderValidators.email(context),
                  ],
                ),
                ValidateTextField(
                  parent: this,
                  name: 'password',
                  labelText: 'Password',
                  obscureText: true,
                  keyboardType: TextInputType.visiblePassword,
                  validators: [
                    FormBuilderValidators.required(context),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 50),
          Row(
            children: <Widget>[
              Expanded(
                child: MaterialButton(
                  onPressed:
                      status == StateStatus.started ? null : validateAndSubmit,
                  color: Theme.of(context).accentColor,
                  child: const Text(
                    "Submit",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
