import 'package:flutter/material.dart';

import 'package:flutter_application_1/Storage/word_rules.dart';
import 'package:flutter_application_1/Storage/word_scope.dart';
import 'package:flutter_application_1/Storage/word_service.dart';

/// Opens the "add your word" dialog. Completes with the word that was saved,
/// or null if the player cancelled.
Future<String?> showAddWordDialog(BuildContext context) {
  return showDialog<String>(
    context: context,
    barrierDismissible: false,
    builder: (_) => const AddWordDialog(),
  );
}

class AddWordDialog extends StatefulWidget {
  const AddWordDialog({super.key});

  @override
  State<AddWordDialog> createState() => _AddWordDialogState();
}

class _AddWordDialogState extends State<AddWordDialog> {
  final _controller = TextEditingController();
  bool _loading = false;
  bool _done = false;
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_loading) return;
    final words = WordScope.of(context);
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final saved = await words.submitWord(_controller.text);
      if (!mounted) return;
      _done = true;
      Navigator.of(context).pop(saved);
    } catch (e) {
      if (mounted) setState(() => _error = wordErrorMessage(e));
    } finally {
      // Once we've popped, leave the (fading out) dialog alone so it can't be
      // submitted a second time.
      if (mounted && !_done) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add your word'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pick a real word (${WordRules.minLength}-${WordRules.maxLength} '
            'letters). You can add one new word every 24 hours.',
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            enabled: !_loading,
            autofocus: true,
            autocorrect: false,
            enableSuggestions: false,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _submit(),
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: 'Your word',
              errorText: _error,
              errorMaxLines: 3,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          key: const Key('Cancel'),
          onPressed: _loading ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          key: const Key('Submit Word'),
          onPressed: _loading ? null : _submit,
          child: _loading
              ? const SizedBox(
                  width: 15,
                  height: 15,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Submit'),
        ),
      ],
    );
  }
}
