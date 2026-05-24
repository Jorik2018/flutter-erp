class BrandModel {
  final int count;
  final String? next;
  final String? previous;
  final List<Results> results;

  BrandModel({
    required this.count,
    required this.next,
    required this.previous,
    required this.results,
  });

  factory BrandModel.fromJson(Map<String, dynamic> json) {
    return BrandModel(
      count: json['count'] ?? 0,
      next: json['next'],
      previous: json['previous'],
      results: (json['results'] as List? ?? [])
          .map((v) => Results.fromJson(v))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'count': count,
      'next': next,
      'previous': previous,
      'results': results.map((v) => v.toJson()).toList(),
    };
  }
}

class Results {
  final String name;
  final String slug;
  final String imageUrl;

  Results({
    required this.name,
    required this.slug,
    required this.imageUrl,
  });

  factory Results.fromJson(Map<String, dynamic> json) {
    return Results(
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      imageUrl: json['image_url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'slug': slug,
      'image_url': imageUrl,
    };
  }
}