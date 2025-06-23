import "package:flutter/material.dart";
import "package:test_news/core/constants/strings.dart";
import "features/injection_container.dart" as di;
import "features/news/presentation/pages/categories_page.dart";

void main() async {
  
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppStrings.appName,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CategoriesPage(),
    );
  }
}