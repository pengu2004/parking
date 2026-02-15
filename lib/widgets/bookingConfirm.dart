import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BookingConfirmationPage extends StatelessWidget {
  final String userName;
  final String vehicleType;
  final int slotNumber;

  const BookingConfirmationPage({
    super.key,
    required this.userName,
    required this.vehicleType,
    required this.slotNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF9),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Success Animation Container
              Container(
                width: 200,
                height: 200,

                child: SvgPicture.asset(
                  "assets/TNPLogo.svg",
                  width: 60,
                  height: 60,
                ),
              ),

              // Success Message
              const Text(
                'Booking Confirmed!',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A),
                  fontFamily: 'SpaceGrotesk',
                ),
              ),

              const SizedBox(height: 60),

              // Vehicle Image and Slot Number Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'Your Parking Slot',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Large Slot Number
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 20,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Colors.green[50]!, Colors.green[100]!],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.green[200]!, width: 3),
                      ),
                      child: Text(
                        slotNumber.toString().padLeft(2, '0'),
                        style: TextStyle(
                          fontSize: 64,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[700],
                          fontFamily: 'SpaceGrotesk',
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }
}
