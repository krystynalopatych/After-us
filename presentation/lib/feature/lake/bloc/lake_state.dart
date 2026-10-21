part of 'lake_bloc.dart';

final class LakeState extends Equatable {
  final bool isPolluted;

  const LakeState({required this.isPolluted});

  LakeState copyWith({bool? isPolluted}) => LakeState(isPolluted: isPolluted ?? this.isPolluted);

  @override
  List<Object?> get props => [isPolluted];
}
