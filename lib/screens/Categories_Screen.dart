import 'package:flutter/material.dart';
import 'package:meal_app/providers/Meal_provider.dart';
import 'package:meal_app/widgets/Category_item.dart';
import 'package:provider/provider.dart';

class CategoriesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView(
        padding: EdgeInsets.all(25),
        children: Provider.of<MealProvider>(context)
            .aviliblecategories
            .map(
              (catData) => CategoryItem(catData.id, catData.color),
            )
            .toList(),
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
      ),
    );
  }
}
