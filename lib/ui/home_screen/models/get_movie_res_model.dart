import 'dart:convert';

import 'package:hive_flutter/adapters.dart';
part 'get_movie_res_model.g.dart';

GetMovieResModel getMovieResModelFromJson(String str) => GetMovieResModel.fromJson(json.decode(str));

String getMovieResModelToJson(GetMovieResModel data) => json.encode(data.toJson());

@HiveType(typeId: 1)
class GetMovieResModel {
  @HiveField(1)
  final bool? success;
  @HiveField(2)
  final List<MovieList>? response;

  GetMovieResModel({
    this.success,
    this.response,
  });

  factory GetMovieResModel.fromJson(Map<String, dynamic> json) => GetMovieResModel(
    success: json["success"],
    response: json["response"] == null ? [] : List<MovieList>.from(json["response"]!.map((x) => MovieList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "response": response == null ? [] : List<dynamic>.from(response!.map((x) => x.toJson())),
  };
}

@HiveType(typeId: 2)
class MovieList {
  @HiveField(1)
  final String? id;
  @HiveField(2)
  final String? title;
  @HiveField(3)
  final int? year;
  @HiveField(4)
  final String? runningTime;
  @HiveField(5)
  final String? description;
  @HiveField(6)
  final List<String>? genre;
  @HiveField(7)
  final String? poster;
  @HiveField(8)
  final String? slug;
  @HiveField(9)
  final int? v;

  MovieList({
    this.id,
    this.title,
    this.year,
    this.runningTime,
    this.description,
    this.genre,
    this.poster,
    this.slug,
    this.v,
  });

  factory MovieList.fromJson(Map<String, dynamic> json) => MovieList(
    id: json["_id"],
    title: json["title"],
    year: json["year"],
    runningTime: json["runningTime"],
    description: json["description"],
    genre: json["genre"] == null ? [] : List<String>.from(json["genre"]!.map((x) => x)),
    poster: json["poster"],
    slug: json["slug"],
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "title": title,
    "year": year,
    "runningTime": runningTime,
    "description": description,
    "genre": genre == null ? [] : List<dynamic>.from(genre!.map((x) => x)),
    "poster": poster,
    "slug": slug,
    "__v": v,
  };
}
