import 'package:flutter/material.dart';

import 'package:flutter_application_1/Widget_Setup/widgit_build.dart';
import 'package:flutter_application_1/auth_service.dart';

/// username + password form shared by the Login and Signup pages.
/// It owns the text controllers, validation, the loading state and the error
/// message. What happens on submit is up to [onSubmit].
class AuthForm extends StatefulWidget {
  const AuthForm({
    super.key,
    required this.submitLabel,
    required this.onSubmit,
    this.usernameValidator,
    this.passwordValidator,
    this.footer = const <Widget>[],
  });

  final String submitLabel;
  final Future<void> Function(String username, String password) onSubmit;
  final FormFieldValidator<String>? usernameValidator;
  final FormFieldValidator<String>? passwordValidator;

  final List<Widget> footer;

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  final _username = TextEditingController();
  final _password = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_loading) return;
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await widget.onSubmit(_username.text, _password.text);
    } catch (e) {
      if (mounted) setState(() => _error = authErrorMessage(e));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: _username,
            enabled: !_loading,
            autocorrect: false,
            enableSuggestions: false,
            textInputAction: TextInputAction.next,
            validator: widget.usernameValidator,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Username',
              labelStyle: TextStyle(fontSize: 20),
            ),
          ),
          const SizedBox(height: 20.0),
          TextFormField(
            controller: _password,
            enabled: !_loading,
            obscureText: true,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _submit(),
            validator: widget.passwordValidator,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Password',
              labelStyle: TextStyle(fontSize: 20),
            ),
          ),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Text(
                _error!,
                key: const Key('auth-error'),
                textAlign: TextAlign.center,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          NavStart().buildActionButton(
            context,
            widget.submitLabel,
            _submit,
            loading: _loading,
            verticalPadding: 15.0,
          ),
          ...widget.footer,
        ],
      ),
    );
  }
}
