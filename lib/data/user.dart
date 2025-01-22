import 'package:shared_preferences/shared_preferences.dart';

class GameData {
  // Update misspelled letters by adding values to the existing ones
  static Future<void> updateMisspelledLetters(Map<String, int> newData) async {
    final prefs = await SharedPreferences.getInstance();

    // Load existing data
    Map<String, int> existingData = await loadMisspelledLetters();

    // Merge new data by adding values to existing ones
    newData.forEach((letter, count) {
      existingData[letter] = (existingData[letter] ?? 0) + count;
    });

    // Save the updated values
    existingData.forEach((letter, count) {
      prefs.setInt('misspelled_$letter', count);
    });
  }

  // Load the misspelled letters from SharedPreferences
  static Future<Map<String, int>> loadMisspelledLetters() async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, int> misspelledLetters = {};

    for (String letter in List.generate(26, (index) => String.fromCharCode(index + 65))) {
      int? count = prefs.getInt('misspelled_$letter');
      if (count != null) {
        misspelledLetters[letter] = count;
      }
    }
    return misspelledLetters;
  }

  // Clear all misspelled letters data
  static Future<void> clearGameData() async {
    final prefs = await SharedPreferences.getInstance();
    for (String letter in List.generate(26, (index) => String.fromCharCode(index + 65))) {
      await prefs.remove('misspelled_$letter');
    }
  }
}
