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
    if (width>= 3000) return 2.2;
    if (width>= 2900) return 2.19;
if (width>= 2500) return 2.2;
if (width>= 2000) return 2.3;
if(width >= 1850) return 2.4;
if(width >= 1700) return 2.5;
if(width >= 1650) return 2.6;
if(width >= 1500) return 2.6;
if (width>= 1400) return 2.7;
if (width >= 1350) return 2.8;
if (width >= 1200) return 2.9;

if (width >= 1100) return 3.0;
if(width>= 1000) return 3.1;
if (width>= 700) return 3.5;
if (width>= 600) return 3.9;
if (width>= 500) return 2.8;
if (width >= 400) return  3.7;
if (width>= 370) return 3.6;
if (width>= 350) return  3.4;
if (width>= 340) return 5.20;
if (width >= 300) return 5.30;
if (width >= 200) return 6.9;
  return 9.05;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text("Recipes by Tag"),
        backgroundColor: Color(0xFFe0eafc),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [Color(0xFFe0eafc), Color(0xFFcfdef3)],)
        ),
        child: Row(
          children: [

            Container(
              width: 100,
              color: Colors.blueGrey.withAlpha(80),
              child: tags.isEmpty
                  ?  Center(child: CircularProgressIndicator())
                  : ListView.builder(
                itemCount: tags.length,
                itemBuilder: (context, index) {
                  final isSelected = selectedIndex == index;
                  return GestureDetector(
                    onTap: () => onTagSelected(index),
                    child: Container(
                      padding:  EdgeInsets.symmetric(vertical: 16),
                      margin:  EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.white : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? Colors.teal : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          tags[index],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected ? Colors.teal : Colors.black,
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
                  ?  Center(child: CircularProgressIndicator())
                  : recipes.isEmpty
                  ?  Center(child: Text("No recipes found."))
                  : LayoutBuilder(
                builder: (context, constraints) {
                  double width = constraints.minWidth;
                  print('.......................====================--------------------==================$width');
                  return GridView.builder(
                    padding:  EdgeInsets.all(12),
                    itemCount: recipes.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: constraints.maxWidth > 600 ? 3 : 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 3 /getChildAspectRatio(width),
                    ),
                    itemBuilder: (context, index) {
                      return InkWell(
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SingleRecipe(id: recipes[index].id!,),)),
                          child: RecipeCard(recipe: recipes[index]));
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
  const RecipeCard({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow:  [
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
              borderRadius:  BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: recipe.image != null
                  ? Image.network(
                recipe.image!,
                height: getWidth(context) *0.20,
                width: double.infinity,
                fit: BoxFit.cover,
              )
                  : SizedBox(height: 50, child: Placeholder()),
            ),


            Expanded(
              child: Padding(
                padding:  EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipe.name ?? 'No Name',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style:  TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    if (recipe.mealType != null)
                      Text(
                        recipe.mealType!.join(', '),
                        style:  TextStyle(fontSize: 12, color: Colors.black87),
                      ),
                    Spacer(),
                    Row(
                      children: [
                        Icon(Icons.local_fire_department, size: 14, color: Colors.orange),
                        SizedBox(width: 4),
                        Text(
                          recipe.difficulty ?? 'Unknown',
                          style:  TextStyle(color: Colors.green, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

