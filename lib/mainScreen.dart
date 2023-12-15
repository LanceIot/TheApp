import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_app/controllers/mainscreen_provider.dart';
import 'package:the_app/homePage.dart';
import 'package:the_app/managers/FirebaseManager.dart';
import 'package:the_app/models/Product.dart';
import 'package:the_app/searchPage.dart';
import 'package:the_app/shared/botom_nav_widget.dart';
import 'package:the_app/userPage.dart';
import 'package:the_app/MyStatefulWidget.dart';

class MainScreen extends StatelessWidget {
  MainScreen({super.key});


  List<Widget> pageList = [HomePage(), MyStatefulWidget(), UserPage()];

  @override
  Widget build(BuildContext context) {

    return Consumer<MainScreenNotifier>(
      builder: (context, mainScreenNotifier, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: pageList[mainScreenNotifier.pageIndex],
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BottomNavWidget(
                      onTap: () {
                        mainScreenNotifier.pageIndex = 0;
                      },
                      icon: mainScreenNotifier.pageIndex == 0 ? const Icon(Icons.home_filled, color: Colors.white) : const Icon(Icons.home_filled, color: Colors.grey),
                    ),
                    BottomNavWidget(
                      onTap: () {
                        mainScreenNotifier.pageIndex = 1;
                      },
                      icon: mainScreenNotifier.pageIndex == 1 ? const Icon(Icons.shopping_basket, color: Colors.white) : const Icon(Icons.shopping_basket_outlined, color: Colors.grey),
                    ),
                    BottomNavWidget(
                      onTap: () {
                        mainScreenNotifier.pageIndex = 2;
                      },
                      icon: mainScreenNotifier.pageIndex == 2 ? const Icon(Icons.person, color: Colors.white) : const Icon(Icons.person, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}


