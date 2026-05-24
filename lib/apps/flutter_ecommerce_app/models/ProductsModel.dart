class ProductsModels {
  final int? count;
  final String? next;
  final String? previous;
  final List<Results>? results;

  ProductsModels({
     this.count,
     this.next,
     this.previous,
     this.results,
  });

  factory ProductsModels.fromJson(Map<String, dynamic> json) {
    return ProductsModels(
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
      'results': results!.map((v) => v.toJson()).toList(),
    };
  }
}

class Results {
  final String name;
  final String slug;
  final List<String> imageUrls;
  final String priceType;
  final String maxPrice;
  final String minPrice;
  final String minDiscountedPrice;

  Results({
    required this.name,
    required this.slug,
    required this.imageUrls,
    required this.priceType,
    required this.maxPrice,
    required this.minPrice,
    required this.minDiscountedPrice,
  });

  factory Results.fromJson(Map<String, dynamic> json) {
    return Results(
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      imageUrls: List<String>.from(json['image_urls'] ?? []),
      priceType: json['price_type'] ?? '',
      maxPrice: json['max_price']?.toString() ?? '',
      minPrice: json['min_price']?.toString() ?? '',
      minDiscountedPrice:
          json['min_discounted_price']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'slug': slug,
      'image_urls': imageUrls,
      'price_type': priceType,
      'max_price': maxPrice,
      'min_price': minPrice,
      'min_discounted_price': minDiscountedPrice,
    };
  }
}