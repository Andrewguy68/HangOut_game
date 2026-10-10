import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_1/auth_service.dart';

class NavStart {
  @override

  Widget buildNavButton(BuildContext context, String label, Widget destination) { // Builds a navigation button widget which creates all of the needed elevated buttons for this code.
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: () {
        }, key: Key(label),
        child: Text(label),
      ),
    );
  }

   Widget buildLogButton(BuildContext context, String label, Widget destination) { // Builds a navigation button widget which creates all of the needed elevated buttons for this code.
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: () async {
          await AuthService().logIn('username', 'password');
        }, key: Key(label),
        child: Text(label),
      ),
    );
  }



    Widget buildSignButton(BuildContext context, String label, Widget destination) { // Builds a navigation button widget which creates all of the needed elevated buttons for this code.
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: ElevatedButton(
          onPressed: () async {
            await AuthService().signUp('username', 'password');
          }, key: Key(label),
          child: Text(label),
        ),
      );
    }
}