import 'package:buysell/screen/location_screen.dart';
import 'package:buysell/services/firebase_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FirebaseServices _services = FirebaseServices();

    return FutureBuilder<DocumentSnapshot>(
      future: _services.users.doc(_services.user.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }
        //here
        if (!snapshot.hasData==null && !snapshot.data.exists) {
          return Text("Address not selected  ");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data.data();

          if (data['address'] == null) {
            //will check next data
            if (data['state'] == null) {
              //must be there
              GeoPoint latLong = data['location'];
              _services
                  .getAddress(latLong.latitude, latLong.longitude)
                  .then((adres) {
                //this address will show in appbar
                return appBar(adres, context);
              });
            }
          } else {
            return appBar(data['address'], context);
          }
        }

        return appBar("Fetching location", context);
      },
    );
  }

  Widget appBar(address, context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.0,
      automaticallyImplyLeading: false,
      title: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => LocationScreen(locationChanging: true,),
              ),
          );
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: Row(
              children: [
                Icon(
                  CupertinoIcons.location_solid,
                  color: Colors.black,
                  size: 18,
                ),
                Flexible(
                    child: Text(
                  address,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                )),
                Icon(
                  Icons.keyboard_arrow_down_outlined,
                  color: Colors.black,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}