class RecipeModel {
  List<Recipes>? recipes;
  int? total;
  int? skip;
  int? limit;

  RecipeModel({this.recipes, this.total, this.skip, this.limit});

  RecipeModel.fromJson(Map<String, dynamic> json) {
    if (json['recipes'] != null) {
      recipes = <Recipes>[];
      json['recipes'].forEach((v) {
        recipes!.add(Recipes.fromJson(v));
      });
    }
    total = json['total'];
    skip = json['skip'];
    limit = json['limit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (recipes != null) {
      data['recipes'] = recipes!.map((v) => v.toJson()).toList();
    }
    data['total'] = total;
    data['skip'] = skip;
    data['limit'] = limit;
    return data;
  }
}

class Recipes {
  int? id;
  String? name;
  List<String>? ingredients;
  List<String>? instructions;
  int? prepTimeMinutes;
  int? cookTimeMinutes;
  int? servings;
  String? difficulty;
  String? cuisine;
  int? caloriesPerServing;
  List<String>? tags;
  int? userId;
  String? image;
  double? rating;
  int? reviewCount;
  List<String>? mealType;

  Recipes({
    this.id,
    this.name,
    this.ingredients,
    this.instructions,
    this.prepTimeMinutes,
    this.cookTimeMinutes,
    this.servings,
    this.difficulty,
    this.cuisine,
    this.caloriesPerServing,
    this.tags,
    this.userId,
    this.image,
    this.rating,
    this.reviewCount,
    this.mealType,
  });

  Recipes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    ingredients = (json['ingredients'] as List?)?.cast<String>();
    instructions = (json['instructions'] as List?)?.cast<String>();
    prepTimeMinutes = json['prepTimeMinutes'];
    cookTimeMinutes = json['cookTimeMinutes'];
    servings = json['servings'];
    difficulty = json['difficulty'];
    cuisine = json['cuisine'];
    caloriesPerServing = json['caloriesPerServing'];
    tags = (json['tags'] as List?)?.cast<String>();
    userId = json['userId'];
    image = json['image'];

    // ✅ Handle case where rating may be an int or a double
    var ratingValue = json['rating'];
    if (ratingValue is int) {
      rating = ratingValue.toDouble();
    } else if (ratingValue is double) {
      rating = ratingValue;
    }

    reviewCount = json['reviewCount'];
    mealType = (json['mealType'] as List?)?.cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['ingredients'] = ingredients;
    data['instructions'] = instructions;
    data['prepTimeMinutes'] = prepTimeMinutes;
    data['cookTimeMinutes'] = cookTimeMinutes;
    data['servings'] = servings;
    data['difficulty'] = difficulty;
    data['cuisine'] = cuisine;
    data['caloriesPerServing'] = caloriesPerServing;
    data['tags'] = tags;
    data['userId'] = userId;
    data['image'] = image;
    data['rating'] = rating;
    data['reviewCount'] = reviewCount;
    data['mealType'] = mealType;
    return data;
  }
}