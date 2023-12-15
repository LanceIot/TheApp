import 'package:flutter/material.dart';

class AboutRestPage extends StatelessWidget {
  const AboutRestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "McDonald's",
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
            children: [
              Image.asset(
                "images/1.jpg",
                fit: BoxFit.fitHeight,
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: EdgeInsets.only(left: 15),
                child: Container(
                  height: 60,
                  width: MediaQuery.of(context).size.width,
                  child: GridView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 15,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1, mainAxisSpacing: 5.0),
                    itemBuilder: (context, index) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Container(
                          width: 50,
                          color: (index == 0) ? Colors.grey : Colors.white,
                          child: Center(
                            child: Text(
                              "Promo",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              
            ],
          ),
      ),
    );
  }
}
