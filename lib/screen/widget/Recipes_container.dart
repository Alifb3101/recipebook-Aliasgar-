import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recipes_api/model/all_recipes_fetch.dart';
import '../pages/single_recipes_page.dart';
import 'Text_widget.dart';

class All_recipes extends StatelessWidget {
  final List<Recipes> recipe;

  const All_recipes({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: recipe.map((item) {
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SingleRecipe(id: item.id!)),
            );
          },
          child: Container(
            margin:  EdgeInsets.symmetric(vertical: 10, horizontal: 4),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFE0C3FC), Color(0xFF8EC5FC)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.indigo.withOpacity(0.2),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                )
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Card(
                color: Colors.white.withOpacity(0.9),
                elevation: 5,
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding:  EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.network(
                          item.image ?? '',
                          width: double.infinity,
                          height: 180,
                          fit: BoxFit.cover,
                        ),
                      ),
                       SizedBox(height: 10),
                      TextWidget(
                        Text: item.name ?? '',
                        fontsize: 20,
                        fw: FontWeight.bold,
                        fontcolour: Colors.indigo.shade800,
                      ),
                      TextWidget(
                        Text: 'Cuisine: ${item.cuisine}',
                        fontsize: 14,
                        fw: FontWeight.w500,
                        fontcolour: Colors.grey.shade700,
                      ),
                       SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          TextWidget(
                            Text: '🧑‍🍳 Prep: ${item.prepTimeMinutes} min',
                            fontsize: 13,
                            fw: FontWeight.w400,
                          ),
                           SizedBox(width: 15),
                          TextWidget(
                            Text: '🍳 Cook: ${item.cookTimeMinutes} min',
                            fontsize: 13,
                            fw: FontWeight.w400,
                          ),
                        ],
                      ),
                       SizedBox(height: 8),
                      Wrap(
                        spacing: 5,
                        children: (item.mealType ?? []).map((tag) {
                          return Chip(
                            label: Text(tag, style: TextStyle(fontSize: 10),),
                            backgroundColor: Colors.indigo.shade50,
                            side: BorderSide(color: Colors.indigo.shade300),
                            labelStyle: TextStyle(color: Colors.indigo.shade700, fontWeight: FontWeight.w600),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}