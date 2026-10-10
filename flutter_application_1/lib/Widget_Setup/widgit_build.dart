import 'package:flutter/material.dart';

class NavStart {
  @override

  Widget buildNavButton(BuildContext context, String label, Widget destination) { // Builds a navigation button widget which creates all of the needed elevated buttons for this code.
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => destination),
          );
        }, key: Key(label),
        child: Text(label),
      ),
    );
  }
}