class Boats {
  final String imgUrl;
  final String name;
  final String manufacturer;
  final String description;
  final Map<String, dynamic>? specs;

  Boats({
    required this.imgUrl,
    required this.name,
    required this.manufacturer,
    required this.description,
    this.specs,
  });
}
