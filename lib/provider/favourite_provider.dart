import 'package:flutter/material.dart';
import 'package:musicapp/api/favourite_api.dart';
import 'package:musicapp/models/track.dart';

class FavouriteProvider extends ChangeNotifier {
  List<Track> _allFavouriteTracks = [];
  bool isFavourite = false;
  bool isFavouriteTrackLoading = false;

  List<Track> get favoriteTracks => _allFavouriteTracks;

  Future<List<Track>> getAllFavouriteTracks() async {
    isFavouriteTrackLoading = true;
    _allFavouriteTracks = await getFavourites();
    isFavouriteTrackLoading = false;
    notifyListeners();
    return _allFavouriteTracks;
  }

  Future<bool> addToFavouriteTracks(Track track) async {
    _allFavouriteTracks.add(track);
    isFavouriteTrackLoading = true;
    isFavourite = await addToFavourites(track);
    isFavouriteTrackLoading = false;
    notifyListeners();
    return isFavourite;
  }

  void deleteTrackFromFavorites(Track track) async {
    _allFavouriteTracks.remove(track);
    notifyListeners();
  }

// it also possible by adding isFavourite default false attribute for Track class
  List<bool> check(List<Track> tracks) {
    List<bool> checkResult = [];
    bool res = false;
    for (int i = 0; i < tracks.length; i++) {
      innerloop:
      for (int j = 0; j < favoriteTracks.length; j++) {
        if (favoriteTracks[j].id == tracks[i].id) {
          res = true;
          break innerloop;
        }
        res = false;
      }

      checkResult.add(res);
    }
    return checkResult;
  }
}
