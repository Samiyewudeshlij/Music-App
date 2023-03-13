import 'dart:convert';

import 'package:musicapp/main.dart';
import 'package:musicapp/models/track.dart';
import 'package:http/http.dart' as http;

Future<List<Track>> getTracks() async {
  final response = await http.get(Uri.parse("${url}tracks"));
  print(response.body);
  if (response.statusCode == 200) {
    final jsonRes = json.decode(response.body);
    var result = jsonRes["results"] as List;
    var list = result.map<Track>((json) => Track.fromJson(json)).toList();
    return list;
  } else {
    return [];
  }
}
