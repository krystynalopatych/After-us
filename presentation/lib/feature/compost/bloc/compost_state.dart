part of 'compost_bloc.dart';

final class CompostState extends Equatable {
  final CompostPit pit;

  const CompostState({required this.pit});

  CompostState copyWith({CompostPit? pit}) => CompostState(pit: pit ?? this.pit);

  @override
  List<Object?> get props => [pit];
}
