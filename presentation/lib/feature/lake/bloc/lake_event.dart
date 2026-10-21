part of 'lake_bloc.dart';

sealed class LakeEvent extends Equatable {
  const LakeEvent();

  @override
  List<Object?> get props => [];
}

final class LakeStarted extends LakeEvent {
  const LakeStarted();
}
