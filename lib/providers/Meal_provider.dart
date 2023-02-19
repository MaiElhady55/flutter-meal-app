import 'package:flutter/cupertino.dart';
import 'package:meal_app/models/Category.dart';
import 'package:meal_app/models/Meal.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../dummy_data.dart';

class MealProvider with ChangeNotifier {
  Map<String, bool> filters = {
    ' gluten ': false,
    'lactose': false,
    'vegan': false,
    'vegetarian': false,
  };

  List<Meal> aviliblemeals = DUMMY_MEALS;
  List<Meal> favoritemeals = [];
  List<String> prefsMealId = [];
  List<Category> aviliblecategories = [];

  void selffilters() async {
    aviliblemeals = DUMMY_MEALS.where((meal) {
      if ((filters['gluten']! && !meal.isGlutenFree)) {
        return false;
      }
      if (filters['lactose']! && !meal.isLactoseFree) {
        return false;
      }
      if (filters['vegan']! && !meal.isVegan) {
        return false;
      }
      if (filters['vegetarian']! && !meal.isVegetarian) {
        return false;
      }
      return true;
    }).toList();

/******************************************************** */
    List<Category> ac = [];
    aviliblemeals.forEach((meal) {
      meal.categories.forEach((catId) {
        DUMMY_CATEGORIES.forEach((cat) {
          if (cat.id == catId) {
            if (!ac.any((cat) => cat.id == catId)) ac.add(cat);
          }
          ;
        });
      });
    });
    aviliblecategories = ac;
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('gluten', filters['gluten']!);
    prefs.setBool('lactose', filters['lactose']!);
    prefs.setBool('vegan', filters['vegan']!);
    prefs.setBool('vegetarian', filters['vegetarian']!);
  }

  void getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    filters['gluten'] = prefs.getBool('gluten') ?? false;
    filters['lactose'] = prefs.getBool('lactose') ?? false;
    filters['vegan'] = prefs.getBool('vegan') ?? false;
    filters['vegetarian'] = prefs.getBool('vegetarian') ?? false;
    //favoritesMeals
    prefsMealId = prefs.getStringList('prefsMealId') ?? [];
    for (var mealid in prefsMealId) {
      final exisitngindex =
          favoritemeals.indexWhere((meal) => meal.id == mealid);
      if (exisitngindex < 0) {
        favoritemeals.add(DUMMY_MEALS.firstWhere((meal) => meal.id == mealid));
      }

      List<Meal> fm = [];
      // ignore: missing_return
      favoritemeals.forEach((favmeals) {
        aviliblemeals.forEach((avmeals) {
          if (favmeals.id == avmeals.id) fm.add(favmeals);
        });
      });
      favoritemeals = fm;
      notifyListeners();
    }

    notifyListeners();
  }

  void togglefavorites(String mealid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // ignore: missing_return
    final visitingindex = favoritemeals.indexWhere((meal) => meal.id == mealid);

    if (visitingindex >= 0) {
      favoritemeals.removeAt(visitingindex);
      prefsMealId.remove(mealid);
    } else {
      favoritemeals.add(DUMMY_MEALS.firstWhere((meal) => meal.id == mealid));
      prefsMealId.add(mealid);
    }
    notifyListeners();
    prefs.setStringList('prefsMealId', prefsMealId);
  }

  bool isfavoritemeal(String id) {
    return favoritemeals.any((meal) => meal.id == id);
  }
}
