import 'dart:async';

import 'package:fl_peliculas/helpers/debouncer.dart';
import 'package:fl_peliculas/models/models.dart';
import 'package:fl_peliculas/models/search_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;

class MoviesProvider extends ChangeNotifier {
  final String _baseUrl = 'api.themoviedb.org';
  final String _apiKey = 'fa1b5a24ac342d39a00438f0a98f64ce';
  final String _language = 'es-ES';

  List<Movie> onDisplayMovie = [];

  List<Movie> onPopularMovie = [];
//TODO:movieCast: este mapa funcionara como memoria en cache
  Map<int, List<Cast>> movieCast = {};

  final bebouncer = Debouncer(
    duration: Duration(milliseconds: 500),
    onValue: (value) {},
  );

  final StreamController<List<Movie>> _suggestionStreamController =
      new StreamController.broadcast();

  Stream<List<Movie>> get suggestionStream =>
      _suggestionStreamController.stream;

  int _popularPage = 0;

  MoviesProvider() {
    print('Movies Provider Inicializado');
    getOnDisplayMovie();
    getPopularMovie();
  }
  Future<String> _getJsonData(
      {required String categoryUrl, int? page: 1, String? query}) async {
    final url = Uri.https(_baseUrl, categoryUrl, {
      'api_key': _apiKey,
      'language': _language,
      'page': '$page',
      'query': query
    });

    final response = await http.get(url);
    // print(url);
    return response.body;
  }

  getOnDisplayMovie() async {
    final responseBody = await _getJsonData(categoryUrl: '3/movie/now_playing');

    final nowPlayingResponse = NowPlayingResponse.fromJson(responseBody);
    //TODO:nowPlayingResponse:Con esta variable ya podremos acceder a una base de datos de peliculas

    onDisplayMovie = nowPlayingResponse.results;
    notifyListeners();

    //TODO:notifyListeners: Notifica a todos los witgeds que se redibujen porque hay un cambio en los datos
    // print(onDisplayMovie[0].title);
  }

  getPopularMovie() async {
    // var url = Uri.https(_baseUrl, '3/movie/popular',
    //     {'api_key': _apiKey, 'language': _language, 'page': '1'});

    // final response = await http.get(url);
    _popularPage++;
    final responseBody =
        await _getJsonData(categoryUrl: '3/movie/popular', page: _popularPage);

//    print(responseBody);
    final nowPopularResponse = NowPlayingImg.fromJson(responseBody);

    onPopularMovie = [...onPopularMovie, ...nowPopularResponse.results];
    //  print(onPopularMovie[0]);
    notifyListeners();
  }

  Future<List<Cast>> getmovieCast({required int movieId}) async {
    //aqui estoy preguntando si esta en la memoria que cree el movieCast
    if (movieCast.containsKey(movieId)) return movieCast[movieId]!;

    print('Pidiendo info del servidor - Cast ');

    final jsonData =
        await _getJsonData(categoryUrl: '3/movie/$movieId/credits');

    // print(jsonData);
    // print('$movieId');

    final castResponse = CreditsResponse.fromJson(jsonData);

//TODO:movieCast index: aqui estamos almasenando el http cargado al mapa que tenemos en la app
    movieCast[movieId] = castResponse.cast;
    // print(castResponse.cast);
    return castResponse.cast;
  }

  Future<List<Movie>> getSearchMovie(String query) async {
    print('Pidiendo info del servidor - query  ');

    final jsonData = await _getJsonData(
        categoryUrl: '3/search/movie', page: 1, query: query);

    // print(jsonData);

    final searchResponse = SearchResponse.fromJson(jsonData);
    return searchResponse.results;
  }

  void getSuggestionByQuery(String searchTerm) {
    bebouncer.value = '';
    bebouncer.onValue = (value) async {
      print('tenemos valor a buscar: $value');
      final result = await this.getSearchMovie(searchTerm);
      this._suggestionStreamController.add(result);
    };
    final timer = Timer.periodic(Duration(milliseconds: 300), (_) {
      bebouncer.value = searchTerm;
    });
    Future.delayed(Duration(milliseconds: 301)).then((_) => timer.cancel());
  }
}
