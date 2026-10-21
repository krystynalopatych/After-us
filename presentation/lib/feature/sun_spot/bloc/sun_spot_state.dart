part of 'sun_spot_bloc.dart';

final class SunSpotState extends Equatable {
  final SunBottle? bottle;

  const SunSpotState({this.bottle});

  SunSpotState copyWith({SunBottle? Function()? bottle}) =>
      SunSpotState(bottle: bottle != null ? bottle() : this.bottle);

  @override
  List<Object?> get props => [bottle];
}
