import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:parking/widgets/AvailScreen.dart';
import 'package:parking/widgets/BookPage.dart';
import '../config/shared_prefs.dart';
import '../config/parking_repository.dart';
import '../main.dart';
import 'bookingConfirm.dart';
import 'UserForm.dart';
import 'LoginForm.dart';
import 'AvailScreen.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  _LoginscreenState createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  double _scale = 0.1;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

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

  void navigateToUserForm(String savedName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AvailabilityScreen(userName: savedName),
      ),
    );
  }

  Future<void> _checkSavedUser() async {
    final savedName = await UserData.getUserName();

    if (savedName == null) return;

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
              vehicleType: "Car",
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
            builder: (_) => AvailabilityScreen(userName: savedName),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: ConstrainedBox(
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
                  children: [
                    const Spacer(flex: 1),
                    AnimatedScale(
                      scale: _scale,
                      duration: const Duration(milliseconds: 800),
                      curve: Curves.easeOut,
                      child: SvgPicture.asset('assets/TNPLogo.svg', width: 170),
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
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "Book your parking slot with ease and convenience.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                    ),
                    const SizedBox(height: 90),
                    Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelText: "Work Email",
                                hintText: "name@tnpconsultants.com",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                prefixIcon: Icon(Icons.email_outlined),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Email is required";
                                }
                                if (!value.endsWith("@tnpconsultants.com")) {
                                  return "Must use your office.com email";
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          print("Valid email: ${_emailController.text}");
                          UserData.saveUserData(
                            _emailController.text.split("@").first,
                            "",
                          );
                          navigateToUserForm(
                            _emailController.text.split("@").first,
                          );
                        }
                      },
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
                    const SizedBox(height: 10),
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
