import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:test_news/core/constants/strings.dart";
import "package:test_news/features/injection_container.dart";
import "package:test_news/features/news/presentation/bloc/source_bloc/source_bloc.dart";
import "package:test_news/features/news/presentation/bloc/source_bloc/source_event.dart";
import "../bloc/category_bloc/category_bloc.dart";
import "../bloc/category_bloc/category_event.dart";
import "../bloc/category_bloc/category_state.dart";
import "sources_page.dart";

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appName),
      ),
      body: BlocProvider(
        create: (_) => sl<CategoryBloc>()..add(LoadCategories()),
        child: BlocBuilder<CategoryBloc, CategoryState>(
          builder: (context, state) {
            if (state is CategoryInitial || state is CategoryLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is CategoryError) {
              return Center(child: Text(state.message));
            } else if (state is CategoryLoaded) {
              return ListView.builder(
                itemCount: state.categories.length,
                itemBuilder: (context, index) {
                  final category = state.categories[index];
                  return ListTile(
                    title: Text(category.displayName),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BlocProvider(
                            create: (_) => sl<SourceBloc>()
                              ..add(LoadSources(category: category.name)),
                            child: SourcesPage(category: category.displayName),
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
      ),
    );
  }
}