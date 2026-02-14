import 'package:flutter/material.dart';
import 'BookPage.dart';

class AvailabilityScreen extends StatelessWidget {
  const AvailabilityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text("Available Slots", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF7EFB99), Color(0xFFEFFBF1), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: PageView(
          children: [
            _buildTowerScreen(context, "Bike", "Tower-2", 2),
            _buildTowerScreen(context, "Car", "Tower-2", 3),
            _buildTowerScreen(context, "Bike", "Tower-1", 8),
          ],
        ),
      ),
    );
  }

  Widget _buildTowerScreen(
    BuildContext context,
    String vehicle,
    String tower,
    int count,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                MyBookPage(selectedVehicle: vehicle, userName: "Tejus"),
          ),
        );
      },
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              vehicle + "-" + tower + ".png",
              fit: BoxFit.cover,
            ),
          ),

          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.4)),
          ),

          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  tower,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),

                Text(
                  "$vehicle Parking",
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),

                const SizedBox(height: 10),

                Text(
                  "$count Available",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
