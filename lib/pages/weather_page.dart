import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../models/weather_model.dart';
import '../services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({Key? key}) : super(key: key);

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final WeatherService _weatherService = WeatherService('0b1093c914a6879c1bbcd69f9b295913');
  Weather? _weather;
  late String _weatherAnimation; // Variable to hold the weather animation name

  // Fetch weather
  _fetchWeather() async {
    // Get the current city
    String cityName = await _weatherService.getCurrentCity();

    // Get weather for city
    try {
      final weather = await _weatherService.getWeather(cityName);
      print('Weather condition received: ${weather.mainCondition}'); // Print weather condition
      setState(() {
        _weather = weather;
        _setWeatherAnimation(weather.mainCondition); // Set the weather animation based on the condition
      });
    } catch (e) {
      print(e);
    }
  }

  // Set weather animation based on weather condition
  void _setWeatherAnimation(String condition) {
    // Define mapping of weather condition to animation name
    Map<String, String> animationMap = {
      'Rain': 'rainy.json',
      'Clear': 'sunny.json',
      'Thunderstorm': 'thunder.json',
      'Clouds': 'cloudy.json',
    };

    // Get animation name based on weather condition
    _weatherAnimation = animationMap.containsKey(condition) ? animationMap[condition]! : 'error.json';
  }

  @override
  void initState() {
    super.initState();

    // Fetch weather on startup
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row( // Horizontal alignment of app bar text
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton( // Back button
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            Text('Weather App'), // App bar title
            SizedBox(width: 50), // Adjust the spacing between the elements if necessary
          ],
        ),
        backgroundColor: Colors.black, // Set app bar background color to black
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Background frame for the animation
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Color.fromARGB(255, 171, 168, 168), width: 2),
              ),
              padding: EdgeInsets.all(10),
              child: _weather != null
                  ? Lottie.asset(
                      'assets/$_weatherAnimation',
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                    )
                  : SizedBox(), // Hide animation if weather data is not available
            ),
            SizedBox(height: 20),
            // Display city name
            Text(
              _weather?.cityName ?? "Loading city...",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            // Display temperature label and value
            _weather != null
                ? Column(
                    children: [
                      // Temperature label
                      Text(
                        'Temperature:',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5),
                      // Actual temperature value
                      Text(
                        '${_weather?.temperature?.round() ?? "Loading temperature..."}°C',
                        style: TextStyle(fontSize: 24),
                      ),
                      SizedBox(height: 20),
                      // Humidity label and value
                      Text(
                        'Humidity:',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5),
                      // Actual humidity value
                      Text(
                        '${_weather?.humidity ?? "Loading humidity..."}%',
                        style: TextStyle(fontSize: 24),
                      ),
                    ],
                  )
                : CircularProgressIndicator(), // Show loading indicator while fetching weather
          ],
        ),
      ),
    );
  }
}
