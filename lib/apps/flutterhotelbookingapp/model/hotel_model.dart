import 'dart:convert';

HotelModel hotelModelFromJson(String str) =>
    HotelModel.fromJson(json.decode(str) as Map<String, dynamic>);

String hotelModelToJson(HotelModel data) => json.encode(data.toJson());

class HotelModel {
  final List<int>? specialAmenities;
  final Facets? facets;
  final int? total;
  final int? page;
  final List<Hotel>? hotels;

  HotelModel({
    this.specialAmenities,
    this.facets,
    this.total,
    this.page,
    this.hotels,
  });

  factory HotelModel.fromJson(Map<String, dynamic> json) => HotelModel(
    specialAmenities: (json['special_amenities'] as List<dynamic>?)
        ?.map((x) => x as int)
        .toList(),
    facets: json['facets'] == null
        ? null
        : Facets.fromJson(json['facets'] as Map<String, dynamic>),
    total: json['total'] as int?,
    page: json['page'] as int?,
    hotels: (json['hotels'] as List<dynamic>?)
        ?.map((x) => Hotel.fromJson(x as Map<String, dynamic>))
        .toList(),
  );

  Map<String, dynamic> toJson() => {
    'special_amenities': specialAmenities,
    'facets': facets?.toJson(),
    'total': total,
    'page': page,
    'hotels': hotels?.map((x) => x.toJson()).toList(),
  };
}

class Facets {
  final List<List<int>> neighborhood;
  final List<List<dynamic>> features;
  final List<Model> neighborhoodModels;
  final List<Model> propertyTypeModels;
  final List<FeaturesModel> featuresModels;
  final List<List<int>> propertyType;

  Facets({
    required this.neighborhood,
    required this.features,
    required this.neighborhoodModels,
    required this.propertyTypeModels,
    required this.featuresModels,
    required this.propertyType,
  });

  factory Facets.fromJson(Map<String, dynamic> json) => Facets(
    neighborhood: (json['neighborhood'] as List<dynamic>? ?? [])
        .map((x) => (x as List<dynamic>).map((e) => e as int).toList())
        .toList(),
    features: (json['features'] as List<dynamic>? ?? [])
        .map((x) => List<dynamic>.from(x as List))
        .toList(),
    neighborhoodModels: (json['neighborhood_models'] as List<dynamic>? ?? [])
        .map((x) => Model.fromJson(x as Map<String, dynamic>))
        .toList(),
    propertyTypeModels: (json['property_type_models'] as List<dynamic>? ?? [])
        .map((x) => Model.fromJson(x as Map<String, dynamic>))
        .toList(),
    featuresModels: (json['features_models'] as List<dynamic>? ?? [])
        .map((x) => FeaturesModel.fromJson(x as Map<String, dynamic>))
        .toList(),
    propertyType: (json['property_type'] as List<dynamic>? ?? [])
        .map((x) => (x as List<dynamic>).map((e) => e as int).toList())
        .toList(),
  );

  Map<String, dynamic> toJson() => {
    'neighborhood': neighborhood,
    'features': features,
    'neighborhood_models': neighborhoodModels.map((x) => x.toJson()).toList(),
    'property_type_models': propertyTypeModels.map((x) => x.toJson()).toList(),
    'features_models': featuresModels.map((x) => x.toJson()).toList(),
    'property_type': propertyType,
  };
}

class FeaturesModel {
  final String? icon;
  final int? id;
  final String? name;

  FeaturesModel({this.icon, this.id, this.name});

  factory FeaturesModel.fromJson(Map<String, dynamic> json) => FeaturesModel(
    icon: json['icon'] as String?,
    id: json['id'] as int?,
    name: json['name'] as String?,
  );

  Map<String, dynamic> toJson() => {'icon': icon, 'id': id, 'name': name};
}

class Model {
  final int? id;
  final String? name;

  Model({this.id, this.name});

  factory Model.fromJson(Map<String, dynamic> json) =>
      Model(id: json['id'] as int?, name: json['name'] as String?);

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}

class Hotel {
  final int? rating;
  final List<int>? payInfo;
  final String? pin;
  final String? cancellationPolicy;
  final double? rate;
  final CheckTime? checkInTime;
  final bool? image360Enabled;
  final String? id;
  final int? hasPanoramaImages;
  final int? reviewCount;
  final dynamic review;
  final CheckTime? checkOutTime;
  final List<int>? amenities;
  final String? location;
  final Offline? offline;
  final Type? type;
  final String? thumbnail;
  final double? locationRating;
  final String? tags;
  final bool? crsSpecial;
  final double? minRate;
  final String? slug;
  final String? name;
  final double? discount;
  final List<int>? vatTax;

  Hotel({
    this.rating,
    this.payInfo,
    this.pin,
    this.cancellationPolicy,
    this.rate,
    this.checkInTime,
    this.image360Enabled,
    this.id,
    this.hasPanoramaImages,
    this.reviewCount,
    this.review,
    this.checkOutTime,
    this.amenities,
    this.location,
    this.offline,
    this.type,
    this.thumbnail,
    this.locationRating,
    this.tags,
    this.crsSpecial,
    this.minRate,
    this.slug,
    this.name,
    this.discount,
    this.vatTax,
  });

  factory Hotel.fromJson(Map<String, dynamic> json) => Hotel(
    rating: json['rating'] as int?,
    payInfo: (json['pay_info'] as List<dynamic>?)
        ?.map((x) => x as int)
        .toList(),
    pin: json['pin'] as String?,
    cancellationPolicy: json['cancellation_policy'] as String?,
    rate: (json['rate'] as num?)?.toDouble(),
    checkInTime: checkTimeValues.map[json['check_in_time']],
    image360Enabled: json['image_360_enabled'] as bool?,
    id: json['id'] as String?,
    hasPanoramaImages: json['hasPanoramaImages'] as int?,
    reviewCount: json['review_count'] as int?,
    review: json['review'],
    checkOutTime: checkTimeValues.map[json['check_out_time']],
    amenities: (json['amenities'] as List<dynamic>?)
        ?.map((x) => x as int)
        .toList(),
    location: json['location'] as String?,
    offline: json['offline'] == null
        ? null
        : Offline.fromJson(json['offline'] as Map<String, dynamic>),
    type: typeValues.map[json['type']],
    thumbnail: json['thumbnail'] as String?,
    locationRating: (json['location_rating'] as num?)?.toDouble(),
    tags: json['tags'] as String?,
    crsSpecial: json['crs_special'] as bool?,
    minRate: (json['min_rate'] as num?)?.toDouble(),
    slug: json['slug'] as String?,
    name: json['name'] as String?,
    discount: (json['discount'] as num?)?.toDouble(),
    vatTax: (json['vat_tax'] as List<dynamic>?)?.map((x) => x as int).toList(),
  );

  Map<String, dynamic> toJson() => {
    'rating': rating,
    'pay_info': payInfo,
    'pin': pin,
    'cancellation_policy': cancellationPolicy,
    'rate': rate,
    'check_in_time': checkInTime == null
        ? null
        : checkTimeValues.reverse[checkInTime],
    'image_360_enabled': image360Enabled,
    'id': id,
    'hasPanoramaImages': hasPanoramaImages,
    'review_count': reviewCount,
    'review': review,
    'check_out_time': checkOutTime == null
        ? null
        : checkTimeValues.reverse[checkOutTime],
    'amenities': amenities,
    'location': location,
    'offline': offline?.toJson(),
    'type': type == null ? null : typeValues.reverse[type],
    'thumbnail': thumbnail,
    'location_rating': locationRating,
    'tags': tags,
    'crs_special': crsSpecial,
    'min_rate': minRate,
    'slug': slug,
    'name': name,
    'discount': discount,
    'vat_tax': vatTax,
  };
}

enum CheckTime { the1200Pm, the1130Am, the1100Am }

final checkTimeValues = EnumValues<CheckTime>({
  '11:00 AM': CheckTime.the1100Am,
  '11:30 AM': CheckTime.the1130Am,
  '12:00 PM': CheckTime.the1200Pm,
});

class Offline {
  final bool? status;
  final DisplayText? displayText;

  Offline({this.status, this.displayText});

  factory Offline.fromJson(Map<String, dynamic> json) => Offline(
    status: json['status'] as bool?,
    displayText: displayTextValues.map[json['display_text']],
  );

  Map<String, dynamic> toJson() => {
    'status': status,
    'display_text': displayText == null
        ? null
        : displayTextValues.reverse[displayText],
  };
}

enum DisplayText { contactUs, empty }

final displayTextValues = EnumValues<DisplayText>({
  'Contact Us': DisplayText.contactUs,
  '': DisplayText.empty,
});

enum Type { hotel, guestHouse, motel }

final typeValues = EnumValues<Type>({
  'Guest House': Type.guestHouse,
  'Hotel': Type.hotel,
  'Motel': Type.motel,
});

class EnumValues<T> {
  final Map<String, T> map;
  Map<T, String>? _reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    return _reverseMap ??= map.map((key, value) => MapEntry(value, key));
  }
}
