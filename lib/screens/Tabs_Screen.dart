import 'package:flutter/material.dart';
import 'package:meal_app/providers/Language_Provider.dart';
import 'package:meal_app/providers/Meal_provider.dart';
import 'package:meal_app/providers/Theme_Provider.dart';
import 'package:meal_app/screens/Categories_Screen.dart';
import 'package:meal_app/screens/Favorite_Screen.dart';
import 'package:meal_app/widgets/Main_Drawer.dart';
import 'package:provider/provider.dart';

class TabsScreen extends StatefulWidget {
  static const routeName = 'tabs_screen';
  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  List<Map<String, Object>> _pages = [];
  int _selectedPageIndex = 0;

  @override
  void initState() {
    Provider.of<MealProvider>(context, listen: false).getData();
    Provider.of<ThemeProvider>(context, listen: false).getThemeMode();
    Provider.of<ThemeProvider>(context, listen: false).getThemeColors();
    Provider.of<LanguageProvider>(context, listen: false).getLan();
    super.initState();
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var lan = Provider.of<LanguageProvider>(context, listen: true);
    _pages = [
      {
        'page':CategoriesScreen(),
        'title': lan.getTexts('categories'),
      },
      {
        'page': FavoritesScreen(),
        'title': lan.getTexts('your_favorites'),
      },
    ];
    return Directionality(
      textDirection: lan.isEn ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
        appBar:
            AppBar(title: Text(_pages[_selectedPageIndex]['title'].toString())),
        body: _pages[_selectedPageIndex]['page'] as Widget,
        bottomNavigationBar: BottomNavigationBar(
          onTap: _selectPage,
          backgroundColor: Theme.of(context).colorScheme.primary,
          selectedItemColor: Theme.of(context).colorScheme.secondary,
          unselectedItemColor: Colors.white,
          currentIndex: _selectedPageIndex,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.category),
              label: lan.getTexts('categories').toString(),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.star),
              label: lan.getTexts('your_favorites').toString(),
            ),
          ],
        ),
        drawer: MainDrawer(),
      ),
    );
  }
}