import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class BannerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * .25,
        color: Colors.cyan,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "CARS",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: 45.0,
                          child: DefaultTextStyle(
                            style: const TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                            ),
                            child: AnimatedTextKit(
                              repeatForever: true,
                              isRepeatingAnimation: true,
                              animatedTexts: [
                                FadeAnimatedText('Reach 10 Lakh+\nInterested Buyers',
                                duration: Duration(seconds: 4),
                                ),
                                FadeAnimatedText('New way to\nBuy or sell Cars',
                                  duration: Duration(seconds: 4),
                                ),
                                FadeAnimatedText('Over 1 Lakh\nCars to Buy',
                                  duration: Duration(seconds: 4),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Neumorphic(
                      style: NeumorphicStyle(
                        color: Colors.white,
                      ),
                      child: Image.network('https://firebasestorage.googleapis.com/v0/b/buyorsell-61cca.appspot.com/o/banner%2Ficons8-carpool-100.png?alt=media&token=183ee275-902a-4a4b-b192-b4079396de3b'),


                    )
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(child: NeumorphicButton(
                    onPressed: (){},
                    style: NeumorphicStyle(color: Colors.white),
                    child: Text("Buy Car",textAlign: TextAlign.center,),
                  ),),
                  SizedBox(width: 20,),
                  Expanded(child: NeumorphicButton(
                    onPressed: (){},
                    style: NeumorphicStyle(color: Colors.white),
                    child: Text("Sell Car",textAlign: TextAlign.center,),
                  ),),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
