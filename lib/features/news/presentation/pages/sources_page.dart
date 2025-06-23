import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:test_news/core/constants/strings.dart";
import "package:test_news/features/injection_container.dart";
import "package:test_news/features/news/presentation/bloc/article_bloc/article_bloc.dart";
import "package:test_news/features/news/presentation/bloc/article_bloc/article_event.dart";
import "../bloc/source_bloc/source_bloc.dart";
import "../bloc/source_bloc/source_event.dart";
import "../bloc/source_bloc/source_state.dart";
import "articles_page.dart";

class SourcesPage extends StatefulWidget {
  final String category;

  const SourcesPage({super.key, required this.category});

  @override
  State<SourcesPage> createState() => _SourcesPageState();
}

class _SourcesPageState extends State<SourcesPage> {
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
      context.read<SourceBloc>().add(LoadMoreSources());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category),
      ),
      body: BlocBuilder<SourceBloc, SourceState>(
        builder: (context, state) {
          if (state is SourceInitial || state is SourceLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SourceError) {
            return Center(child: Text(state.message));
          } else if (state is SourceLoaded) {
            if (state.sources.isEmpty) {
              return const Center(child: Text(AppStrings.noSourcesFound));
            }
            return ListView.builder(
              controller: _scrollController,
              itemCount: state.hasReachedMax
                  ? state.sources.length
                  : state.sources.length + 1,
              itemBuilder: (context, index) {
                if (index >= state.sources.length) {
                  return const Center(child: CircularProgressIndicator());
                }
                final source = state.sources[index];
                return ListTile(
                  title: Text(source.name),
                  subtitle: Text(source.description),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider(
                          create: (_) => sl<ArticleBloc>()
                            ..add(LoadArticles(sourceId: source.id)),
                          child: ArticlesPage(source: source.name),
                        ),
                      ),
                    );
                  },
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