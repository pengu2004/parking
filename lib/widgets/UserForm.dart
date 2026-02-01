import 'package:flutter/material.dart';
import 'package:parking/database.dart';
import 'package:parking/main.dart';
import 'package:parking/widgets/bookingConfirm.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/shared_prefs.dart';
import '../config/parking_repository.dart';

class UserForm extends StatefulWidget {
  const UserForm({Key? key}) : super(key: key);

  @override
  State<UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  Future<void> _checkSavedUser() async {
    final String? savedName = await UserData.getUserName();
    final String? savedVehicle = await UserData.getVehicleType();
    final ParkingRepository _parkingRepository = ParkingRepository();
    final int? userSlot = await _parkingRepository.hasUserBookedToday(
      name: savedName ?? '',
    );
    print("Saved name: $savedName, vehicle: $savedVehicle");
    setState(() {
      _nameController.text = savedName ?? '';
      _selectedVehicle = savedVehicle;
    });
    if (!mounted) return;
    if (userSlot != null && savedVehicle != null && savedName != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => BookingConfirmationPage(
            slotNumber: userSlot,
            vehicleType: savedVehicle,
            userName: savedName,
          ),
        ),
      );
      return;
    }
    if (savedName != null && savedVehicle != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              MyBookPage(selectedVehicle: savedVehicle, userName: savedName),
        ),
      );
    }
  }

  final TextEditingController _nameController = TextEditingController();
  final List<String> _vehicleTypes = ['Car', 'Bike'];
  String? _selectedVehicle;

  @override
  void initState() {
    super.initState();
    _selectedVehicle = _vehicleTypes[0];
    _checkSavedUser();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> submitForm() async {
    await DatabaseHelper.insertUser(_nameController.text, _selectedVehicle!);
    _nameController.clear();
    setState(() => _selectedVehicle = _vehicleTypes[0]);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Name'),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField(
            decoration: const InputDecoration(
              labelText: 'Vehicle Type',
              border: OutlineInputBorder(),
            ),
            initialValue: _selectedVehicle,
            items: _vehicleTypes.map((vehicle) {
              return DropdownMenuItem(value: vehicle, child: Text(vehicle));
            }).toList(),
            onChanged: (value) {
              print(value);
              setState(() {
                _selectedVehicle = value!;
              });
            },
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              // Sets a fixed width of 200 and height of 50
              fixedSize: const Size(200, 50),
              // Or set minimum size to allow growth but ensure a base size
              // minimumSize: const Size(100, 40),
            ),
            onPressed: () async {
              print("clicked");
              final name = _nameController.text.trim();

              if (name.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter your name')),
                );
                return;
              }

              await UserData.saveUserData(name, _selectedVehicle!);
              print("Saved to prefs");

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MyBookPage(
                    selectedVehicle: _selectedVehicle!,
                    userName: _nameController.text,
                  ),
                ),
              );
            },
            child: const Text("Book"),
          ),
        ],
      ),
    );
  }
}
