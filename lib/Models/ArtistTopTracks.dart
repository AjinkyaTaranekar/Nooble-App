class ArtistTopTracks {
  late List<Tracks> tracks;

  ArtistTopTracks({required this.tracks});

  ArtistTopTracks.fromJson(Map<String, dynamic> json) {
    if (json['tracks'] != null) {
      tracks = [];
      json['tracks'].forEach((v) {
        tracks.add(new Tracks.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tracks'] =  this.tracks.map((v) => v.toJson()).toList();
    return data;
  }
}

class Tracks {
  late Album album;
  late List<Artists> artists;
  late int discNumber;
  late int durationMs;
  late bool explicit;
  late ExternalIds externalIds;
  late ExternalUrls externalUrls;
  late String href;
  late String id;
  late bool isLocal;
  late bool isPlayable;
  late String name;
  late int popularity;
  late String previewUrl;
  late int trackNumber;
  late String type;
  late String uri;

  Tracks(
      {required this.album,
      required this.artists,
      required this.discNumber,
      required this.durationMs,
      required this.explicit,
      required this.externalIds,
      required this.externalUrls,
      required this.href,
      required this.id,
      required this.isLocal,
      required this.isPlayable,
      required this.name,
      required this.popularity,
      required this.previewUrl,
      required this.trackNumber,
      required this.type,
      required this.uri});

  Tracks.fromJson(Map<String, dynamic> json) {
    album = (json['album'] != null ? new Album.fromJson(json['album']) : null)!;
    if (json['artists'] != null) {
      artists = [];
      json['artists'].forEach((v) {
        artists.add(new Artists.fromJson(v));
      });
    }
    discNumber = json['disc_number'];
    durationMs = json['duration_ms'];
    explicit = json['explicit'];
    externalIds = (json['external_ids'] != null
        ? new ExternalIds.fromJson(json['external_ids'])
        : null)!;
    externalUrls = (json['external_urls'] != null
        ? new ExternalUrls.fromJson(json['external_urls'])
        : null)!;
    href = json['href'];
    id = json['id'];
    isLocal = json['is_local'];
    isPlayable = json['is_playable'];
    name = json['name'];
    popularity = json['popularity'];
    previewUrl = json['preview_url'];
    trackNumber = json['track_number'];
    type = json['type'];
    uri = json['uri'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['album'] =  this.album.toJson();
      data['artists'] =  this.artists.map((v) => v.toJson()).toList();
    data['disc_number'] =  this.discNumber;
    data['duration_ms'] =  this.durationMs;
    data['explicit'] =  this.explicit;
      data['external_ids'] =  this.externalIds.toJson();
      data['external_urls'] =  this.externalUrls.toJson();
    data['href'] =  this.href;
    data['id'] =  this.id;
    data['is_local'] =  this.isLocal;
    data['is_playable'] =  this.isPlayable;
    data['name'] =  this.name;
    data['popularity'] =  this.popularity;
    data['preview_url'] =  this.previewUrl;
    data['track_number'] =  this.trackNumber;
    data['type'] =  this.type;
    data['uri'] =  this.uri;
    return data;
  }
}

class Album {
  late String albumType;
  late List<Artists> artists;
  late ExternalUrls externalUrls;
  late String href;
  late String id;
  late List<Images> images;
  late String name;
  late String releaseDate;
  late String releaseDatePrecision;
  late int totalTracks;
  late String type;
  late String uri;

  Album(
      {required this.albumType,
      required this.artists,
      required this.externalUrls,
      required this.href,
      required this.id,
      required this.images,
      required this.name,
      required this.releaseDate,
      required this.releaseDatePrecision,
      required this.totalTracks,
      required this.type,
      required this.uri});

  Album.fromJson(Map<String, dynamic> json) {
    albumType = json['album_type'];
    if (json['artists'] != null) {
      artists = [];
      json['artists'].forEach((v) {
        artists.add(new Artists.fromJson(v));
      });
    }
    externalUrls = (json['external_urls'] != null
        ? new ExternalUrls.fromJson(json['external_urls'])
        : null)!;
    href = json['href'];
    id = json['id'];
    if (json['images'] != null) {
      images = [];
      json['images'].forEach((v) {
        images.add(new Images.fromJson(v));
      });
    }
    name = json['name'];
    releaseDate = json['release_date'];
    releaseDatePrecision = json['release_date_precision'];
    totalTracks = json['total_tracks'];
    type = json['type'];
    uri = json['uri'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['album_type'] =  this.albumType;
      data['artists'] =  this.artists.map((v) => v.toJson()).toList();
      data['external_urls'] =  this.externalUrls.toJson();
    data['href'] =  this.href;
    data['id'] =  this.id;
      data['images'] =  this.images.map((v) => v.toJson()).toList();
    data['name'] =  this.name;
    data['release_date'] =  this.releaseDate;
    data['release_date_precision'] =  this.releaseDatePrecision;
    data['total_tracks'] =  this.totalTracks;
    data['type'] =  this.type;
    data['uri'] =  this.uri;
    return data;
  }
}

class Artists {
  late ExternalUrls externalUrls;
  late String href;
  late String id;
  late String name;
  late String type;
  late String uri;

  Artists(
      {required this.externalUrls, required this.href, required this.id, required this.name, required this.type, required this.uri});

  Artists.fromJson(Map<String, dynamic> json) {
    externalUrls = (json['external_urls'] != null
        ? new ExternalUrls.fromJson(json['external_urls'])
        : null)!;
    href = json['href'];
    id = json['id'];
    name = json['name'];
    type = json['type'];
    uri = json['uri'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
      data['external_urls'] =  this.externalUrls.toJson();
    data['href'] =  this.href;
    data['id'] =  this.id;
    data['name'] =  this.name;
    data['type'] =  this.type;
    data['uri'] =  this.uri;
    return data;
  }
}

class ExternalUrls {
  late String spotify;

  ExternalUrls({required this.spotify});

  ExternalUrls.fromJson(Map<String, dynamic> json) {
    spotify = json['spotify'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['spotify'] =  this.spotify;
    return data;
  }
}

class Images {
  late int height;
  late String url;
  late int width;

  Images({required this.height, required this.url, required this.width});

  Images.fromJson(Map<String, dynamic> json) {
    height = json['height'];
    url = json['url'];
    width = json['width'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['height'] = this.height;
    data['url'] = this.url;
    data['width'] = this.width;
    return data;
  }
}

class ExternalIds {
  late String isrc;

  ExternalIds({required this.isrc});

  ExternalIds.fromJson(Map<String, dynamic> json) {
    isrc = json['isrc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isrc'] =  this.isrc;
    return data;
  }
}
