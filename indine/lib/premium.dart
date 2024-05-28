import 'package:flutter/material.dart';

class premium extends StatelessWidget {
  const premium({super.key});
  
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Color.fromARGB(255, 164, 195, 178),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Become a premium member today"),
            Text("Get access to exclusive deals and features"),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(onPressed: (){}, child: Text("Join now!!!"), style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF6C8E78), // Button color
                padding: EdgeInsets.symmetric(vertical: 16),
                minimumSize: Size(200, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),)
          ],
        ),
      ),
    );
  }
}