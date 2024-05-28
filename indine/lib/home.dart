import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:indine/cart.dart';
import 'package:indine/getLocation.dart';
import 'package:indine/item_tile.dart';
import 'package:indine/model/cart_model.dart';
import 'package:indine/premium.dart';
import 'package:indine/signup.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex=0;
  final List pages=[
    HomeScreen(),
    premium(),
    CartScreen(),
  ];
  ontapped(int index){
    setState(() {
      currentIndex=index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.verified),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: '',
          ),
        ],
        currentIndex: currentIndex,
        selectedItemColor: Color(0xFF6C8E78),
        unselectedItemColor: Colors.grey,
        onTap: (value) {
          ontapped(value);
        },
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
String name ="";



 
Future<DocumentSnapshot?> getUserByEmail(String email) async {
    try {
      CollectionReference users = FirebaseFirestore.instance.collection('Users');
      QuerySnapshot querySnapshot = await users.where('email', isEqualTo: email).get();
      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first;
      } else {
        return null;
      }
    } catch (e) {
      print("Error getting user by email: $e");
      return null;
    }
  }

  void checkEmail(String email) async {
  DocumentSnapshot? userDoc = await getUserByEmail(email);
  
  if (userDoc != null) {
    // Email found in Firestore
    print("User found: ${userDoc['name']}");
    setState(() {
      
      name= userDoc['name'].toString();
    });
    
  } else {
    // Email not found
    print("No user found with email: $email");
  }
}


@override
  void initState() {
    var auth = FirebaseAuth.instance.currentUser;
    if(auth !=null){
      checkEmail(auth.email.toString());
    }
    
    // TODO: implement initState
    super.initState();
  }

  int currentIndex =0;
  void onTapped(int index) {
    setState(() {
       currentIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {

    
    return Scaffold(

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LocationAndSearch(),
              SizedBox(height: 16),
              
              Text("Find \nyour craving",style: TextStyle(fontSize: 24,fontFamily: 'Poppins',fontWeight: FontWeight.bold),),
              FilterOptions(),
              SizedBox(height: 16),
              Text(
                'Breakfast',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  children: [
                    FoodCard(
                      
                      name: "Laccha Paratha",
                      price: 60,
                      imageUrl: 'assets/breakfast1.jpg',
                      discount: 'FLAT 100% OFF',

                    ),
                    FoodCard(
                      
                      name: "Chole bhature",
                      price: 80,
                      imageUrl: 'assets/breakfast2.jpg',
                      discount: 'FLAT 80% OFF',
                    ),
                    FoodCard(
                      
                      name: "Idli",
                      price: 40,
                      imageUrl: 'assets/breakfast3.jpg',
                      discount: 'FLAT 90% OFF',
                    ),
                    FoodCard(
                     
                      name: "Dosa",
                      price: 60,
                      imageUrl: 'assets/breakfast4.jpg',
                      discount: 'FLAT 80% OFF',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      
     drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.green,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.person,
                    size: 50,
                    color: Colors.white,
                  ),
                  SizedBox(height: 8),
                  Text(
                   name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                setState(() {
                  currentIndex=0;
                });
                Navigator.pop(context);
                onTapped(0);
              },
            ),
            ListTile(
              leading: Icon(Icons.verified),
              title: Text('Premium'),
              onTap: () {
                setState(() {
                  currentIndex=1;
                });
                Navigator.pop(context);
                onTapped(1);
              },
            ),
            ListTile(
              leading: Icon(Icons.shopping_cart),
              title: Text('Cart'),
              onTap: () {
                setState(() {
                  currentIndex=2;
                });
                Navigator.pop(context);
                onTapped(2);
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                // Navigate to the Settings page
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                 var auth = FirebaseAuth.instance;
                auth.signOut();
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context)=>  SignUpPage()));
                
                // Handle logout action
              },
            ),
          ],
        ),
      ),
    );
  }
}


class LocationAndSearch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.location_on, color: Colors.green),
            SizedBox(width: 8),
            LocationDisplay(),
            Spacer(),
            IconButton(
              onPressed: (){
                Scaffold.of(context).openDrawer();
              },
              icon: Icon(Icons.person, color: Colors.green),
            ),
          ],
        ),
        SizedBox(height: 16),
        TextField(
          decoration: InputDecoration(
            suffixIcon: Icon(Icons.search),
            hintText: 'Search',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Color.fromARGB(170, 164, 195, 178),
          ),
        ),
      ],
    );
  }
}

class LocationDisplay extends StatefulWidget {
   LocationDisplay({
    super.key,  
  });

  @override
  State<LocationDisplay> createState() => _LocationDisplayState();
}

class _LocationDisplayState extends State<LocationDisplay> {
Position? _currentLocation;
 late bool servicePermisssion= false;
 String currentAddress="";
  late LocationPermission permission;
Future<Position> _getCurrentLocation() async{
    servicePermisssion = await Geolocator.isLocationServiceEnabled();
    if(!servicePermisssion){
      print("service disabled");
    }
    permission= await Geolocator.checkPermission();
      if(permission==LocationPermission.denied){
        permission= await Geolocator.requestPermission();
      }
    return await Geolocator.getCurrentPosition();
  }

  _getAddressFromCoordinates() async{
    try {
      List<Placemark> placemarks= await placemarkFromCoordinates(_currentLocation!.latitude, _currentLocation!.longitude);
      Placemark place=placemarks[0];
       setState(() {
         currentAddress = "${place.locality},${place.country}";
       });
    } catch (e) {
      print(e);
    }
  }
  
  late String? text="Set Location";
  @override
  void initState() {
    getLocation();

    // TODO: implement initState
    super.initState();
  }

  getLocation()async{
 

 
  _currentLocation = await  _getCurrentLocation();
                  print("${_currentLocation}");
                  await _getAddressFromCoordinates();
                  print("${currentAddress}");
                  setState(() {
                    text=currentAddress;
                  });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async{
        final value= await Navigator.push(context, MaterialPageRoute(builder: (context)=>SelectDeliveryLocationScreen()));
        setState(() {
          text=value;
        });
      },
      child: Container(
        child: Text(
          '${text}',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
      ),
    );
  }
}

class FilterOptions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        FilterChip(
          
          label: Text('veg'),
          onSelected: (selected) {},
          selected: true,
        ),
        SizedBox(width: 8),
        FilterChip(
          label: Text('non veg'),
          onSelected: (selected) {},
        ),
        SizedBox(width: 8),
        FilterChip(
          label: Text('Vegan'),
          onSelected: (selected) {},
        ),
      ],
    );
  }
}
class FoodCard extends StatelessWidget {
  final String imageUrl;
  final String discount;
  final String name;
  final double price;

  const FoodCard({Key? key, required this.imageUrl, required this.discount, required this.name, required this.price}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200, // Fixed width to avoid Infinity or NaN errors
      height: 300, // Increased height to accommodate the button
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                        return Center(
                          child: Icon(
                            Icons.error,
                            color: Colors.red,
                          ),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      color: Colors.black54,
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: Text(
                        "$name\n\$$price",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text("$name\n\t\$$price"),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ElevatedButton(
                  onPressed: () {
                    var cart = Provider.of<CartModel>(context, listen: false);
                    cart.addItem(name, price);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green, // Button color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Add to Cart',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }}