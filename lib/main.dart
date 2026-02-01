import 'package:flutter/material.dart';
import 'package:parking/config/parking_repository.dart';
import 'widgets/parkingfloor.dart';
import 'widgets/UserForm.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'config/supabase_config.dart';
import 'config/parking_state.dart';
import 'config/parking_repository.dart';
import 'config/shared_prefs.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await SupabaseConfig.initializeSupabase();
  print(await UserData.getUserName());
  print(await UserData.getVehicleType());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tnp Parks',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: .fromSeed(seedColor: Colors.green[400]!),
      ),
      home: const MyHomePage(title: 'TNP Parks'),
    );
  }
}

class MyBookPage extends StatefulWidget {
  const MyBookPage({
    super.key,
    required this.selectedVehicle,
    required this.userName,
  });
  final String selectedVehicle;
  final String userName;

  @override
  State<MyBookPage> createState() => _MyBookPageState();
}

class _MyBookPageState extends State<MyBookPage> {
  final int bikeSpaces = 9;
  late Map<int, bool> firstbikeSlots;
  late Map<int, bool> firstcarSlots;
  bool isLoading = true;

  final ParkingRepository _parkingRepository = ParkingRepository();
  Future<void> fetchParkingState() async {
    ParkingState parkingState = await _parkingRepository
        .getOccupiedSpotsToday();
    print("fetched data");

    setState(() {
      firstbikeSlots = parkingState.bikeSlots;
      firstcarSlots = parkingState.carSlots;
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchParkingState();
  }

  final List<int> bikeParkingSpaces = [
    320,
    355,
    358,
    362,
    363,
    364,
    365,
    366,
    377,
  ];
  final Map<int, bool> firstBikeParkingState = {
    300: true,
    301: false,
    302: true,
    304: true,
    305: false,
    306: false,
    307: false,
    308: true,
    311: true,
  };
  final Map<int, bool> secondBikeParkingState = {
    300: true,
    301: false,
    302: true,
    304: true,
    305: false,
    306: false,
    3007: false,
    308: true,
  };
  final Map<int, bool> firstCarParkingState = {
    300: true,
    301: false,
    302: true,
    304: true,
    305: false,
    306: false,
    307: false,
    308: true,
    311: true,
  };
  final Map<int, bool> secondCarParkingState = {
    300: true,
    301: false,
    302: true,
    304: true,
    305: false,
    306: false,
    307: false,
    308: true,
    311: true,
  };

  @override
  Widget build(BuildContext context) {
    if (isLoading || firstbikeSlots == null || firstcarSlots == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(title: Text(widget.selectedVehicle)),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ParkingFloor(
                  floorName: "First Floor",
                  vehicleType: widget.selectedVehicle,
                  userName: widget.userName,
                  parkingState: widget.selectedVehicle == "Bike"
                      ? firstbikeSlots
                      : firstcarSlots,
                ),
                SizedBox(height: 20),
                ParkingFloor(
                  floorName: "Second Floor",
                  vehicleType: widget.selectedVehicle,
                  userName: widget.userName,
                  parkingState: widget.selectedVehicle == "Bike"
                      ? secondBikeParkingState
                      : secondCarParkingState,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String name = "";

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: .center,
          children: [const UserForm(), const SizedBox(height: 30)],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
