import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NewsPage extends StatefulWidget {
  const NewsPage({Key? key}) : super(key: key);

  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  final NewsService _newsService = NewsService();

  List<News> _newsList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getNews();
  }

  Future<void> _getNews() async {
    setState(() {
      _isLoading = true;
    });
    final newsList = await _newsService.getNews();
    setState(() {
      _newsList = newsList;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Plants Doctor | News"),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _newsList.length,
              itemBuilder: (context, index) {
                final news = _newsList[index];
                return ListTile(
                  title: Text(news.title),
                  subtitle: Text(news.description),
                  trailing: Icon(Icons.arrow_forward),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => NewsDetailsPage(news: news),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}

class News {
  final String title;
  final String description;
  final String imageUrl;
  final String url;

  News({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.url,
  });
}

class NewsService {
  static const API_KEY = 'eb3b5d4511c64ad4857480b853c04f8b';
  static const BASE_URL =
      'https://newsapi.org/v2/top-headlines?country=us&category=science&apiKey=$API_KEY';

  Future<List<News>> getNews() async {
    final response = await http.get(Uri.parse(BASE_URL));
    final data = jsonDecode(response.body);

    if (data['status'] == 'ok') {
      final articles = data['articles'] as List;
      return articles.map((article) {
        return News(
          title: article['title'],
          description: article['description'],
          imageUrl: article['urlToImage'],
          url: article['url'],
        );
      }).toList();
    } else {
      throw Exception('Failed to load news');
    }
  }
}

class NewsDetailsPage extends StatelessWidget {
  final News news;

  NewsDetailsPage({required this.news});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(news.title),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(news.imageUrl),
              SizedBox(height: 16),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      news.title,
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(news.description),
                    SizedBox(height: 8),
                    TextButton(
                      onPressed: () {},
                      child: Text('Read more'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
