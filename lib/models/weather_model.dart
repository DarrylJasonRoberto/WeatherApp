class Weather {
  final String cityName;
  final double temperature;
  final String mainCondition;
  final int humidity; 

  Weather({
    required this.cityName,
    required this.temperature,
    required this.mainCondition,
    required this.humidity, 
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
  return Weather(
    cityName: json['name'],
    temperature: json['main']['temp'].toDouble(),
    mainCondition: json['weather'][0]['main'],
    humidity: json['main']['humidity'] ?? 0, // Provide a default value of 0 if humidity is null
  );
}
}
