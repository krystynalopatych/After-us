part of 'menu_bloc.dart';

final class MenuState extends Equatable {
  final bool isOpen;
  final bool isSaved;

  const MenuState({
    this.isOpen = false,
    this.isSaved = false,
  });

  MenuState copyWith({
    bool? isOpen,
    bool? isSaved,
  }) => MenuState(
    isOpen: isOpen ?? this.isOpen,
    isSaved: isSaved ?? this.isSaved,
  );

  @override
  List<Object?> get props => [isOpen, isSaved];
}
