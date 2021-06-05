class City {
  final String name;
  final String code;
  final String country;

  City({
    required this.name,
    required this.code,
    required this.country,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      name: json['EnglishName'],
      code: json['EnglishName'],
      country: json['Country']['EnglishName'],
    );
  }

  static List<City> fromJsonList(List<dynamic> json) {
    List<City> cities = [];

    json.forEach((cityJson) {
      cities.add(City.fromJson(cityJson));
    });

    return cities;
  }

  String toFullName() {
    return "${this.name}, ${this.country}";
  }
}