import 'package:dyslexiai/canvas/modeSelector.dart';
import 'package:dyslexiai/chatbot/chatbot.dart';
import 'package:dyslexiai/susunkata/modeSelector.dart';
import 'package:dyslexiai/training/trainingmain.dart';
import 'package:flutter/material.dart';
import 'package:dyslexiai/speechrecog.dart';
import 'package:dyslexiai/canvas/canvas.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Navigation Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}



class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home Page')),
      body: Container(
        color: Color(0xFFFDFCDC), // Change background color here
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[


                  SizedBox(
                    width: MediaQuery.of(context).size.width * (11 / 12), // Keep width at 11/12 of screen
                    height: 130, // Reduce height to make it more rectangular
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => TrainingMain()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xDDFFB7D6),
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15), // Adjust padding
                        textStyle: TextStyle(fontSize: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20), // Rounded corners
                          side: BorderSide(color: Colors.white, width: 2), // White border with width of 2
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Push text left & image right
                        crossAxisAlignment: CrossAxisAlignment.center, // Align items properly
                        children: [
                          // Wrap text inside Flexible to prevent overflow
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start, // Align text left
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Latih Penulisan Huruf',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.black),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 30), // Reduce extra spacing for better balance
                                Text(
                                  "Ikuti garis huruf yang diberikan untuk belajar menulis dengan benar!",
                                  style: TextStyle(fontSize: 14, color: Colors.black),
                                  maxLines: 2, // Allow text wrapping
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 10), // Add spacing between text and image
                          Image.asset(
                            'assets/logo.jpeg', // Replace with your image path
                            height: 80, // Reduce image size for better balance
                            width: 80,
                          ),
                        ],
                      ),
                    ),
                  ),





                  SizedBox(height: 20),

                  SizedBox(
                    width: MediaQuery.of(context).size.width * (11 / 12), // Keep width at 11/12 of screen
                    height: 130, // Reduce height to make it more rectangular
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SpeechToTextPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xDDFFC571),
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15), // Adjust padding
                        textStyle: TextStyle(fontSize: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20), // Rounded corners
                          side: BorderSide(color: Colors.white, width: 2), // White border with width of 2
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Push text left & image right
                        crossAxisAlignment: CrossAxisAlignment.center, // Align items properly
                        children: [
                          // Wrap text inside Flexible to prevent overflow
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start, // Align text left
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Ucapkan Huruf',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.black),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 30), // Reduce extra spacing for better balance
                                Text(
                                  "Ucapkan huruf dengan jelas untuk melatih pelafalan dan mengenali bunyi huruf!",
                                  style: TextStyle(fontSize: 14, color: Colors.black),
                                  maxLines: 2, // Allow text wrapping
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 10), // Add spacing between text and image
                          Image.asset(
                            'assets/logo.jpeg', // Replace with your image path
                            height: 80, // Reduce image size for better balance
                            width: 80,
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 20),



                  SizedBox(
                    width: MediaQuery.of(context).size.width * (11 / 12), // Keep width at 11/12 of screen
                    height: 130, // Reduce height to make it more rectangular
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Canvaslobi()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xDDBCD0FF),
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15), // Adjust padding
                        textStyle: TextStyle(fontSize: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20), // Rounded corners
                          side: BorderSide(color: Colors.white, width: 2), // White border with width of 2
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Push text left & image right
                        crossAxisAlignment: CrossAxisAlignment.center, // Align items properly
                        children: [
                          // Wrap text inside Flexible to prevent overflow
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start, // Align text left
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Tulis Kata',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.black),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 30), // Reduce extra spacing for better balance
                                Text(
                                  "Tulis ulang kata yang diberikan untuk melatih keterampilan menulis dan mengenali ejaan!",
                                  style: TextStyle(fontSize: 14, color: Colors.black),
                                  maxLines: 2, // Allow text wrapping
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 10), // Add spacing between text and image
                          Image.asset(
                            'assets/logo.jpeg', // Replace with your image path
                            height: 80, // Reduce image size for better balance
                            width: 80,
                          ),
                        ],
                      ),
                    ),
                  ),



                  SizedBox(height: 20),



                  SizedBox(
                    width: MediaQuery.of(context).size.width * (11 / 12), // Keep width at 11/12 of screen
                    height: 130, // Reduce height to make it more rectangular
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Susunkatalobi()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xDD96FF70),
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15), // Adjust padding
                        textStyle: TextStyle(fontSize: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20), // Rounded corners
                          side: BorderSide(color: Colors.white, width: 2), // White border with width of 2
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Push text left & image right
                        crossAxisAlignment: CrossAxisAlignment.center, // Align items properly
                        children: [
                          // Wrap text inside Flexible to prevent overflow
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start, // Align text left
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Rangkai Kata',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.black),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 30), // Reduce extra spacing for better balance
                                Text(
                                  "Dengar kata yang diucapkan dan susun hurufnya untuk membentuk kata yang benar!",
                                  style: TextStyle(fontSize: 14, color: Colors.black),
                                  maxLines: 2, // Allow text wrapping
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 10), // Add spacing between text and image
                          Image.asset(
                            'assets/logo.jpeg', // Replace with your image path
                            height: 80, // Reduce image size for better balance
                            width: 80,
                          ),
                        ],
                      ),
                    ),
                  ),



                ],
              ),
            ),
            Positioned(
              top: 20, // Distance from the top
              right: 20, // Distance from the right
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Chatbot()),
                  );
                },
                backgroundColor: Colors.blue,
                child: Image.asset('assets/logo.jpeg'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
