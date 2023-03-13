import 'package:flutter/material.dart';
import 'package:musicapp/api/artist_api.dart';
import 'package:musicapp/models/artist.dart';

class ArtistProvider extends ChangeNotifier {
  List<Artist> _allArtists = [];
  bool isArtistLoading = false;

  List<Artist> get artists => _allArtists;

  Future<List<Artist>> getAllArtists() async {
    isArtistLoading = true;

    _allArtists = await getArtists();
    isArtistLoading = false;
    notifyListeners();
    return _allArtists;
  }
}
