import "package:flutter/material.dart";
import "package:webview_flutter/webview_flutter.dart";

class ArticleDetailPage extends StatefulWidget {
  final String url;

  const ArticleDetailPage({super.key, required this.url});

  @override
  State<ArticleDetailPage> createState() => _ArticleDetailPageState();
}

class _ArticleDetailPageState extends State<ArticleDetailPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("News Detail")),
      body: WebViewWidget(controller: _controller),
    );
  }
}
