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

  // Generate gradient colors for sources
  List<Color> _getSourceGradient(int index) {
    final gradients = [
      [Color(0xFF667eea), Color(0xFF764ba2)], // Purple-blue
      [Color(0xFFf093fb), Color(0xFFf5576c)], // Pink-red
      [Color(0xFF4facfe), Color(0xFF00f2fe)], // Blue-cyan
      [Color(0xFFfa709a), Color(0xFFfee140)], // Pink-yellow
      [Color(0xFFa8edea), Color(0xFFfed6e3)], // Mint-pink
      [Color(0xFFffecd2), Color(0xFFfcb69f)], // Peach
      [Color(0xFFc471f5), Color(0xFFfa71cd)], // Purple-pink
      [Color(0xFF74b9ff), Color(0xFF0984e3)], // Blue
      [Color(0xFF00b894), Color(0xFF00cec9)], // Green-teal
      [Color(0xFFfdcb6e), Color(0xFFe17055)], // Orange
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
      backgroundColor: Color(0xFF2d1b69), // Dark purple background
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
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
        toolbarHeight: 80,
      ),
      body: BlocBuilder<SourceBloc, SourceState>(
        builder: (context, state) {
          if (state is SourceInitial || state is SourceLoading) {
            return _buildLoadingState();
          } else if (state is SourceError) {
            return _buildErrorState(state.message);
          } else if (state is SourceLoaded) {
            if (state.sources.isEmpty) {
              return _buildEmptyState();
            }
            return _buildSourcesList(state);
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

  Widget _buildSourcesList(SourceLoaded state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'AVAILABLE SOURCES',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: EdgeInsets.symmetric(horizontal: 20),
            itemCount: state.hasReachedMax
                ? state.sources.length
                : state.sources.length + 1,
            itemBuilder: (context, index) {
              if (index >= state.sources.length) {
                return _buildLoadMoreIndicator();
              }
              
              final source = state.sources[index];
              return _buildSourceCard(source, index);
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