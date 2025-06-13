import 'dart:convert';


import '../injection/injection.dart';

class API{
  getrecipesList()async{
    var res = await restClient.getrecipes();
    return jsonDecode(res);
  }

  getsinglerecipes(int id)async{
    var res = await restClient.getsinglerecipes(id);
    return jsonDecode(res);
  }
  getsearchitem(String query)async{
    var res = await restClient.searchrecipes(query);
    return jsonDecode(res);
  }

  getfilter(String sortby , String order) async {
    var res = await restClient.filteritem(sortby, order);
    return jsonDecode(res);
  }


  getagitem()async{
    var res = await restClient.itembytag();
    return jsonDecode(res);
  }
  getdetailsitembytag(String tags)async{
    var res = await restClient.tagsitem(tags);
    return jsonDecode(res);
  }
  getmealitem(String mealType)async{
    var res = await restClient.mealitems(mealType);
    return jsonDecode(res);
  }
  addrecipes(String names)async{
    Map<String,dynamic> body = {
      "method" : "POST",
      "name"  : names,
    };
    var res = await restClient.addrecipe(body);
    return jsonDecode(res);
  }

  updateRecipe(String id,String names) async {
    Map<String,dynamic> body = {
      'method' : 'PUT',
      'name'  : names,
      'id'  : id,
    };

    var response = await restClient.updateRecipe(id ,body);
    return jsonDecode(response);
  }

  deleteRecipeById(String id) async {
    final resposne = await restClient.deleteRecipe(id);
    return jsonEncode(resposne);
  }

}

