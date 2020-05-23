import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_webservice/places.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BarHop',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: DefaultTabController(
        length: 2, 
        child: Scaffold(
          appBar: AppBar(
            title: Text('BarHop')
          ),
          bottomNavigationBar: TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.list),
                text: 'Places'
              ),
              Tab(
                icon: Icon(Icons.map),
                text: 'Maps'
              )
            ],
            labelColor: Colors.lightBlue,
          ),
          body: TabBarView(children: <Widget>[
            PlaceList(),
            Maps()
          ],
          )
        )
      ),
    );
  }
}

class PlaceList extends StatefulWidget {
  PlaceList({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _PlaceListState createState() => _PlaceListState();
}

class _PlaceListState extends State<PlaceList> {
  List<String> items = List<String>.generate(10, (i) => "Item $i");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('${items[index]}'),
          );
        },
      )
    );
  }
}

class Maps extends StatefulWidget {
  @override
  MapState createState() => MapState();
}

class MapState extends State<Maps> {
  @override
  void initState() {
    super.initState();
    _initMap();
  }

  GoogleMapController mapController;

  LatLng _center;// = LatLng(45.521563, -122.677433);
  PlacesSearchResponse _response;
  List<Marker> _markers = <Marker>[];
  final places = new GoogleMapsPlaces(apiKey: "AIzaSyDLkJosEooi2EEk1YOiu8GjyYC_EPPogO0");
  final geolocator = Geolocator();
  
  void _initMap() async {
    Position position = await geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    Location location = Location(position.latitude, position.longitude);
    PlacesSearchResponse response = await places.searchNearbyWithRadius(location, 50);
    setState(() {
      _center = LatLng(position.latitude, position.longitude);
      _response = response;
      for (var item in _response.results) {
        print(item.name);
        _markers.add(
          Marker(
            markerId: MarkerId(item.placeId),
            position: LatLng(item.geometry.location.lat, item.geometry.location.lng),
            infoWindow: InfoWindow(title: item.name, snippet: item.vicinity),
            onTap: () {},
          ),
        );
      }
    });
  } 

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        markers: Set<Marker>.of(_markers),
        initialCameraPosition: CameraPosition(target: _center, zoom: 15.0),
      ),
    );
  }
}

// MVP TODO
// grab places near current location
// query user about place sufficiently close to current location
// store rating for place 
// show ratings for all nearby places in listview and on map
// user sign in and account
// database for accounts and places
// search places to see rating