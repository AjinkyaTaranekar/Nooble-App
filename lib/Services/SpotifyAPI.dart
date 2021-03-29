import 'dart:convert';

import 'package:http/http.dart';
import 'dart:core';

import 'package:nooble/Models/ArtistTopTracks.dart';

class SpotifyApi {
  String searchEndpoint = "https://api.spotify.com/v1/search?";
  bool isValid = false;
  Map<String, String> headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
  };
  
  // Get a list of albums from a list of albumIds.
  Future<Response> getAlbumsById(List<String> ids) async {
    String idListString = ids.join(',');
    String query = "https://api.spotify.com/v1/albums?ids=$idListString";

    return await get(Uri.parse(query), headers: headers);
  }

  // Get a list of 20 albums from a query.
  Future<Response> getAlbumsByQuery(String q) async {
    String query = 'q=$q&type=album&limit=20';
    return await get(Uri.parse(searchEndpoint+query), headers: headers);
  }

  // Get a list of simple artist object from a query
  Future<Response> getArtistsByQuery(String q) async {
    String query =
        'https://api.spotify.com/v1/search?q=$q&type=artist&limit=20';
    return await get(Uri.parse(query), headers: headers);
  }

  // Get a list of artists from a list of artistIds.
  Future<Response> getArtistsById(List<String> idList) async {
    String idString = idList.join(',');
    String query = 'https://api.spotify.com/v1/artists?ids=$idString';
    return await get(Uri.parse(query), headers: headers);
  }

  // Get an artist from an artistId.
  Future<Response> getArtistById(String id) async {
    String query = 'https://api.spotify.com/v1/artists/$id';
    return await get(Uri.parse(query), headers: headers);
  }

  // Get a list of albums from an artist's id.
  Future<Response> getArtistAlbums(String artistId, String country) async {
    String query =
        "https://api.spotify.com/v1/artists/$artistId/albums?limit=50&country=$country";
    return await get(Uri.parse(query), headers: headers);
  }

  // Get a list of top tracks from an artist's id.
  Future<ArtistTopTracks> getTopTracks(String artistId, String country, String token) async {
    headers["Authorization"] = "Bearer $token";
    String query =
        "https://api.spotify.com/v1/artists/$artistId/top-tracks?country=$country";
    Response res = await get(Uri.parse(query), headers: headers);
    //print(res.body);
    ArtistTopTracks body = ArtistTopTracks.fromJson(jsonDecode(res.body));
    return body;
  }
}