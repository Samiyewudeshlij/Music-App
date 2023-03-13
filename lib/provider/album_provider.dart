import 'package:flutter/material.dart';
import 'package:musicapp/api/album_api.dart';
import 'package:musicapp/models/album.dart';

class AlbumProvider extends ChangeNotifier {
  List<Album> _allAlbums = [];
  bool isAlbumLoading = false;

  List<Album> get albums => _allAlbums;

  Future<List<Album>> getAllAlbums() async {
    print("smart");
    isAlbumLoading = true;

    _allAlbums = await getAlbums();
    isAlbumLoading = false;
    notifyListeners();
    return _allAlbums;
  }
}
