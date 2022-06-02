import 'package:fl_peliculas/providers/movie_provider.dart';
import 'package:flutter/material.dart';
import 'package:fl_peliculas/models/models.dart';
import 'package:provider/provider.dart';

class CastingCards extends StatelessWidget {
  final int movieId;

  const CastingCards({required this.movieId});
  @override
  Widget build(BuildContext context) {
    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);

    return FutureBuilder(
        future: moviesProvider.getmovieCast(movieId: movieId),
        builder: (BuildContext context, AsyncSnapshot<List<Cast>> snapshot) {
          // print(snapshot.hasData);
          if (!snapshot.hasData) {
            return Container(
                margin: const EdgeInsets.only(bottom: 30),
                width: double.infinity,
                height: 180,
                child: const LinearProgressIndicator(color: Colors.indigo));
          }

          final List<Cast> cast = snapshot.data!;
          //print(cast.length);

          return Container(
            margin: const EdgeInsets.only(bottom: 30),
            width: double.infinity,
            height: 180,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: (_, i) => _CastCard(cast[i]),
              itemCount: cast.length,
            ),
          );
        });
  }
}

class _CastCard extends StatelessWidget {
  final Cast actorCast;

  _CastCard(this.actorCast);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      width: 100,
      height: 110,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: FadeInImage(
                width: 100,
                height: 140,
                fit: BoxFit.cover,
                placeholder: const AssetImage('assets/no-image.jpg'),
                image: NetworkImage(actorCast.fullProfileImg)),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            actorCast.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
