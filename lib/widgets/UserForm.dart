import 'package:flutter/material.dart';
import 'package:parking/widgets/bookingConfirm.dart';
import '../config/shared_prefs.dart';
import '../config/parking_repository.dart';
import '../main.dart';
import 'BookPage.dart';

class UserForm extends StatefulWidget {
  const UserForm({Key? key}) : super(key: key);

  @override
  State<UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final TextEditingController _nameController = TextEditingController();
  final List<String> _vehicleTypes = ['Car', 'Bike'];
  String? _selectedVehicle;

  @override
  void initState() {
    super.initState();
    _selectedVehicle = _vehicleTypes[0];
    _checkSavedUser();
  }

  Future<void> _checkSavedUser() async {
    final savedName = await UserData.getUserName();
    final savedVehicle = await UserData.getVehicleType();

    if (savedName == null || savedVehicle == null) return;

    final parkingRepository = ParkingRepository();
    final userSlot =
        await parkingRepository.hasUserBookedToday(name: savedName);

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
            builder: (_) => MyBookPage(
              selectedVehicle: savedVehicle,
              userName: savedName,
            ),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> submitForm() async {
    final name = _nameController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your name')),
      );
      return;
    }

    await UserData.saveUserData(name, _selectedVehicle!);

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => MyBookPage(
          selectedVehicle: _selectedVehicle!,
          userName: name,
        ),
      ),
    );
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.grey[100],
    body: Center(
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      "Book Parking Slot",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),

                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Vehicle Type',
                      border: OutlineInputBorder(),
                    ),
                    value: _selectedVehicle,
                    items: _vehicleTypes.map((vehicle) {
                      return DropdownMenuItem(
                        value: vehicle,
                        child: Text(vehicle),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedVehicle = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: submitForm,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Book",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
}
