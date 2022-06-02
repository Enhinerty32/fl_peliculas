import 'package:fl_peliculas/models/models.dart';
import 'package:fl_peliculas/providers/movie_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MovieSearchDelegate extends SearchDelegate {
  String? get searchFieldLabel => 'Buscar Pelicula';
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [IconButton(onPressed: () => query = '', icon: Icon(Icons.clear))];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () => close(context, null), icon: Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);
    if (query.isEmpty) {
      return isEmpty();
    }

    return FutureBuilder(
      future: moviesProvider.getSearchMovie(query),
      builder: (_, AsyncSnapshot<List<Movie>> snapshot) {
        if (!snapshot.hasData) {
          return isEmpty();
        }
        final List<Movie> moviesShearch = snapshot.data!;
        // moviesShearch;
        //   print('demonle');
        return ListView.builder(
            itemCount: moviesShearch.length,
            itemBuilder: (BuildContext context, int i) =>
                _MovieItems(movie: moviesShearch[i]));
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return isEmpty();
    }
    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);

    print('peticion query');
    moviesProvider.getSuggestionByQuery(query);

    return StreamBuilder(
      stream: moviesProvider.suggestionStream,
      builder: (_, AsyncSnapshot<List<Movie>> snapshot) {
        if (!snapshot.hasData) {
          return isEmpty();
        }

        print('peticion http');

        final List<Movie> moviesShearch = snapshot.data!;
        // moviesShearch;
        //   print('demonle');
        return ListView.builder(
            itemCount: moviesShearch.length,
            itemBuilder: (BuildContext context, int i) =>
                _MovieItems(movie: moviesShearch[i]));
      },
    );
  }

  Widget isEmpty() {
    return Container(
      child: const Center(
        child: Icon(
          Icons.movie_creation,
          color: Colors.black38,
          size: 125,
        ),
      ),
    );
  }
}

class _MovieItems extends StatelessWidget {
  final Movie movie;

  const _MovieItems({required this.movie});

  @override
  Widget build(BuildContext context) {
    movie.heroId = 'Search-${movie.id}';
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: ListTile(
        title: Text(movie.title),
        subtitle: Text(movie.originalTitle),
        leading: Hero(
          tag: movie.heroId!,
          child: FadeInImage(
            image: NetworkImage(movie.fullPosterImg),
            placeholder: AssetImage('assets/no-image.jpg'),
            width: 50,
            fit: BoxFit.contain,
          ),
        ),
        onTap: () => Navigator.pushNamed(context, 'details', arguments: movie),
      ),
    );
  }
}
