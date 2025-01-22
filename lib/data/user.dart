import 'package:shared_preferences/shared_preferences.dart';

class GameData {
  // Save misspelled letters with their counts (like A=20, B=2, etc.)
  static Future<void> saveMisspelledLetters(Map<String, int> misspelledLetters) async {
    // Get the instance of SharedPreferences to save data
    final prefs = await SharedPreferences.getInstance();

    // Loop through each letter and save the misspelled count in SharedPreferences
    misspelledLetters.forEach((letter, count) {
      prefs.setInt('misspelled_$letter', count); // Store count with the key 'misspelled_A', 'misspelled_B', etc.
    });
  }

  // Load the misspelled letters data from SharedPreferences
  static Future<Map<String, int>> loadMisspelledLetters() async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, int> misspelledLetters = {}; // Initialize an empty map to store the result

    // Loop through letters A to Z (A=65 to Z=90 in ASCII code)
    for (String letter in List.generate(26, (index) => String.fromCharCode(index + 65))) {
      // Check if the letter has a saved misspelled count
      int? count = prefs.getInt('misspelled_$letter');

      // If there's a count, add it to the map
      if (count != null) {
        misspelledLetters[letter] = count;
      }
    }
    return misspelledLetters; // Return the map of misspelled letters and their counts
  }

  // Save the list of unlocked levels (e.g., "type Darat level 1")
  static Future<void> saveLevelsUnlocked(List<String> levels) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('levels_unlocked', levels); // Store the list of unlocked levels
  }

  // Load the unlocked levels from SharedPreferences
  static Future<List<String>> loadLevelsUnlocked() async {
    final prefs = await SharedPreferences.getInstance();
    // Get the list of unlocked levels, if it exists, or return an empty list
    return prefs.getStringList('levels_unlocked') ?? [];
  }

  // Clear all the game data (misspelled letters and unlocked levels)
  static Future<void> clearGameData() async {
    final prefs = await SharedPreferences.getInstance();

    // Remove all saved misspelled letters (from 'misspelled_A' to 'misspelled_Z')
    for (String letter in List.generate(26, (index) => String.fromCharCode(index + 65))) {
      await prefs.remove('misspelled_$letter'); // Remove each misspelled letter key
    }

    // Remove the saved list of unlocked levels
    await prefs.remove('levels_unlocked');
  }
}
