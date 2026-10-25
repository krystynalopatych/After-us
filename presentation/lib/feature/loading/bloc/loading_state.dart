part of 'loading_bloc.dart';

final class LoadingState extends Equatable {
  final int loadedCount;
  final int? totalCount;

  const LoadingState({
    this.loadedCount = 0,
    this.totalCount,
  });

  bool get isDone => switch (totalCount) {
    final total? => loadedCount >= total,
    null => false,
  };

  double get progress => switch (totalCount) {
    null || 0 => 0,
    final total => loadedCount / total,
  };

  LoadingState copyWith({
    int? loadedCount,
    int? totalCount,
  }) => LoadingState(
    loadedCount: loadedCount ?? this.loadedCount,
    totalCount: totalCount ?? this.totalCount,
  );

  @override
  List<Object?> get props => [loadedCount, totalCount];
}
