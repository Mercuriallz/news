import "package:equatable/equatable.dart";

abstract class SourceEvent extends Equatable {
  const SourceEvent();

  @override
  List<Object> get props => [];
}

class LoadSources extends SourceEvent {
  final String category;

  const LoadSources({required this.category});

  @override
  List<Object> get props => [category];
}

class LoadMoreSources extends SourceEvent {
  const LoadMoreSources();
}