import 'dart:math';
import 'package:dyslexiai/data/user.dart';



final List<String> wordList = [
  "MEJA", "KURSI", "KUCING", "PINTU",
  "SEPEDA", "TELEVISI", "BURUNG", "IKAN", "MOBIL",
  "BUKU", "LAPTOP", "TOPI", "GELAS", "SENDOK",
  "PIRING", "LEMARI", "BOLA", "KAOS", "TAS",
  "MOTOR", "DOMPET", "KUDA", "JERAPAH", "GAJAH",
  "BANTAL", "KIPAS", "PISAU", "GUNTING", "LAMPU",
  "GAGAK", "MERPATI", "ELANG", "HIU", "BELUT",
  "KEPITING", "BEBEK", "SAPI", "KAMBING", "KELINCI",
  "KUDA", "KUMBANG", "SERIGALA", "ULAR", "HARIMAU",
  "SINGA", "ZEBRA", "BADAK", "AYAM", "BERUANG",
  "RUSA", "ANJING", "KAKTUS", "JAM", "RADIO",
  "PAYUNG", "SEPATU", "SANDAL", "CELANA", "BAJU",
  "PAKU", "PALU", "GITAR", "PIANO", "DRUM",
  "SERULING", "KERETA", "PESAWAT", "PERAHU", "TRUK",
  "HELIKOPTER", "BATERAI", "KABEL", "CHARGER", "HANDPHONE",
  "JAKET", "SARUNG", "SARUNG TANGAN", "SYAL", "SABUK",
  "KUNCI", "OBENG", "SEKOP", "CANGKUL", "SAPU",
  "EMBER", "KERANJANG", "TAPLAK", "KARPET", "GAMBAR",
  "KALENDER", "JAM DINDING", "TERMOS", "POMPA", "KERTAS",
  "PENSIL", "PENGHAPUS", "PENGGARIS", "KAMERA", "TRIPOD",
  "MIKROFON"
];

Future<List<String>> kataYangSeringSalah() async {
  List<MapEntry<String, int>> top3Misspelled = await GameData.getTopThreeMisspelled();

  // Extract the top 3 letters, e.g., ['A', 'B', 'C']
  List<String> topLetters = top3Misspelled.map((e) => e.key).toList();

  List<String> prioritizedWords = [];
  Random random = Random();

  for (String word in wordList) {
    // Check if the word contains any of the top 3 letters
    bool containsTopLetter = topLetters.any((letter) => word.contains(letter));

    if (containsTopLetter) {
      // Add words containing top letters multiple times (weighted probability)
      int frequency = 3 + random.nextInt(3);  // Add 3-5 times
      for (int i = 0; i < frequency; i++) {
        prioritizedWords.add(word);
      }
    } else {
      // Add normal words with lower frequency
      prioritizedWords.add(word);
    }
  }

  // Shuffle the final list to randomize word order
  prioritizedWords.shuffle();

  return prioritizedWords;
}


final Map<String, List<String>> letterRules = {
  'P': ['D', 'B', 'R'],
  'B': ['D','P','R'],
  'D': ['B','O','C'],
  'C': ['O','D','Q'],
  'O': ['C','Q','D'],
  'R': ['P','B','B'],
  'W': ['V','U'],
  'V': ['W','U'],
  'U': ['V','W'],
  'I': ['Y','J','L'],
  'Y': ['I','J'],
  'J': ['I','Y'],
};