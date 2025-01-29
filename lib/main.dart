import 'package:dyslexiai/canvas/modeSelector.dart';
import 'package:dyslexiai/chatbot/chatbot.dart';
import 'package:dyslexiai/susunkata/modeSelector.dart';
import 'package:dyslexiai/training/trainingmain.dart';
import 'package:flutter/material.dart';
import 'package:dyslexiai/speechrecog.dart';

import 'data/user.dart';  // Add your ProfilePage import here

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

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {
  String? _username;
  int _experience = 0;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Load the username and experience data
  void _loadUserData() async {
    String? username = await GameData.getUsername();
    int experience = await GameData.getExperience();

    setState(() {
      _username = username;
      _experience = experience;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),  // Set height for top navbar
        child: AppBar(
          backgroundColor: Color(0xFFFDFCDC),
          title: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: AssetImage('assets/logo.jpeg'),  // Replace with user image
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_username ?? 'User Name', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),  // Replace with dynamic data
                    SizedBox(height: 5),
                    Text('Experience: $_experience XP', style: TextStyle(fontSize: 14)),  // Replace with dynamic data
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(  // Make the page scrollable
        child: Container(
          color: Color(0xFFFDFCDC),
          child: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // Latih Penulisan Huruf Button
                    SizedBox(
                      width: MediaQuery.of(context).size.width * (11 / 12),
                      height: 130,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => TrainingMain()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xDDFFB7D6),
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                          textStyle: TextStyle(fontSize: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(color: Colors.white, width: 2),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Latih Penulisan Huruf',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.black),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 30),
                                  Text(
                                    "Ikuti garis huruf yang diberikan untuk belajar menulis dengan benar!",
                                    style: TextStyle(fontSize: 14, color: Colors.black),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 10),
                            Image.asset('assets/3.png', height: 80, width: 80),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    // Ucapkan Huruf Button
                    SizedBox(
                      width: MediaQuery.of(context).size.width * (11 / 12),
                      height: 130,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SpeechToTextPage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xDDFFC571),
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                          textStyle: TextStyle(fontSize: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(color: Colors.white, width: 2),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Ucapkan Huruf',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.black),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 30),
                                  Text(
                                    "Ucapkan huruf dengan jelas untuk melatih pelafalan dan mengenali bunyi huruf!",
                                    style: TextStyle(fontSize: 14, color: Colors.black),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 10),
                            Image.asset('assets/1.png', height: 80, width: 80),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    // Tulis Kata Button
                    SizedBox(
                      width: MediaQuery.of(context).size.width * (11 / 12),
                      height: 130,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Canvaslobi()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xDDBCD0FF),
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                          textStyle: TextStyle(fontSize: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(color: Colors.white, width: 2),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Tulis Kata',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.black),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 30),
                                  Text(
                                    "Tulis ulang kata yang diberikan untuk melatih keterampilan menulis dan mengenali ejaan!",
                                    style: TextStyle(fontSize: 14, color: Colors.black),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 10),
                            Image.asset('assets/4.png', height: 80, width: 80),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    // Rangkai Kata Button
                    SizedBox(
                      width: MediaQuery.of(context).size.width * (11 / 12),
                      height: 130,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Susunkatalobi()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xDD96FF70),
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                          textStyle: TextStyle(fontSize: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(color: Colors.white, width: 2),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Rangkai Kata',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.black),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 30),
                                  Text(
                                    "Dengar kata yang diucapkan dan susun hurufnya untuk membentuk kata yang benar!",
                                    style: TextStyle(fontSize: 14, color: Colors.black),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 10),
                            Image.asset('assets/2.png', height: 80, width: 80),
                          ],
                        ),
                      ),
                    ),


                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.blue,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(Icons.report),
                color: Colors.white,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SpeechToTextPage()), // Add your report page navigation
                  );
                },
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10, spreadRadius: 2)],
                ),
                child: IconButton(
                  icon: Icon(Icons.home),
                  color: Colors.blue,
                  onPressed: () {
                    // Placeholder for home button action
                  },
                ),
              ),
              IconButton(
                icon: Icon(Icons.person),
                color: Colors.white,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SpeechToTextPage()), // Add your profile page navigation
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Chatbot()), // Replace with your chatbot page
          );
        },
        child: Icon(Icons.chat),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
