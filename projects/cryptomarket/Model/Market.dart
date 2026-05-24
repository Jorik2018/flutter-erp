class Market {
  String name;
  String logoUrl;

  Market(this.name, this.logoUrl);

  Market.fromMap(Map<String, dynamic> map)
      : name = map['Name'] ?? '',
        logoUrl = map['LogoUrl'] ?? '';
}