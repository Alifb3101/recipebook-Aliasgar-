import 'package:flutter/material.dart';
import '../../database/api/api.dart';
import '../../model/single_recipe.dart';

class SingleRecipe extends StatefulWidget {
  final int id;
  const SingleRecipe({super.key, required this.id});

  @override
  State<SingleRecipe> createState() => _SingleRecipeState();
}

class _SingleRecipeState extends State<SingleRecipe> {
  Singlerecipe recipe = Singlerecipe();

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    var data = await API().getsinglerecipes(widget.id);
    recipe = Singlerecipe.fromJson(data);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (recipe.name == null) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Colors.deepOrange),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.name!, style: TextStyle(fontWeight: FontWeight.w700 , color: Colors.white),),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding:  EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(recipe.image!),
            ),
             SizedBox(height: 16),
            Text(
              recipe.name!,
              style:  TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
             SizedBox(height: 8),
            Row(
              children: [
                 Icon(Icons.star, color: Colors.amber),
                 SizedBox(width: 4),
                Text("${recipe.rating} (${recipe.reviewCount} reviews)"),
              ],
            ),
             SizedBox(height: 8),
            Text("Cuisine: ${recipe.cuisine} • Difficulty: ${recipe.difficulty}"),
            Text("Prep: ${recipe.prepTimeMinutes} mins | Cook: ${recipe.cookTimeMinutes} mins"),
            Text("Calories/Serving: ${recipe.caloriesPerServing} • Servings: ${recipe.servings}"),
             SizedBox(height: 20),

            _sectionTitle("Ingredients"),
             SizedBox(height: 8),
            Column(
              children: recipe.ingredients!
                  .map((ing) => _bulletItem(ing))
                  .toList(),
            ),

             SizedBox(height: 20),
            _sectionTitle("Instructions"),
             SizedBox(height: 8),
            Column(
              children: List.generate(
                recipe.instructions!.length,
                    (index) => _numberedItem(index + 1, recipe.instructions![index]),
              ),
            ),

             SizedBox(height: 20),
            _sectionTitle("Tags"),
             SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: List.generate(
                recipe.tags!.length,
                    (index) => Chip(label: Text(recipe.tags![index])),
              ),
            ),

             SizedBox(height: 20),
            _sectionTitle("Meal Type"),
             SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: List.generate(
                recipe.mealType!.length,
                    (index) => Chip(
                  label: Text(recipe.mealType![index]),
                  backgroundColor: Colors.blue.shade100,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style:  TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
    );
  }

  Widget _bulletItem(String text) {
    return Padding(
      padding:  EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Text(" • ", style: TextStyle(fontSize: 16)),
          Expanded(child: Text(text, style:  TextStyle(fontSize: 16))),
        ],
      ),
    );
  }

  Widget _numberedItem(int number, String text) {
    return Padding(
      padding:  EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$number. ", style:  TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          Expanded(child: Text(text, style:  TextStyle(fontSize: 16))),
        ],
      ),
    );
  }
}