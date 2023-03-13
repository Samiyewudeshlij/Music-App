import 'dart:convert';

import 'package:musicapp/main.dart';
import 'package:musicapp/models/artist.dart';
import 'package:http/http.dart' as http;

Future<List<Artist>> getArtists() async {
  final response = await http.get(Uri.parse("${url}artists"));
  print(response.body);
  if (response.statusCode == 200) {
    final jsonRes = json.decode(response.body);
    var result = jsonRes["results"] as List;
    var list = result.map<Artist>((json) => Artist.fromJson(json)).toList();
    return list;
  } else {
    return [];
  }
}
