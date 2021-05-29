class CurrentWeather {
  final String main;
  final String description;
  final double temp;
  final double tempMin;
  final double tempMax;
  final double windSpeed;

  CurrentWeather({
    required this.main,
    required this.description,
    required this.temp,
    required this.tempMin,
    required this.tempMax,
    required this.windSpeed,
  });

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    return CurrentWeather(
      main: json['weather'][0]['main'],
      description: json['weather'][0]['description'],
      temp: json['main']['temp'],
      tempMin: json['main']['temp_min'],
      tempMax: json['main']['temp_max'],
      windSpeed: json['wind']['speed'],
    );
  }

  String toString() {
    return
        "Weather:               " + this.main + "\n" +
        "Description:           " + this.description + "\n" +
        "Temperature (current): " + this.temp.toString() + "\n" +
        "Temperature (min):     " + this.tempMin.toString() + "\n" +
        "Temperature (max):     " + this.tempMax.toString() + "\n" +
        "Wind speed:            " + this.windSpeed.toString();
  }
}