import 'package:cloud_firestore/cloud_firestore.dart';

class WordStorage {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  
  // stores word in database
  Future<void> addWord(String word, int failedAttempts) async{
    word = word.trim().toLowerCase();
    await db.collection('words').doc(word).set({"word": word, "failedAttempts": failedAttempts});
  }
  
  //checks to see if the word exists
  Future<bool> checkWord(String word) async {
    word = word.trim().toLowerCase();
    var wordCheck = await db.collection("words").doc(word).get();
    return wordCheck.exists;
  }

  //gets word from database
  Future<List<String>>  getWords() async{
    List<String> words = [];
    var wordList = await db.collection("words").get();
    for (var i in wordList.docs) {
      words.add(i["word"]);
    }
    return words;
  }

  //saves word results to database
  Future<void> saveWordResults(String username, String word, int failedAttempts) async{
    await db.collection("wordResults").add({"username": username, "word": word.trim().toLowerCase(), "failedAttempts": failedAttempts});
  }

  // retrieves results
  Future<Map<String,int>> getWordResults(String username) async{
    Map<String,int> results = {};
    var wordResult = await db.collection("wordResults").where("username", isEqualTo: username).get();
    for(var i in wordResult.docs){
      results[i["word"]] = i["failedAttempts"];
    }
    return results;
  }

}