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
                width: 20,
                height: 20,
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
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            '1. \n2. \n3. \n4. \n5. \n6. \n7. \n8. \n9. \n10.',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
    );
  }
}
