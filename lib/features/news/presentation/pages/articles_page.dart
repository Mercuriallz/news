import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:test_news/core/constants/strings.dart";
import "../bloc/article_bloc/article_bloc.dart";
import "../bloc/article_bloc/article_event.dart";
import "../bloc/article_bloc/article_state.dart";
import "article_detail_page.dart";

class ArticlesPage extends StatefulWidget {
  final String source;

  const ArticlesPage({super.key, required this.source});

  @override
  State<ArticlesPage> createState() => _ArticlesPageState();
}

class _ArticlesPageState extends State<ArticlesPage> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      context.read<ArticleBloc>().add(LoadMoreArticles());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.source),
      ),
      body: BlocBuilder<ArticleBloc, ArticleState>(
        builder: (context, state) {
          if (state is ArticleInitial || state is ArticleLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ArticleError) {
            return Center(child: Text(state.message));
          } else if (state is ArticleLoaded) {
            if (state.articles.isEmpty) {
              return const Center(child: Text(AppStrings.noArticlesFound));
            }
            return ListView.builder(
              controller: _scrollController,
              itemCount: state.hasReachedMax
                  ? state.articles.length
                  : state.articles.length + 1,
              itemBuilder: (context, index) {
                if (index >= state.articles.length) {
                  return const Center(child: CircularProgressIndicator());
                }
                final article = state.articles[index];
                return Card(
                  child: ListTile(
                    leading: article.urlToImage.isNotEmpty
                        ? Image.network(
                            article.urlToImage,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          )
                        : const Icon(Icons.image),
                    title: Text(article.title),
                    subtitle: Text(article.description),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ArticleDetailPage(url: article.url),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
          return Container();
        },
      ),
    );
  }
}