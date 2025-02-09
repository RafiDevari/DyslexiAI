import 'package:dyslexiai/susunkata/kataSelector.dart';
import 'package:flutter/material.dart';

class Susunkatalevelselector extends StatelessWidget {
  final List<Map<String, String>> categories = [
    {"title": "Hewan Darat  (Swipe ke kanan )", "type": "Darat", "image": "assets/darat.jpg"},
    {"title": "Hewan Laut", "type": "Laut", "image": "assets/laut.jpg"},
    {"title": "Hewan Udara", "type": "Udara", "image": "assets/udara.jpg"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mode Petualangan'),
      ),
      backgroundColor: Color(0xFFFDFCDC),
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
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(
                        image: AssetImage(categories[index]["image"]!),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        categories[index]["title"]!,
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
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
