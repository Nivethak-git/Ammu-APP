import 'package:flutter/material.dart';
import 'home.dart';

// Main function to run the application
// void main() {
//   runApp(const Alert_page());
// }

// MyApp is the root widget of the application
class Alert_page extends StatelessWidget {
  const Alert_page({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SMS Add on Services',
      debugShowCheckedModeBanner: false, // Updated title for the application
      theme: ThemeData(
        primarySwatch: Colors.blue, // Primary color swatch for the theme
      ),
      home:
          const SmsAddOnServicesScreen(), // Set SmsAddOnServicesScreen as the home screen
    );
  }
}

// SmsAddOnServicesScreen represents the UI for SMS Add on Services
class SmsAddOnServicesScreen extends StatefulWidget {
  const SmsAddOnServicesScreen({super.key});

  @override
  State<SmsAddOnServicesScreen> createState() => _SmsAddOnServicesScreenState();
}

class _SmsAddOnServicesScreenState extends State<SmsAddOnServicesScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2), // Duration of the ripple animation
      vsync: this,
    )..repeat(); // Repeat the animation indefinitely

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose the animation controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar at the top of the screen
      appBar: AppBar(
        backgroundColor: const Color(
          0xFF214088,
        ), // Dark blue background color for AppBar
        elevation: 0, // No shadow for the AppBar
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 20,
          ), // Back arrow icon
          onPressed: () {
            // Placeholder for back button functionality
            Navigator.pop(context); // Navigate back when pressed
          },
        ),
        title: const Text(
          'SMS Add on Services', // Title text in the AppBar
          style: TextStyle(
            color: Colors.white,
            fontSize: 20
          ), // White color for the title text
        ),
      ),
      backgroundColor: Colors.white, // White background for the entire screen
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Instruction text - This text is intentionally not animated.
            const Text(
              'Tap on Pair Button to pair\nGPS Smart Watch / Chip',
              textAlign: TextAlign.center, // Center align the text
              style: TextStyle(
                color: Colors.black, // Black text color
                fontSize: 18, // Font size for the text
              ),
            ),
            const SizedBox(height: 50), // Space between text and button
            // Pair button with ripple effect (animation applies only to the ripples)
            // Wrapped in a SizedBox to prevent layout shifts caused by the animation
            SizedBox(
              width: 250, // Max width of the largest ripple
              height: 250, // Max height of the largest ripple
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      // Inner ripple 1
                      Container(
                        width: 150 * _animation.value,
                        height: 150 * _animation.value,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blue.withOpacity(
                            0.4 - (_animation.value * 0.4),
                          ),
                        ),
                      ),
                      // Inner ripple 2
                      Container(
                        width: 200 * _animation.value,
                        height: 200 * _animation.value,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blue.withOpacity(
                            0.3 - (_animation.value * 0.3),
                          ),
                        ),
                      ),
                      // Inner ripple 3
                      Container(
                        width: 250 * _animation.value,
                        height: 250 * _animation.value,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blue.withOpacity(
                            0.2 - (_animation.value * 0.2),
                          ),
                        ),
                      ),
                      // Main Pair button (this button's text is not animated)
                      SizedBox(
                        width: 120, // Width of the button
                        height: 120, // Height of the button
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Home_Page(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(
                              0xFF214088,
                            ), // Button background color
                            shape:
                                const CircleBorder(), // Make it a circular button
                            padding: EdgeInsets.zero, // No internal padding
                          ),
                          child: const Text(
                            'Pair', // Button text
                            style: TextStyle(
                              color:
                                  Colors
                                      .white, // White text color for the button
                              fontSize: 24, // Font size for button text
                              fontWeight:
                                  FontWeight
                                      .bold, // Bold font weight for button text
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
