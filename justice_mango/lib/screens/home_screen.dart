import 'package:flutter/material.dart';
import 'package:justice_mango/app_theme.dart';
import 'package:justice_mango/screens/board_tab.dart';
import 'package:justice_mango/screens/explore_tab.dart';
import 'package:justice_mango/screens/favorite_tab.dart';
import 'package:justice_mango/screens/setting_tab.dart';

class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int selectedIndex;

  @override
  void initState() {
    super.initState();
    selectedIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: IndexedStack(
        index: selectedIndex,
        children: [
          BoardTab(
            homeScreenState: this,
          ),
          FavoriteTab(),
          ExploreTab(),
          SettingTab(),
        ],
      ),
      bottomNavigationBar: SizedBox(
        height: 40,
        child: BottomNavigationBar(
          iconSize: 15,
          selectedFontSize: 10,

          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.system_update_tv_rounded,
              ),
              label: 'Cập nhật',
              backgroundColor: mainColor,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.my_library_books_rounded),
              label: 'Ưa thích',
              //backgroundColor: Colors.green,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.explore_rounded),
              label: 'Khám phá',
              //backgroundColor: Colors.purple,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_applications_rounded),
              label: 'Cài đặt',
              //backgroundColor: Colors.pink,
            ),
          ],
          currentIndex: selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped,
          //unselectedItemColor: Colors.blue,
        ),
      ),
    );
  }

  void _onItemTapped(int value) {
    setState(() {
      selectedIndex = value;
    });
  }
}
