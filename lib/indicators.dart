import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_gauges/gauges.dart';

class HeatwaveIndicatorPage extends StatefulWidget {
  const HeatwaveIndicatorPage({super.key});

  @override
  State<HeatwaveIndicatorPage> createState() => _HeatwaveIndicatorPageState();
}

class _HeatwaveIndicatorPageState extends State<HeatwaveIndicatorPage> {
  String location = 'Fetching location...';
  String temperature = '';
  String description = '';
  double heatValue = 0;

  final TextEditingController searchlocation = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          location = 'Location services are disabled.';
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            location = 'Location permissions are denied';
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          location = 'Location permissions are permanently denied';
        });
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      setState(() {
        location = 'Lat: ${position.latitude}, Lng: ${position.longitude}';
      });

      fetchWeatherByCoordinates(position.latitude, position.longitude);
    } catch (e) {
      print("Location error: $e");
      setState(() {
        location = "Failed to get location";
      });
    }
  }

  Future<void> fetchWeatherByCity(String city) async {
    final apiKey = '15226fac2a7dcc27bdd9c82ed64e4e0c';
    final url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          double temp = data['main']['temp'];
          temperature = "$temp°C";
          heatValue = temp * 2; // convert for gauge (0–200 scale)
          description = data['weather'][0]['description'];
          location = data['name'];
        });
      } else {
        setState(() {
          temperature = 'Error';
          description = 'City not found';
        });
      }
    } catch (e) {
      setState(() {
        temperature = 'Error';
        description = 'Error occurred';
      });
    }
  }

  Future<void> fetchWeatherByCoordinates(double lat, double lon) async {
    final apiKey = '15226fac2a7dcc27bdd9c82ed64e4e0c';
    final url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          double temp = data['main']['temp'];
          temperature = "$temp°C";
          heatValue = temp * 2; // for gauge scale (e.g., 26°C → 52)
          description = data['weather'][0]['description'];
          location = data['name'];
        });
      } else {
        setState(() {
          temperature = 'Error';
          description = 'Failed to fetch weather';
        });
      }
    } catch (e) {
      setState(() {
        temperature = 'Error';
        description = 'Error occurred';
      });
    }
  }

  String getStatusLabel(double value) {
    if (value < 100) return 'GOOD';
    if (value < 150) return 'MODERATE';
    return 'NOT GOOD';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(
          0xFF214088,
        ), // Dark blue background color for AppBar
        elevation: 0, // No shadow for the AppBar
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ), // Back arrow icon
          onPressed: () {
            // Placeholder for back button functionality
            Navigator.pop(context); // Navigate back when pressed
          },
        ),
        title: const Text(
          'Heatwave Idicators', // Title text in the AppBar
          style: TextStyle(
            color: Colors.white,
          ), // White color for the title text
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: searchlocation,
              decoration: InputDecoration(
                hintText: 'Enter location',
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                prefixIcon: IconButton(
                  onPressed: () {
                    String city = searchlocation.text.trim();
                    if (city.isNotEmpty) {
                      fetchWeatherByCity(city);
                    }
                  },
                  icon: const Icon(Icons.search),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(location, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text("Temperature: $temperature",
                style: const TextStyle(fontSize: 20)),
            Text("Condition: $description",
                style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 30),

            /// RADIAL GAUGE (UI Matches Image)
           SfRadialGauge(
          axes: <RadialAxis>[
            RadialAxis(
              minimum: 50,
              maximum: 200,
              startAngle: 180,
              endAngle: 0,
              showTicks: false,
              showLabels: false,
              radiusFactor: 1,
              axisLineStyle: const AxisLineStyle(
                thickness: 0.15,
                thicknessUnit: GaugeSizeUnit.factor,
                cornerStyle: CornerStyle.bothCurve,
              ),
              ranges: <GaugeRange>[
                GaugeRange(
                  startValue: 50,
                  endValue: 100,
                  color: Colors.green,
                  startWidth: 0.15,
                  endWidth: 0.15,
                ),
                GaugeRange(
                  startValue: 100,
                  endValue: 150,
                  color: Colors.amber,
                  startWidth: 0.15,
                  endWidth: 0.15,
                ),
                GaugeRange(
                  startValue: 150,
                  endValue: 200,
                  color: Colors.brown,
                  startWidth: 0.15,
                  endWidth: 0.15,
                ),
              ],
              pointers: <GaugePointer>[
                MarkerPointer(
                  value: heatValue,
                  markerType: MarkerType.circle,
                  markerHeight: 20,
                  markerWidth: 20,
                  color: Colors.green,
                ),
              ],
              annotations: <GaugeAnnotation>[
                GaugeAnnotation(
                  angle: 90,
                  positionFactor: 0.0,
                  widget: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        heatValue.toStringAsFixed(0),
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        getStatusLabel(heatValue),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Text(
                        'Heat Ratio',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                GaugeAnnotation(
                  angle: 180,
                  positionFactor: 1.2,
                  widget: const Text(
                    'Low',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                GaugeAnnotation(
                  angle: 0,
                  positionFactor: 1.2,
                  widget: const Text(
                    'High',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                GaugeAnnotation(
                  angle: 150,
                  positionFactor: 1.1,
                  widget: const Text('100',
                      style: TextStyle(fontSize: 12, color: Colors.black)),
                ),
                GaugeAnnotation(
                  angle: 90,
                  positionFactor: 1.1,
                  widget: const Text('150',
                      style: TextStyle(fontSize: 12, color: Colors.black)),
                ),
                GaugeAnnotation(
                  angle: 30,
                  positionFactor: 1.1,
                  widget: const Text('200',
                      style: TextStyle(fontSize: 12, color: Colors.black)),
                ),
              ],
            ),
          ],
        ),
          ],
        ),
      ),
    );
  }
}
