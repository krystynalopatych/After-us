part of 'loading_bloc.dart';

sealed class LoadingEvent extends Equatable {
  const LoadingEvent();

  @override
  List<Object?> get props => [];
}

final class LoadingStarted extends LoadingEvent {
  final int imageCount;

  const LoadingStarted(this.imageCount);

  @override
  List<Object?> get props => [imageCount];
}

final class LoadingImageLoaded extends LoadingEvent {
  const LoadingImageLoaded();
}
