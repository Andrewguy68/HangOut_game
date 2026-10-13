import 'dart:async';

import 'package:flutter_application_1/Storage/word_storage.dart';

class FakeWordStorage implements WordStorage {
  FakeWordStorage({this.lastSubmission});

  DateTime? lastSubmission;

  final List<(String, String)> saves = [];

  Object? lookupError;
  Object? saveError;

  Completer<void>? holdSave;

  @override
  Future<DateTime?> lastSubmittedAt(String uid) async {
    final error = lookupError;
    if (error != null) throw error;
    return lastSubmission;
  }

  @override
  Future<void> saveWord({required String uid, required String word}) async {
    saves.add((uid, word));
    await holdSave?.future;
    final error = saveError;
    if (error != null) throw error;
  }
}
