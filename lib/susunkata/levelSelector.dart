import 'package:dyslexiai/susunkata/kataSelector.dart';
import 'package:flutter/material.dart';

class Susunkatalevelselector extends StatelessWidget {
  final List<Map<String, String>> categories = [
    {"title": "Hewan Darat  (Swipe ke kanan )", "type": "Darat"},
    {"title": "Hewan Laut", "type": "Laut"},
    {"title": "Hewan Udara", "type": "Udara"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Susunkatalobi'),
      ),
      body: Center(
        child: Container(
          height: 200,
          child: PageView.builder(
            itemCount: categories.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => kataSelector(type: categories[index]["type"]!),
                    ),
                  );
                },
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    alignment: Alignment.center,
                    child: Text(
                      categories[index]["title"]!,
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
