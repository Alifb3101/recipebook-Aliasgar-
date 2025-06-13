import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recipes_api/database/api/api.dart';
import 'package:recipes_api/model/all_recipes_fetch.dart';
import '../widget/Recipes_container.dart';
import '../widget/Text_widget.dart';
import 'Add_recipe.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Recipes> recipe = [];
  TextEditingController searchController = TextEditingController();
  List meals = [];
  var currentOrder = 'asc';

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    var data = await API().getrecipesList();
    RecipeModel model = RecipeModel.fromJson(data);
    setState(() {
      recipe = model.recipes!;
      meals.clear();
      for (var item in recipe) {
        var meallist = item.mealType;
        for (var meal in meallist!) {
          if (!meals.contains(meal)) {
            meals.add(meal);
          }
        }
      }
    });
  }

  getSearchData(String query) async {
    if (query.isEmpty) {
      getData();
      return;
    }
    var data = await API().getsearchitem(query);
    RecipeModel model = RecipeModel.fromJson(data);
    setState(() {
      recipe = model.recipes!;
    });
  }

  fetchSortedRecipes(String sortBy, String order) async {
    var data = await API().getfilter(sortBy, order);
    RecipeModel model = RecipeModel.fromJson(data);
    setState(() {
      recipe = model.recipes!;
    });
  }

  fetchmealsitem(String mealType) async {
    var data = await API().getmealitem(mealType);
    RecipeModel model = RecipeModel.fromJson(data);
    setState(() {
      recipe = model.recipes!;
    });
  }

  void onSortSelected(String sortBy, String order) {
    fetchSortedRecipes(sortBy, order);
  }

  PopupMenuItem<Map<String, String>> _buildMenuItem(IconData icon, String text, String sortBy, String order) {
    return PopupMenuItem(
      value: {'sortBy': sortBy, 'order': order},
      child: Row(
        children: [
          Icon(icon, color: Colors.deepPurpleAccent),
          SizedBox(width: 10),
          Text(
            text,
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  int getCrossAxisCount(double width) {
    if (width >= 1200) return 4;
    if (width >= 1000) return 3;
    if (width >= 700) return 2;
    return 1;
  }

  double getChildAspectRatio(double width) {
    if(width >= 1850) return 1.1;
    if(width >= 1700) return 1;
    if(width >= 1650) return 0.99;
    if(width >= 1500) return 0.88;
    if (width >= 1350) return 0.731;
    if (width >= 1200) return 0.60;

    if (width >= 1100) return 0.80;
    if(width>= 1000) return 0.71;
    if (width>= 700) return 0.85;
    if (width>= 600) return 1.54;
    if (width>= 500) return 1.27;
    if (width >= 400) return  1.0;
    if (width>= 370) return 0.95;
    if (width>= 350) return  0.85;
    if (width>= 340) return 0.827;
    if (width >= 300) return 0.71;
    if (width >= 200) return 0.35;
    return 0.20;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFe0eafc), Color(0xFFcfdef3)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              double width = constraints.maxWidth;
              int crossAxisCount = getCrossAxisCount(width);
              double childAspectRatio = getChildAspectRatio(width);
              double horizontalPadding = width > 800 ? 40.0 : 16.0;

              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextWidget(
                                Text: "My Recipe Book",
                                fontsize: width > 800 ? 32 : 20,
                                fw: FontWeight.bold,
                                fontcolour: Colors.indigo.shade700,
                              ),
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.white,
                                    child: IconButton(
                                      onPressed: () => getData(),
                                      icon: Icon(CupertinoIcons.refresh, color: Colors.indigo),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  CircleAvatar(
                                    backgroundColor: Colors.white,
                                    child: IconButton(
                                      onPressed: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => RecipeManagerPage()),
                                      ),
                                      icon: Icon(CupertinoIcons.add_circled, color: Colors.indigo),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.shade400,
                                  blurRadius: 6,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: TextField(
                              controller: searchController,
                              onChanged: getSearchData,
                              decoration: InputDecoration(
                                hintText: "Search your favorite recipe...",
                                border: InputBorder.none,
                                icon: Icon(Icons.search),
                                suffixIcon: searchController.text.isNotEmpty
                                    ? IconButton(
                                  icon: Icon(Icons.clear),
                                  onPressed: () {
                                    searchController.clear();
                                    getData();
                                  },
                                )
                                    : null,
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: meals.map((meal) {
                              return InkWell(
                                onTap: () => fetchmealsitem(meal),
                                child: Chip(
                                  label: Text(meal),
                                  backgroundColor: Colors.indigo.shade50,
                                  side: BorderSide(color: Colors.indigo),
                                ),
                              );
                            }).toList(),
                          ),
                          SizedBox(height: 16),
                          Row(
                            children: [
                              TextWidget(
                                Text: "All Recipes",
                                fontsize: width > 800 ? 28 : 24,
                                fontcolour: Colors.indigo.shade900,
                                fw: FontWeight.bold,
                              ),
                              Spacer(),
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Color(0xFFB6FBFF), Color(0xFF83A4D4)],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(25),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.blueGrey.withOpacity(0.4),
                                      blurRadius: 8,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: PopupMenuButton<Map<String, String>>(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  icon: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 12.0),
                                    child: Row(
                                      children: [
                                        Icon(Icons.filter_alt_rounded, color: Colors.white),
                                        SizedBox(width: 5),
                                        Text(
                                          'Sort',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  color: Colors.white,
                                  onSelected: (value) {
                                    onSortSelected(value['sortBy']!, value['order']!);
                                  },
                                  itemBuilder: (context) => [
                                    _buildMenuItem(Icons.sort_by_alpha, 'Name ↑', 'name', 'asc'),
                                    _buildMenuItem(Icons.sort_by_alpha, 'Name ↓', 'name', 'desc'),
                                    _buildMenuItem(Icons.timer, 'Cook Time ↑', 'cookTimeMinutes', 'asc'),
                                    _buildMenuItem(Icons.timer, 'Cook Time ↓', 'cookTimeMinutes', 'desc'),
                                    _buildMenuItem(Icons.bar_chart, 'Difficulty ↑', 'difficulty', 'asc'),
                                    _buildMenuItem(Icons.bar_chart, 'Difficulty ↓', 'difficulty', 'desc'),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (recipe.isEmpty && searchController.text.isNotEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search_off, size: 80, color: Colors.indigo.shade200),
                            SizedBox(height: 10),
                            Text("No recipes found!",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.indigo)),
                            Text("Try a different keyword.",
                                style: TextStyle(color: Colors.grey.shade700)),
                          ],
                        ),
                      ),
                    )
                  else
                    SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 10),
                      sliver: SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: childAspectRatio,
                        ),
                        delegate: SliverChildBuilderDelegate(
                              (context, index) {
                            return All_recipes(recipe: [recipe[index]]);
                          },
                          childCount: recipe.length,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}