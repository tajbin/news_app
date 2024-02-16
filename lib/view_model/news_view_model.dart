import 'package:news_app/models/categories-news-model-dart.dart';
import 'package:news_app/models/news_channel_headlines_model.dart';
import 'package:news_app/repository/news_repository.dart';

class NewsViewModel{
  final _rep = NewsRepository();

  Future<NewsChannelHeadlinesModel> fetechNewsChannelHeadlinesApi(String name)async{
    final response = await _rep.fetechNewsChannelHeadlinesApi(name);
    return response;
  }

  Future<CategoriesNewsModel> fetchCategoriesNewsModelApi(String category)async{
    final response = await _rep.fetechCategoriesNewsModelApi(category);
    return response;
  }
}