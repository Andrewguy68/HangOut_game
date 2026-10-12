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
          Navigator.push(
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

  Widget rectangle(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            '1. \n2. \n3. \n4. \n5.',
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
      ),
    );
  }

Widget letterInput(BuildContext context, String label, Widget destination) { // Builds a navigation button widget which creates all of the needed elevated buttons for this code.
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0), // good for now, implement with logic later
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

Widget Solve(BuildContext context, String label, Widget destination) { // Builds a navigation button widget which creates all of the needed elevated buttons for this code.
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0), // good for now, implement with logic later
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
