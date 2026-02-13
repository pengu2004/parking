import 'package:flutter/material.dart';
import 'package:parking/widgets/bookingConfirm.dart';
import 'package:parking/widgets/UserForm.dart'; // adjust if filename differs
import 'package:parking/main.dart';
import '../config/shared_prefs.dart';
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

    if (savedName != null && savedVehicle != null) {
      final parkingRepository = ParkingRepository();
      final userSlot =
          await parkingRepository.hasUserBookedToday(name: savedName);

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
          builder: (_) => MyBookPage(
            selectedVehicle: savedVehicle,
            userName: savedName,
          ),
        ),
      );
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const UserForm(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
