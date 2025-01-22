

final List<String> wordList = [
  "MEJA", "KURSI", "KUCING", "ANJING", "PINTU",
  "SEPEDA", "TELEVISI", "BURUNG", "IKAN", "MOBIL",
  "BUKU", "LAPTOP", "TOPI", "GELAS", "SENDOK",
  "PIRING", "LEMARI", "BOLA", "KAOS", "TAS",
  "MOTOR", "DOMPET", "KUDA", "JERAPAH", "GAJAH",
  "BANTAL", "KIPAS", "PISAU", "GUNTING", "LAMPU",
  "GAGAK", "MERPATI", "ELANG", "HIU", "BELUT",
  "KEPITING", "BEBEK", "SAPI", "KAMBING", "KELINCI",
  "KUDA", "KUMBANG",
];



final Map<String, List<String>> letterRules = {
  'P': ['D', 'B'],
  'B': ['D'],
  'D': ['B'],
  'C': ['O','D','Q'],
  'O': ['C','Q','D'],
  'R': ['P','B','B']
};