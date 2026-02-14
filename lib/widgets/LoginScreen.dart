import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../config/shared_prefs.dart';
import '../config/parking_repository.dart';
import '../main.dart';
import 'bookingConfirm.dart';
import 'UserForm.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  _LoginscreenState createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  double _scale = 0.1;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _scale = 1.0;
      });
    });
    _checkSavedUser();
  }

  Future<void> _checkSavedUser() async {
    final savedName = await UserData.getUserName();
    final savedVehicle = await UserData.getVehicleType();

    if (savedName == null || savedVehicle == null) return;

    final parkingRepository = ParkingRepository();
    final userSlot = await parkingRepository.hasUserBookedToday(
      name: savedName,
    );

    if (!mounted) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (userSlot != null) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => BookingConfirmationPage(
              slotNumber: userSlot,
              vehicleType: savedVehicle,
              userName: savedName,
            ),
          ),
          (route) => false,
        );
      } else {
        // User saved but not booked → go to booking page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) =>
                MyBookPage(selectedVehicle: savedVehicle, userName: savedName),
          ),
        );
      }
    });
  }

  void _navigateToUserForm() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const UserForm()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width,
          maxHeight: MediaQuery.of(context).size.height,
        ),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF7EFB99), Color(0xFFEFFBF1), Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AnimatedScale(
                    scale: _scale,
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeOut,
                    child: SvgPicture.asset('TNPLogo.svg', width: 170),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'TNP PARKS',
                    style: TextStyle(
                      fontFamily: 'SpaceGrotesk',
                      fontSize: 40,
                      color: Color(0xFF1A1A1A),
                      letterSpacing: 3,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "Book your parking slot with ease and convenience.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Color(0xFF1A1A1A)),
                    ),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: _navigateToUserForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 80,
                        vertical: 20,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      elevation: 5,
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
