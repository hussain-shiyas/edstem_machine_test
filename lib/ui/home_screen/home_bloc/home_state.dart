part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeError extends HomeState {
  final String message;

  const HomeError({required this.message});

  @override
  List<Object> get props => [message];
}

class HomeGetMovieSuccess extends HomeState {
  final GetMovieResModel movieList;

  const HomeGetMovieSuccess({required this.movieList});

  @override
  List<Object> get props => [movieList];
}
