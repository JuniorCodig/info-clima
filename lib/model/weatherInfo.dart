class WeatherInfo {
  final String location;
  final String region;
  final String country;
  final double tempC;
  final String conditionText;
  final String conditionIcon;
  final double windMph;
  final double pressureMb;
  final int humidity;
  final int cloud;
  final double feelslikeC;
  final double visKm;
  final double uv;

  WeatherInfo({
    required this.location,
    required this.region,
    required this.country,
    required this.tempC,
    required this.conditionText,
    required this.conditionIcon,
    required this.windMph,
    required this.pressureMb,
    required this.humidity,
    required this.cloud,
    required this.feelslikeC,
    required this.visKm,
    required this.uv,
  });
}
