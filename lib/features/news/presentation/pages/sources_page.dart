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
  final scrollController = ScrollController();
  final searchController = TextEditingController();
  final searchFocusNode = FocusNode();
  bool isSearchVisible = false;
  
  List allSources = [];
  List filteredSources = [];
  
  @override
  void initState() {
    super.initState();
    scrollController.addListener(onScroll);
    searchController.addListener(onSearchChanged);
  }
  
  @override
  void dispose() {
    scrollController.dispose();
    searchController.dispose();
    searchFocusNode.dispose();
    super.dispose();
  }
  
  void onScroll() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      context.read<SourceBloc>().add(LoadMoreSources());
    }
  }

  void onSearchChanged() {
    if (searchController.text.isEmpty) {
      setState(() {
        filteredSources = allSources;
      });
    } else {
      setState(() {
        filteredSources = allSources
            .where((source) => 
                source.name.toLowerCase().contains(searchController.text.toLowerCase()) ||
                source.description.toLowerCase().contains(searchController.text.toLowerCase()))
            .toList();
      });
    }
  }

  void _toggleSearch() {
    setState(() {
      isSearchVisible = !isSearchVisible;
      if (isSearchVisible) {
        searchFocusNode.requestFocus();
      } else {
        searchController.clear();
        searchFocusNode.unfocus();
        filteredSources = allSources; 
      }
    });
  }

  void _clearSearch() {
    searchController.clear();
    searchFocusNode.unfocus();
    setState(() {
      filteredSources = allSources;
    });
  }

  List<Color> _getSourceGradient(int index) {
    final gradients = [
      [Color(0xFF667eea), Color(0xFF764ba2)], 
      [Color(0xFFf093fb), Color(0xFFf5576c)], 
      [Color(0xFF4facfe), Color(0xFF00f2fe)], 
      [Color(0xFFfa709a), Color(0xFFfee140)],
      [Color(0xFFa8edea), Color(0xFFfed6e3)], 
      [Color(0xFFffecd2), Color(0xFFfcb69f)], 
      [Color(0xFFc471f5), Color(0xFFfa71cd)], 
      [Color(0xFF74b9ff), Color(0xFF0984e3)], 
      [Color(0xFF00b894), Color(0xFF00cec9)], 
      [Color(0xFFfdcb6e), Color(0xFFe17055)], 
    ];
    
    return gradients[index % gradients.length];
  }

  // Get source icon based on name
  IconData _getSourceIcon(String sourceName) {
    final name = sourceName.toLowerCase();
    if (name.contains('bbc')) return Icons.public;
    if (name.contains('cnn')) return Icons.tv;
    if (name.contains('tech')) return Icons.computer;
    if (name.contains('sport')) return Icons.sports;
    if (name.contains('health')) return Icons.health_and_safety;
    if (name.contains('business')) return Icons.business;
    if (name.contains('science')) return Icons.science;
    return Icons.article;
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2d1b69), 
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(isSearchVisible ? 140 : 80),
        child: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: isSearchVisible ? null : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.category,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Select news source',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(
                isSearchVisible ? Icons.close : Icons.search,
                color: Colors.white,
              ),
              onPressed: _toggleSearch,
            ),
          ],
          bottom: isSearchVisible ? PreferredSize(
            preferredSize: Size.fromHeight(60),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Colors.white30),
                ),
                child: TextField(
                  controller: searchController,
                  focusNode: searchFocusNode,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search sources...',
                    hintStyle: TextStyle(color: Colors.white60),
                    prefixIcon: Icon(Icons.search, color: Colors.white60),
                    suffixIcon: searchController.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(Icons.clear, color: Colors.white60),
                            onPressed: _clearSearch,
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  ),
                ),
              ),
            ),
          ) : null,
          toolbarHeight: 80,
        ),
      ),
      body: BlocBuilder<SourceBloc, SourceState>(
        builder: (context, state) {
          if (state is SourceInitial || state is SourceLoading) {
            return _buildLoadingState();
          } else if (state is SourceError) {
            return _buildErrorState(state.message);
          } else if (state is SourceLoaded) {
            if (allSources.isEmpty || allSources.length != state.sources.length) {
              allSources = state.sources;
              filteredSources = allSources;
            }
            
            if (state.sources.isEmpty) {
              return _buildEmptyState();
            }
            
            return _buildSourcesList(state, filteredSources);
          }
          return Container();
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.circular(20),
            ),
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              strokeWidth: 3,
            ),
          ),
          SizedBox(height: 24),
          Text(
            'Loading sources...',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red.shade300,
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Oops! Something went wrong',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.article_outlined,
                size: 64,
                color: Colors.white70,
              ),
            ),
            SizedBox(height: 24),
            Text(
              'No Sources Found',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 12),
            Text(
              AppStrings.noSourcesFound,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoSearchResultsState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.search_off,
                size: 64,
                color: Colors.white70,
              ),
            ),
            SizedBox(height: 24),
            Text(
              'No Results Found',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 12),
            Text(
              'No sources match "${searchController.text}"\nTry different keywords',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
                height: 1.5,
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _clearSearch,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white10,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text('Clear Search'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSourcesList(SourceLoaded state, List<dynamic> filteredSources) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isSearchVisible && searchController.text.isNotEmpty
                    ? 'SEARCH RESULTS (${filteredSources.length})'
                    : 'AVAILABLE SOURCES',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
              ),
              if (isSearchVisible && searchController.text.isNotEmpty)
                GestureDetector(
                  onTap: _clearSearch,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Clear',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        Expanded(
          child: filteredSources.isEmpty && isSearchVisible && searchController.text.isNotEmpty
              ? _buildNoSearchResultsState()
              : ListView.builder(
                  controller: scrollController,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  itemCount: isSearchVisible && searchController.text.isNotEmpty
                      ? filteredSources.length
                      : (state.hasReachedMax
                          ? state.sources.length
                          : state.sources.length + 1),
                  itemBuilder: (context, index) {
                    if (!isSearchVisible || searchController.text.isEmpty) {
                      if (index >= state.sources.length) {
                        return _buildLoadMoreIndicator();
                      }
                      return _buildSourceCard(state.sources[index], index);
                    } else {
                      return _buildSourceCard(filteredSources[index], index);
                    }
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildSourceCard(source, int index) {
    final gradientColors = _getSourceGradient(index);
    final icon = _getSourceIcon(source.name);
    
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => 
                BlocProvider(
                  create: (_) => sl<ArticleBloc>()
                    ..add(LoadArticles(sourceId: source.id)),
                  child: ArticlesPage(source: source.name),
                ),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: Offset(1.0, 0.0),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeInOutCubic,
                  )),
                  child: child,
                );
              },
            ),
          );
        },
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            
          ),
          child: Stack(
            children: [
              Positioned(
                right: -10,
                top: -10,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                right: 15,
                bottom: -5,
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              // Content
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      icon,
                      size: 24,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          source.name,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                           
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          source.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 16,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadMoreIndicator() {
    return Container(
      padding: EdgeInsets.all(24),
      child: Center(
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white10,
            borderRadius: BorderRadius.circular(16),
          ),
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            strokeWidth: 2,
          ),
        ),
      ),
    );
  }
}