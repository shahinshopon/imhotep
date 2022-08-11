import 'package:flutter/material.dart';

class PremiumFeature extends StatefulWidget {
  const PremiumFeature({ Key? key }) : super(key: key);

  @override
  _PremiumFeatureState createState() => _PremiumFeatureState();
}

class _PremiumFeatureState extends State<PremiumFeature> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size. height / 1.4,
              child: Card(
                child: AlertDialog(),
              ),)
          ],
        ),
      ),
      
    );
  }
}