import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'sms_add.dart'; // Your alert page
import 'package:flutter_blue_plus/flutter_blue_plus.dart';





class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const BluetoothScreen(),
    );
  }
}

class BluetoothScreen extends StatefulWidget {
  const BluetoothScreen({super.key});
  @override
  State<BluetoothScreen> createState() => _BluetoothScreenState();
}

class _BluetoothScreenState extends State<BluetoothScreen> {
  bool isScanning = false;

//  Future<void> _scanDevices() async {
//   final FlutterBluePlus flutterBlue = FlutterBluePlus.instance;


//   Map<Permission, PermissionStatus> statuses = await [
//     Permission.bluetooth,
//     Permission.locationWhenInUse,
//   ].request();

//   if (statuses[Permission.locationWhenInUse]!.isGranted) {
//     setState(() => isScanning = true);

//     await flutterBlue.stopScan();  // ✅ Safe now
//     flutterBlue.startScan(timeout: const Duration(seconds: 4));

//     flutterBlue.scanResults.listen((results) {
//       for (ScanResult r in results) {
//         debugPrint('Device found: ${r.device.name} - ${r.device.id}');
//       }
//     });

//     await Future.delayed(const Duration(seconds: 4));
//     await flutterBlue.stopScan();

//     if (mounted) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => const Alert_page()),
//       );
//     }

//     setState(() => isScanning = false);
//   } else {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Location permission required for Bluetooth scanning')),
//     );
//   }
// }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Stack(
              children: [
                Positioned.fill(
                  child: ClipPath(
                    clipper: BottomWaveClipper(),
                    child: Container(color: const Color(0xFF00224C)),
                  ),
                ),
                Column(
                  children: [
                    const SizedBox(height: 50),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: const Icon(Icons.arrow_back_ios, color: Colors.white),
                          ),
                          const Expanded(
                            child: Text(
                              'Add your device',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                          const SizedBox(width: 20),
                        ],
                      ),
                    ),
                    const SizedBox(height: 100),
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.5),
                            blurRadius: 15,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: const Icon(Icons.bluetooth, color: Color(0xFF00224C), size: 60),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Turn on Bluetooth connection settings\n'
                    'in your smart watch and make sure your\n'
                    'Device is close to your phone',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black54, fontSize: 16),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                   onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Alert_page()),
                    );
                  },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00224C),
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                       'Pair Device',
                      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(color: const Color(0xFF00224C), height: 50),
    );
  }
}

class BottomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height * 0.7);
    path.quadraticBezierTo(size.width * 0.8, size.height * 0.85, size.width * 0.5, size.height * 0.75);
    path.quadraticBezierTo(size.width * 0.2, size.height * 0.65, 0, size.height * 0.75);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
