import 'package:flutter/material.dart';
import 'package:restaurant_app/data/model/category_model.dart';

class CategoryRow extends StatelessWidget {
  final List<Category> categories;
  const CategoryRow({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    List<Widget> categoryWidgets = [];
    for (var i = 0; i < categories.length; i++) {
      categoryWidgets.add(
        Text(
          categories[i].name,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Colors.white),
        ),
      );
      if (i < categories.length - 1) {
        categoryWidgets.add(
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.0),
            child: Text('•', style: TextStyle(color: Colors.white)),
          ),
        );
      }
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: categoryWidgets,
    );
  }
}
