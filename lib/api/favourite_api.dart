import 'dart:convert';
import 'dart:io';

import 'package:musicapp/main.dart';
import 'package:musicapp/models/artist.dart';
import 'package:musicapp/models/track.dart';
import 'package:http/http.dart' as http;

Future<List<Track>> getFavourites() async {
  final response = await http.get(Uri.parse("${url}favourites"));
  if (response.statusCode == 200) {
    final jsonRes = json.decode(response.body);
    var result = jsonRes["results"] as List;
    var list = result.map<Track>((json) => Track.fromJson(json)).toList();
    List<Track> favTracks = [];

    for (int i = 0; i < list.length; i++) {
      var t = await http.get(Uri.parse("${url}tracks/${list[i].id}"));

      if (t.statusCode == 200) {
        final jsonDec = json.decode(t.body);
        Track track = Track.fromJson(jsonDec);
        late Artist art;
        var artist =
            await http.get(Uri.parse("${url}artists/${track.artist_id}"));
        if (artist.statusCode == 200) {
          final jsonDec = json.decode(artist.body);
          art = Artist.fromJson(jsonDec);
        }

        track.artist_name = art.artist_name;
        favTracks.add(track);
      } else {
        return [];
      }
    }

    return favTracks;
  } else {
    return [];
  }
}

Future<bool> addToFavourites(Track track) async {
  final response = await http.post(
    Uri.parse("${url}favourites"),
    headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
    },
    body: json.encode(
      <String, dynamic>{
        'track_id': track.id,
        "user_FUI": track.track_name.toString(),
      },
    ),
  );
  // print("response " + response.body);
  if (response.statusCode == 201) {
    print("Success");
    return true;
  } else if (response.statusCode == 400) {
    print("Redundant!");
    return false;
  } else {
    print("Other Errors");
    return false;
  }
}

Future deleteFromFavourite(int trackId) async {
  final response = await http.delete(
    Uri.parse("${url}favourites/$trackId"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );
  print(response.body);
  print(response.statusCode);
}
