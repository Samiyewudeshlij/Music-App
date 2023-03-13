import 'dart:convert';
import 'package:musicapp/main.dart';
import 'package:musicapp/models/album.dart';
import 'package:http/http.dart' as http;

Future<List<Album>> getAlbums() async {
  final response = await http.get(Uri.parse("${url}albums"));
  print(response.body);
  if (response.statusCode == 200) {
    final jsonRes = json.decode(response.body);
    var result = jsonRes["results"] as List;
    var list = result.map<Album>((json) => Album.fromJson(json)).toList();
    return list;
  } else {
    return [];
  }
}
