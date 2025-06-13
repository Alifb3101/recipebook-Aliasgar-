import 'package:dio/dio.dart'hide Headers;
import 'package:recipes_api/database/api/api_header.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';


part 'rest_client.g.dart';


@RestApi(baseUrl: 'https://dummyjson.com')
abstract class RestClient {

  factory RestClient(Dio dio, {String? baseUrl}) = _RestClient;

  @GET("/recipes")
  Future<String> getrecipes();

  @GET("/recipes/{id}")
  Future<String> getsinglerecipes(@Path("id") int id);

  @GET("/recipes/search")
  Future<String> searchrecipes(@Query("q") String query);

  @GET("/recipes")
  Future<String> filteritem(@Query("sortBy") String sortby,
      @Query("order") String order);

  @GET("/recipes/tags")
  Future<String> itembytag();

  @GET("/recipes/tag/{tags}")
  Future<String> tagsitem(@Path("tags") String tags);

  @GET("/recipes/meal-type/{mealType}")
  Future<String> mealitems(@Path("mealType") String mealType);

  @POST("/recipes/add")
  Future<String> addrecipe(@Body() Map<String, dynamic> body);

  @PUT('/recipes/{id}')
  Future<String> updateRecipe(
      @Path("id") String id,
      @Body() Map<String, dynamic> body);

  @DELETE("/recipes/{id}")
  Future<String> deleteRecipe(@Path("id") String id);

}