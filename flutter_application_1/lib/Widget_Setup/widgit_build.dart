
import 'package:flutter/material.dart';

class NavStart {
  Widget buildNavButton(
    BuildContext context,
    String label,
    Widget destination,
  ) {
    // Builds a navigation button widget which creates all of the needed elevated buttons for this code.
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => destination),
          );
        },
        key: Key(label),
        child: Text(label),
      ),
    );
  }

  /// builds button that runs [onPressed] (log in, sign up, sign out).
  /// while [loading] it is disabled and shows a spinner instead of the label.
  Widget buildActionButton(
    BuildContext context,
    String label,
    VoidCallback? onPressed, {
    bool loading = false,
    double verticalPadding = 8.0,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: verticalPadding),
      child: ElevatedButton(
        onPressed: loading ? null : onPressed,
        key: Key(label),
        child: loading
            ? const SizedBox(
                width: 15,
                height: 15,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Text(label),
      ),
    );
  }


Widget letterInput(BuildContext context, String label, Widget destination) { // Builds a navigation button widget which creates all of the needed elevated buttons for this code.
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 5.0), // good for now, implement with logic later
    child: ElevatedButton(
      onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => destination),
        );
      }, key: Key(label),
      child: Text(label),
    ),
  );
}

  Widget Solve(BuildContext context, String label, Widget destination) {
    // Builds a navigation button widget which creates all of the needed elevated buttons for this code.
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 5.0,
      ), // good for now, implement with logic later
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => destination),
          );
        },
        key: Key(label),
        child: Text(label),
      ),
    );
  }
}
