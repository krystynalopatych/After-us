import 'package:equatable/equatable.dart';

final class CampfireUses extends Equatable {
  final int day;
  final int count;

  const CampfireUses({
    required this.day,
    required this.count,
  });

  const CampfireUses.none() : day = 0, count = 0;

  int countOn(int day) => day == this.day ? count : 0;

  CampfireUses copyWith({
    int? day,
    int? count,
  }) => CampfireUses(
    day: day ?? this.day,
    count: count ?? this.count,
  );

  @override
  List<Object?> get props => [day, count];
}
