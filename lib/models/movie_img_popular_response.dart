// To parse this JSON data, do
//
//     final nowPlayingImg = nowPlayingImgFromMap(jsonString);

import 'dart:convert';

import 'package:fl_peliculas/models/models.dart';

class NowPlayingImg {
  NowPlayingImg({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  int page;
  List<Movie> results;
  int totalPages;
  int totalResults;

  factory NowPlayingImg.fromJson(String str) =>
      NowPlayingImg.fromMap(json.decode(str));

  factory NowPlayingImg.fromMap(Map<String, dynamic> json) => NowPlayingImg(
        page: json["page"],
        results: List<Movie>.from(json["results"].map((x) => Movie.fromMap(x))),
        totalPages: json["total_pages"],
        totalResults: json["total_results"],
      );
}
