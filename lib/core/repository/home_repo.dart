import 'package:edstem_machine_test/core/endpoints/endpoints.dart';
import 'package:edstem_machine_test/core/services/network_service/network_services.dart';
import 'package:edstem_machine_test/ui/home_screen/models/get_movie_res_model.dart';

abstract class HomeRepository {
  Future<GetMovieResModel> getMovieRepo();
}

class HomeRepositoryImpl implements HomeRepository {
  final NetworkService _networkService;

  HomeRepositoryImpl(this._networkService);

  @override
  Future<GetMovieResModel> getMovieRepo( ) async {
    try {
      final response = await _networkService.get(
        EndPoints.getMovies,

      );
      return GetMovieResModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to Fetch Data');
    }
  }

}