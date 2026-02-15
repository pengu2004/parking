import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:parking/widgets/AvailScreen.dart';
import 'package:parking/widgets/LoginScreen.dart';
import 'package:parking/widgets/bookingConfirm.dart';
import 'package:parking/widgets/UserForm.dart'; // adjust if filename differs
import 'package:parking/main.dart';
import '../config/shared_prefs.dart';
import 'BookPage.dart';
import '../config/parking_repository.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    final savedName = await UserData.getUserName();
    final savedVehicle = await UserData.getVehicleType();
    if (savedName == null || savedVehicle == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => Loginscreen()),
      );
      return;
    }

    if (savedName != null && savedVehicle != null) {
      final parkingRepository = ParkingRepository();
      final userSlot = await parkingRepository.hasUserBookedToday(
        name: savedName,
      );
      print("userslot" + userSlot.toString());
      print(savedName);

      if (!mounted) return;

      if (userSlot != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => BookingConfirmationPage(
              slotNumber: userSlot,
              vehicleType: savedVehicle,
              userName: savedName,
            ),
          ),
        );
        return;
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => AvailabilityScreen(userName: savedName),
        ),
      );
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => AvailabilityScreen(userName: savedName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: SvgPicture.asset('assets/TNPLogo.svg', width: 150)),
    );
  }
}
