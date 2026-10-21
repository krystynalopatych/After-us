part of 'night_bloc.dart';

final class NightState extends Equatable {
  final int nightSeconds;

  const NightState({required this.nightSeconds});

  bool get isNight => nightSeconds > 0;

  double get progress => 1 - nightSeconds / GameDay.nightLength;

  NightState copyWith({int? nightSeconds}) => NightState(nightSeconds: nightSeconds ?? this.nightSeconds);

  @override
  List<Object?> get props => [nightSeconds];
}
