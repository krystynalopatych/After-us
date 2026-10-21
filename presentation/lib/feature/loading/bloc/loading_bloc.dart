import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'loading_event.dart';
part 'loading_state.dart';

class LoadingBloc extends Bloc<LoadingEvent, LoadingState> {
  LoadingBloc() : super(const LoadingState()) {
    on<LoadingStarted>((event, emit) => emit(state.copyWith(totalCount: event.imageCount)));
    on<LoadingImageLoaded>((event, emit) => emit(state.copyWith(loadedCount: state.loadedCount + 1)));
  }
}
