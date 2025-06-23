import "package:equatable/equatable.dart";
import "package:test_news/features/news/domain/entities/source.dart";

class SourceState extends Equatable {
  const SourceState();

  @override
  List<Object> get props => [];
}

class SourceInitial extends SourceState {}

class SourceLoading extends SourceState {}

class SourceLoaded extends SourceState {
  final List<Source> sources;
  final bool hasReachedMax;

  const SourceLoaded({
    required this.sources,
    this.hasReachedMax = false,
  });

  SourceLoaded copyWith({
    List<Source>? sources,
    bool? hasReachedMax,
  }) {
    return SourceLoaded(
      sources: sources ?? this.sources,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [sources, hasReachedMax];
}

class SourceError extends SourceState {
  final String message;

  const SourceError({required this.message});

  @override
  List<Object> get props => [message];
}