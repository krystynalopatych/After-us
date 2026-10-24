part of 'menu_bloc.dart';

final class MenuState extends Equatable {
  final bool isOpen;
  final bool isSaved;
  final bool isMuted;

  const MenuState({
    this.isOpen = false,
    this.isSaved = false,
    this.isMuted = false,
  });

  MenuState copyWith({
    bool? isOpen,
    bool? isSaved,
    bool? isMuted,
  }) => MenuState(
    isOpen: isOpen ?? this.isOpen,
    isSaved: isSaved ?? this.isSaved,
    isMuted: isMuted ?? this.isMuted,
  );

  @override
  List<Object?> get props => [isOpen, isSaved, isMuted];
}
