import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:native_app/store/base/models/state_error.dart';
import 'package:native_app/store/base/models/store_state.dart';
import 'package:native_app/store/state/app/login/models/login_input.dart';
import 'package:native_app/store/state/app/login/notifier.dart';
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

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormBuilderState>();

  String? _emailError;
  String? _passwordError;

  Future onSubmit() async {
    final email = _formKey.currentState?.value['email'] as String;
    final password = _formKey.currentState?.value['password'] as String;
    final notifier = context.read<LoginNotifier>();
    await notifier.login(LoginInput(email: email, password: password));
    final error = context.read<StoreState<Login>>().error;
    if (error is BadRequest) {
      setState(() {
        final message = error.result.message;
        if (message != null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(message),
            backgroundColor: Theme.of(context).errorColor,
          ));
        }
        _emailError = error.result.errors?['email']?.join();
        _passwordError = error.result.errors?['password']?.join();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
            key: _formKey,
            child: Column(
              children: <Widget>[
                FormBuilderTextField(
                  name: 'email',
                  decoration: InputDecoration(
                    labelText: 'Email',
                    errorText: _emailError,
                  ),
                  onChanged: (value) => _emailError = null,
                  keyboardType: TextInputType.emailAddress,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(context),
                    FormBuilderValidators.email(context),
                  ]),
                ),
                FormBuilderTextField(
                  name: 'password',
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    errorText: _passwordError,
                  ),
                  onChanged: (value) => _passwordError = null,
                  keyboardType: TextInputType.visiblePassword,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(context),
                  ]),
                ),
              ],
            ),
          ),
          const SizedBox(height: 50),
          Row(
            children: <Widget>[
              Expanded(
                child: MaterialButton(
                  onPressed: () {
                    _formKey.currentState?.save();
                    if (_formKey.currentState?.validate() == true) {
                      onSubmit();
                    }
                  },
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
