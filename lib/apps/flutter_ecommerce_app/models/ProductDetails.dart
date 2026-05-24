class ProductDetails {
  final bool? success;
  final String? message;
  final Data? data;

  ProductDetails({
    this.success,
    this.message,
    this.data,
  });

  factory ProductDetails.fromJson(Map<String, dynamic> json) {
    return ProductDetails(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? Data.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class Data {
  final List<Attributes> attributes;
  final List<ProductVariants> productVariants;
  final List<ProductSpecifications> productSpecifications;

  Data({
    required this.attributes,
    required this.productVariants,
    required this.productSpecifications,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      attributes: (json['attributes'] as List? ?? [])
          .map((v) => Attributes.fromJson(v))
          .toList(),
      productVariants: (json['product_variants'] as List? ?? [])
          .map((v) => ProductVariants.fromJson(v))
          .toList(),
      productSpecifications: (json['product_specifications'] as List? ?? [])
          .map((v) => ProductSpecifications.fromJson(v))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'attributes': attributes.map((v) => v.toJson()).toList(),
      'product_variants': productVariants.map((v) => v.toJson()).toList(),
      'product_specifications':
          productSpecifications.map((v) => v.toJson()).toList(),
    };
  }
}

class Attributes {
  final String attributeSlug;
  final String attributeName;
  final List<AttributeValues> attributeValues;

  Attributes({
    required this.attributeSlug,
    required this.attributeName,
    required this.attributeValues,
  });

  factory Attributes.fromJson(Map<String, dynamic> json) {
    return Attributes(
      attributeSlug: json['attribute_slug'] ?? '',
      attributeName: json['attribute_name'] ?? '',
      attributeValues: (json['attribute_values'] as List? ?? [])
          .map((v) => AttributeValues.fromJson(v))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'attribute_slug': attributeSlug,
      'attribute_name': attributeName,
      'attribute_values':
          attributeValues.map((v) => v.toJson()).toList(),
    };
  }
}

class AttributeValues {
  final String value;
  final int key;

  AttributeValues({
    required this.value,
    required this.key,
  });

  factory AttributeValues.fromJson(Map<String, dynamic> json) {
    return AttributeValues(
      value: json['value'] ?? '',
      key: json['key'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'key': key,
    };
  }
}

class ProductVariants {
  final String sku;
  final int variantId;
  final String productName;
  final int approved;
  final double? minPrice;
  final double? maxPrice;
  final String productDescription;
  final String brandName;
  final String brandSlug;
  final String categorySlug;
  final int categoryId;
  final String categoryName;
  final List<int> attributeValues;
  final List<String> productImages;
  final String colorImage;

  ProductVariants({
    required this.sku,
    required this.variantId,
    required this.productName,
    required this.approved,
    this.minPrice,
    this.maxPrice,
    required this.productDescription,
    required this.brandName,
    required this.brandSlug,
    required this.categorySlug,
    required this.categoryId,
    required this.categoryName,
    required this.attributeValues,
    required this.productImages,
    required this.colorImage,
  });

  factory ProductVariants.fromJson(Map<String, dynamic> json) {
    return ProductVariants(
      sku: json['sku'] ?? '',
      variantId: json['variant_id'] ?? 0,
      productName: json['product_name'] ?? '',
      approved: json['approved'] ?? 0,
      minPrice: (json['min_price'] as num?)?.toDouble(),
      maxPrice: (json['max_price'] as num?)?.toDouble(),
      productDescription: json['product_description'] ?? '',
      brandName: json['brand_name'] ?? '',
      brandSlug: json['brand_slug'] ?? '',
      categorySlug: json['category_slug'] ?? '',
      categoryId: json['category_id'] ?? 0,
      categoryName: json['category_name'] ?? '',
      attributeValues: List<int>.from(json['attribute_values'] ?? []),
      productImages: List<String>.from(json['product_images'] ?? []),
      colorImage: json['color_image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sku': sku,
      'variant_id': variantId,
      'product_name': productName,
      'approved': approved,
      'min_price': minPrice,
      'max_price': maxPrice,
      'product_description': productDescription,
      'brand_name': brandName,
      'brand_slug': brandSlug,
      'category_slug': categorySlug,
      'category_id': categoryId,
      'category_name': categoryName,
      'attribute_values': attributeValues,
      'product_images': productImages,
      'color_image': colorImage,
    };
  }
}

class ProductSpecifications {
  final int id;
  final String specificationName;
  final String specificationValue;

  ProductSpecifications({
    required this.id,
    required this.specificationName,
    required this.specificationValue,
  });

  factory ProductSpecifications.fromJson(Map<String, dynamic> json) {
    return ProductSpecifications(
      id: json['id'] ?? 0,
      specificationName: json['specification_name'] ?? '',
      specificationValue: json['specification_value'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'specification_name': specificationName,
      'specification_value': specificationValue,
    };
  }
}