import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:news_app/models/categories-news-model-dart.dart';
import 'package:news_app/models/news_channel_headlines_model.dart';
class NewsRepository{
  Future<NewsChannelHeadlinesModel> fetechNewsChannelHeadlinesApi(String name)async {
   String url ='https://newsapi.org/v2/top-headlines?sources=$name&apiKey=430a794d63e54e1ebb6f583b5c63dd04';
   final response = await http.get(Uri.parse(url));
   if(response.statusCode == 200){
     final body = jsonDecode(response.body);
     return NewsChannelHeadlinesModel.fromJson(body);
   }
   throw Exception('Error');
  }
  Future<CategoriesNewsModel> fetechCategoriesNewsModelApi(String category)async {
    String url ='https://newsapi.org/v2/everything?q=$category&apiKey=430a794d63e54e1ebb6f583b5c63dd04';
    final response = await http.get(Uri.parse(url));
    if(response.statusCode == 200){
      final body = jsonDecode(response.body);
      return CategoriesNewsModel.fromJson(body);
    }
    throw Exception('Error');
  }
}

