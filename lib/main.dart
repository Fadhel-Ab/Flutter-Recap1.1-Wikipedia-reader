import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'summary.dart';
import 'dart:convert';
import 'dart:io';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = ArticleViewModel(ArticleModel());
    return MaterialApp(home: ArticleView());
  }
}

class ArticleModel {
  Future<Summary> getRandomArticleSummary() async {
    final uri = Uri.https(
      'en.wikipedia.org',
      '/api/rest_v1/page/random/summary',
    );
    final response = await get(uri);

    if (response.statusCode != 200) {
      throw const HttpException('Failed to update resource');
    }

    return Summary.fromJson(jsonDecode(response.body) as Map<String, Object?>);
  }
}

class ArticleViewModel extends ChangeNotifier {
  final ArticleModel model;
  Summary? summary;
  Exception? error;
  bool isLoading = false;

  ArticleViewModel(this.model) {
    fetchArticle();
  }

  Future<void> fetchArticle() async {
    isLoading = true;
    notifyListeners();

    //the logic here
    try {
      summary = await model.getRandomArticleSummary();
      print('Article loaded: ${summary!.titles.normalized}');
      error = null;
    } on HttpException catch (e) {
      print('Error loading article: ${e.message}'); // Temporary
      error = e;
      summary = null;
    }

    //and then we put stuff back to where it was
    isLoading = false;
    notifyListeners();
  }
}

class ArticleView extends StatefulWidget {
  const ArticleView({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ArticleViewState();
  }
}

class _ArticleViewState extends State<ArticleView> {
  final ArticleViewModel viewModel = ArticleViewModel(ArticleModel());

  @override
  void initState() {
    super.initState();
    viewModel.fetchArticle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wikipedia Flutter')),
      body: ListenableBuilder(listenable: viewModel, builder: (context, _) {
        return switch((viewModel.isLoading,viewModel.summary,viewModel.error,)) {
          (true,_,_) => const CircularProgressIndicator(),
          (_, _,final Exception e)=> Text('Error: $e'),
          (_,final summary?,_)=> ArticlePage(summary:summary,nextArticleCallBack:viewModel.fetchArticle,),
          _=>const Text('Something went Wrong!'),

        };
      })
    );
  }
}

class ArticlePage extends StatelessWidget {
  final Summary summary;
  final VoidCallback nextArticleCallBack;

  const ArticlePage({super.key,required this.nextArticleCallBack,required this.summary});
  
  @override
  Widget build(BuildContext context) {

  return  SingleChildScrollView(
    child: Column(
      children: [ArticleWidget(summary:summary), ElevatedButton(onPressed: nextArticleCallBack, child: const Text('Next Random article'))],
    ),
  ) ;
  }

}

class ArticleWidget extends StatelessWidget {
  final Summary summary;
  const ArticleWidget({super.key, required this.summary});
  
  @override
  Widget build(BuildContext context) {
 return 
  }
}