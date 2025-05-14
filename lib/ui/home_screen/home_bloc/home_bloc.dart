import 'package:edstem_machine_test/core/local_storage/hive.dart';
import 'package:edstem_machine_test/core/services/network_service/network_services.dart';
import 'package:edstem_machine_test/ui/home_screen/models/get_movie_res_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/repository/home_repo.dart';

part 'home_event.dart';part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository _homeRepository;

  HomeBloc()
    : _homeRepository = HomeRepositoryImpl(NetworkService()),
      super(HomeInitial()) {
    on<GetMovieEvent>(_getMovies);
  }

  Future<void> _getMovies(GetMovieEvent event, Emitter<HomeState> emit) async {
    try {
      emit(HomeLoading());

      final response = await _homeRepository.getMovieRepo();

      if (response.success == true) {

          await StorageServiceMixin().addData<List<MovieList>>(
            MainBoxKeys.allMovies,
            response.response??[],
          );
        emit(HomeGetMovieSuccess(movieList: response));
      } else {
        emit(HomeError(message: 'Failed to Fetch Data'));
      }
    } catch (e) {
      emit(HomeError(message: e.toString()));
    }
  }

}
