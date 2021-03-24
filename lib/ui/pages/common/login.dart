import 'package:flutter/material.dart';
import 'package:native_app/models/app/login_input.dart';
import 'package:native_app/providers/app/login.dart';
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
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future _onSubmit() async {
    if (_formKey.currentState?.validate() == true) {
      _formKey.currentState?.save();
      final email = _emailController.text;
      final password = _passwordController.text;
      final loginProvider = context.read<LoginProvider>();
      await loginProvider.login(LoginInput(email: email, password: password));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: "Email", // ラベル
              hintText: 'Enter your email', // 入力ヒント
            ),
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Not good';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: "Password", // ラベル
              hintText: 'Enter your password', // 入力ヒント
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Not good';
              }
              return null;
            },
            onFieldSubmitted: (value) {
              _onSubmit();
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: ElevatedButton(
              onPressed: () {
                _onSubmit();
              },
              child: const Text('Submit'),
            ),
          )
        ],
      ),
    );
  }
}
