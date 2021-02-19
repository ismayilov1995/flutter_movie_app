class ProductionCompany {
  ProductionCompany({
    this.id,
    this.logoPath,
    this.name,
    this.originCountry,
  });

  int id;
  String logoPath;
  String name;
  String originCountry;

  factory ProductionCompany.fromMap(Map<String, dynamic> json) {
    if (json == null) return ProductionCompany();
    return ProductionCompany(
      id: json["id"],
      logoPath: json["logo_path"] == null ? null : json["logo_path"],
      name: json["name"],
      originCountry: json["origin_country"],
    );
  }
}