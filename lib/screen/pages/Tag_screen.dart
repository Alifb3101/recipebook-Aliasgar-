import 'package:flutter/material.dart';
import 'package:recipes_api/responsive.dart';
import '../../database/api/api.dart';
import '../../model/tag_item_model.dart';
import 'single_recipes_page.dart';

class TagScreen extends StatefulWidget {
  const TagScreen({super.key});

  @override
  State<TagScreen> createState() => _TagScreenState();
}

class _TagScreenState extends State<TagScreen> {
  List<String> tags = [];
  String? selectedTag;
  int selectedIndex = 0;

  List<Recipes> recipes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTags();
  }

  fetchTags() async {
    try {
      var tagList = await API().getagitem();
      setState(() {
        tags = List<String>.from(tagList);
        selectedTag = tags.isNotEmpty ? tags[0] : null;
      });
      if (selectedTag != null) {
        fetchRecipesByTag(selectedTag!);
      }
    } catch (e) {
      debugPrint("Error fetching tags: $e");
    }
  }

  fetchRecipesByTag(String tag) async {
    setState(() => isLoading = true);
    try {
      final data = await API().getdetailsitembytag(tag);
      final tagModel = TagModel.fromJson(data);
      setState(() {
        recipes = tagModel.recipes ?? [];
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      debugPrint("Error fetching recipes: $e");
    }
  }

  void onTagSelected(int index) {
    setState(() {
      selectedIndex = index;
      selectedTag = tags[index];
    });
    fetchRecipesByTag(selectedTag!);
  }

  double getChildAspectRatio(double width) {
    if (width >= 1850) return 1.1;
    if (width >= 1700) return 1;
    if (width >= 1650) return 0.95;
    if (width >= 1500) return 0.85;
    if (width >= 1350) return 0.75;
    if (width >= 1200) return 0.65;
    if (width >= 1000) return 0.55;
    if (width >= 800) return 0.5;
    if (width >= 600) return 0.48;
    if (width >= 400) return 0.46;
    return 0.43;
  }

  int getCrossAxisCount(double width) {
    if (width >= 1600) return 4;
    if (width >= 1200) return 3;
    if (width >= 800) return 2;
    return 1;
  }

  double getFontSize(double width) {
    if (width >= 1600) return 18;
    if (width >= 1200) return 16;
    if (width >= 800) return 14;
    return 12;
  }

  double getImageHeight(double width) {
    if (width >= 1600) return 240;
    if (width >= 1200) return 200;
    if (width >= 800) return 170;
    return 140;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Recipes by Tag"),
        backgroundColor: Color(0xFFe0eafc),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFe0eafc), Color(0xFFcfdef3)],
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 100,
              color: Colors.blueGrey.withAlpha(80),
              child: tags.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                itemCount: tags.length,
                itemBuilder: (context, index) {
                  final isSelected = selectedIndex == index;
                  return GestureDetector(
                    onTap: () => onTagSelected(index),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      margin:
                      EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.white
                            : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? Colors.teal
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          tags[index],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color:
                            isSelected ? Colors.teal : Colors.black,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : recipes.isEmpty
                  ? Center(child: Text("No recipes found."))
                  : LayoutBuilder(
                builder: (context, constraints) {
                  double width = constraints.maxWidth;
                  int crossAxisCount = getCrossAxisCount(width);
                  double aspectRatio = getChildAspectRatio(width);
                  double imageHeight = getImageHeight(width);
                  double fontSize = getFontSize(width);

                  return GridView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: recipes.length,
                    gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      childAspectRatio: aspectRatio,
                    ),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SingleRecipe(
                              id: recipes[index].id!,
                            ),
                          ),
                        ),
                        child: RecipeCard(
                          recipe: recipes[index],
                          imageHeight: imageHeight,
                          fontSize: fontSize,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RecipeCard extends StatelessWidget {
  final Recipes recipe;
  final double imageHeight;
  final double fontSize;

  const RecipeCard({
    super.key,
    required this.recipe,
    required this.imageHeight,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(31, 0, 0, 0),
            blurRadius: 5,
            offset: Offset(2, 2),
          )
        ],
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius:
            BorderRadius.vertical(top: Radius.circular(12)),
            child: recipe.image != null
                ? Image.network(
              recipe.image!,
              height: imageHeight,
              width: double.infinity,
              fit: BoxFit.cover,
            )
                : SizedBox(height: imageHeight, child: Placeholder()),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.name ?? 'No Name',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: fontSize),
                  ),
                  SizedBox(height: 6),
                  if (recipe.mealType != null)
                    Text(
                      recipe.mealType!.join(', '),
                      style: TextStyle(
                          fontSize: fontSize - 2,
                          color: Colors.black87),
                    ),
                  Spacer(),
                  Row(
                    children: [
                      Icon(Icons.local_fire_department,
                          size: fontSize - 2, color: Colors.orange),
                      SizedBox(width: 6),
                      Text(
                        recipe.difficulty ?? 'Unknown',
                        style: TextStyle(
                            color: Colors.green,
                            fontSize: fontSize - 2),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}