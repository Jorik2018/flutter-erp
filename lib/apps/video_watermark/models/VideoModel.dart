class VideoModel {
  int? _id;
  String _vidName;
  String _vidPath;
  String? _address;
  String _latitute;
  String _longitute;
  String _thumbnail;
  String _cloudStatus;
  String _time;

  VideoModel(
    this._vidName,
    this._vidPath,
    this._latitute,
    this._longitute,
    this._thumbnail,
    this._cloudStatus,
    this._time, {
    String? address,
  }) : _address = address;

  VideoModel.withId(
    this._id,
    this._vidName,
    this._vidPath,
    this._latitute,
    this._longitute,
    this._thumbnail,
    this._cloudStatus,
    this._time, {
    String? address,
  }) : _address = address;

  int? get id => _id;

  String get vidName => _vidName;

  String get vidPath => _vidPath;

  String? get address => _address;

  String get latitute => _latitute;

  String get longitute => _longitute;

  String get thumbnail => _thumbnail;

  String get cloudStatus => _cloudStatus;

  String get time => _time;

  set vidName(String newVid) {
    if (newVid.length <= 255) {
      _vidName = newVid;
    }
  }

  set vidPath(String newVidPath) {
    if (newVidPath.length <= 255) {
      _vidName = newVidPath;
    }
  }

  set address(String newAddress) {
    if (newAddress.length <= 255) {
      _address = newAddress;
    }
  }

  set latitute(String newLat) {
    if (newLat.length <= 255) {
      _latitute = newLat;
    }
  }

  set longitute(String newLong) {
    if (newLong.length <= 255) {
      _longitute = newLong;
    }
  }

  set thumbnail(String newthumbnail) {
    if (newthumbnail.length <= 255) {
      _thumbnail = newthumbnail;
    }
  }

  set cloudStatus(String status) {
    if (status.length <= 255) {
      _cloudStatus = status;
    }
  }

  set time(String newTime) {
    _time = newTime;
  }

  // Convert a Note object into a Map object
 Map<String, dynamic> toMap() {
    return {
      if (_id != null) 'id': _id,
      'vidName': _vidName,
      'vidPath': _vidPath,
      'address': _address,
      'longitute': _longitute,
      'latitute': _latitute,
      'thumbnail': _thumbnail,
      'cloudStatus': _cloudStatus,
      'time': _time,
    };
  }

  // Extract a Note object from a Map object
  factory VideoModel.fromMapObject(Map<String, dynamic> map) {
    return VideoModel.withId(
      map['id'],
      map['vidName'] ?? '',
      map['vidPath'] ?? '',
      map['latitute'] ?? '',
      map['longitute'] ?? '',
      map['thumbnail'] ?? '',
      map['cloudStatus'] ?? '',
      map['time'] ?? '',
      address: map['address'],
    );
  }
}
