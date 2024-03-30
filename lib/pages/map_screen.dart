import 'dart:math';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {



  String darkMapStyle = '''
[
  {
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#242f3e"
      }
    ]
  },
  {
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#746855"
      }
    ]
  },
  {
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#242f3e"
      }
    ]
  },
  {
    "featureType": "administrative.locality",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#d59563"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#d59563"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#263c3f"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#6b9a76"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#38414e"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "geometry.stroke",
    "stylers": [
      {
        "color": "#212a37"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9ca5b3"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#746855"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry.stroke",
    "stylers": [
      {
        "color": "#1f2835"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#f3d19c"
      }
    ]
  },
  {
    "featureType": "transit",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#2f3948"
      }
    ]
  },
  {
    "featureType": "transit.station",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#d59563"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#17263c"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#515c6d"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#17263c"
      }
    ]
  }
]
''';

  final GlobalKey _fabKey = GlobalKey();
  final TextEditingController _searchController = TextEditingController();

  Set<Marker> _markers = {};
  final Random _random = Random();
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;


  LatLng _getRandomLagosLocation() {
    double minLat = 6.25;
    double maxLat = 6.7;
    double minLong = 3.15;
    double maxLong = 3.65;
    double lat = minLat + _random.nextDouble() * (maxLat - minLat);
    double lng = minLong + _random.nextDouble() * (maxLong - minLong);
    return LatLng(lat, lng);
  }




  @override
  void initState() {
    _getCustomMarkerBitmap().then((icon) {
      setState(() {
        markerIcon = icon;
      });
    });
    super.initState();

  }

  Future<Uint8List?> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))?.buffer.asUint8List();
  }

  Future<BitmapDescriptor> _getCustomMarkerBitmap() async {
    String imagePath = "assets/map_icon.png";
    int targetWidth = 50;

    Uint8List? markerImageBytes = await getBytesFromAsset(imagePath, targetWidth);
    return BitmapDescriptor.fromBytes(markerImageBytes!);
  }


  Set<Marker> _generateRandomMarkers() {

    return List.generate(6, (index)  {
      return Marker(
        markerId: MarkerId(index.toString()),
        position: _getRandomLagosLocation(),
        icon: markerIcon
      );
    }).toSet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: _getRandomLagosLocation(), // Start with a random Lagos location
              zoom: 12,
            ),
            mapToolbarEnabled: false,
            zoomControlsEnabled: true,
            zoomGesturesEnabled: true,
            onMapCreated: (GoogleMapController controller) {
              controller.setMapStyle(darkMapStyle);
              setState(() {
                _markers = _generateRandomMarkers();
              });
            },
            markers: _markers,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 16, right: 16.0, bottom: 20.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: "Search...",
                      filled: true, // Add this line
                      fillColor: Colors.white,
                      prefixIcon: Icon(Icons.search_outlined),
                      contentPadding: EdgeInsets.only(left: 16.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50.0),
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10.0),
                Container(
                  height: 40, // Adjust the height of the arrow container
                  width: 40, // Adjust the width of the arrow container
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Icon(Icons.filter_alt_outlined)
                  ),
                ),
                // FloatingActionButton(
                //   backgroundColor: Colors.grey.withOpacity(0.7),
                //   onPressed: () => {
                //
                //   },
                //   child: Icon(IconsaxBold.filter, color: Colors.white),
                // ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, bottom: 120.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FloatingActionButton(
                  key: _fabKey,
                  backgroundColor: Colors.grey.withOpacity(0.7),
                  onPressed: () {
                    _showMenuAtFAB(_fabKey);
                  },
                  child: Icon(IconsaxBold.layer, color: Colors.white,),
                ),
                SizedBox(height: 10),
                FloatingActionButton(
                  backgroundColor: Colors.grey.withOpacity(0.7),
                  onPressed: () {
                    // Implement the functionality for this button
                  },
                  child: Icon(IconsaxBold.location, color: Colors.white,),
                ),
              ],
            ),
          ),

          Positioned(
            bottom: 120.0,
            right: 16.0,
            child: SizedBox(
              width: 150,
              height: 50,
              child: FloatingActionButton(
                backgroundColor: Colors.grey.withOpacity(0.7),
                onPressed: () {
                },
                child: Row(
                  children: [
                    SizedBox(width: 6,),
                    Icon(IconsaxBold.textalign_justifyleft),
                    SizedBox(width: 6,),
                    Text("List of Variants")
                  ],
                ),
              ),
            ),
          ),
        ],
      ),



    );
  }


  void _showMenuAtFAB(GlobalKey fabKey) {
    final RenderBox fabRenderBox = fabKey.currentContext!.findRenderObject() as RenderBox;
    final fabSize = fabRenderBox.size;
    final fabOffset = fabRenderBox.localToGlobal(Offset.zero);



    showMenu(
      context: context,
      elevation: 6,
      color: Colors.white,
      position: RelativeRect.fromLTRB(
          0,
          fabOffset.dy + fabSize.height - 200, // Position below the FAB
          0,
          0
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      items: [
        PopupMenuItem(
          child: Row(
            children: [
              Icon(IconsaxBold.security, color: Colors.grey),
              SizedBox(width: 5,),
              Text('Cosy area', style: TextStyle(color: Colors.black),),
            ],
          ),
          onTap: () {
          },
        ),
        PopupMenuItem(
          child: Row(
            children: [
              Icon(IconsaxBold.wallet_3, color: Colors.grey),
              SizedBox(width: 5,),
              Text('Price', style: TextStyle(color: Colors.black),),
            ],
          ),
          onTap: () {
          },
        ),
        PopupMenuItem(
          child: Row(
            children: [
              Icon(IconsaxBold.strongbox, color: Colors.grey),
              SizedBox(width: 5,),
              Text('Infastructure ', style: TextStyle(color: Colors.black),),
            ],
          ),
          onTap: () {
          },
        ),

        PopupMenuItem(
          child: Row(
            children: [
              Icon(IconsaxBold.layer, color: Colors.grey),
              SizedBox(width: 5,),
              Text('Without any layer ', style: TextStyle(color: Colors.black),),
            ],
          ),
          onTap: () {
          },
        ),
      ],

    );
  }

}