// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_movie_res_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GetMovieResModelAdapter extends TypeAdapter<GetMovieResModel> {
  @override
  final int typeId = 1;

  @override
  GetMovieResModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GetMovieResModel(
      success: fields[1] as bool?,
      response: (fields[2] as List?)?.cast<MovieList>(),
    );
  }

  @override
  void write(BinaryWriter writer, GetMovieResModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(1)
      ..write(obj.success)
      ..writeByte(2)
      ..write(obj.response);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GetMovieResModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MovieListAdapter extends TypeAdapter<MovieList> {
  @override
  final int typeId = 2;

  @override
  MovieList read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MovieList(
      id: fields[1] as String?,
      title: fields[2] as String?,
      year: fields[3] as int?,
      runningTime: fields[4] as String?,
      description: fields[5] as String?,
      genre: (fields[6] as List?)?.cast<String>(),
      poster: fields[7] as String?,
      slug: fields[8] as String?,
      v: fields[9] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, MovieList obj) {
    writer
      ..writeByte(9)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.year)
      ..writeByte(4)
      ..write(obj.runningTime)
      ..writeByte(5)
      ..write(obj.description)
      ..writeByte(6)
      ..write(obj.genre)
      ..writeByte(7)
      ..write(obj.poster)
      ..writeByte(8)
      ..write(obj.slug)
      ..writeByte(9)
      ..write(obj.v);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MovieListAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
