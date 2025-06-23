import "package:equatable/equatable.dart";

class Category extends Equatable {
  final String name;
  final String displayName;

  const Category({
    required this.name,
    required this.displayName,
  });

  @override
  List<Object> get props => [name, displayName];
}