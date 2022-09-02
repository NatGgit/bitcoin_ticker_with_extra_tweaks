import 'package:flutter/material.dart';

class CurrencyCard extends StatelessWidget {
  const CurrencyCard({
    Key key,
    @required this.currency,
    @required this.sum,
    @required this.selectedValue,
  }) : super(key: key);

  final String sum;
  final String selectedValue;
  final String currency;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 9.0, 18.0, 9),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $currency = $sum $selectedValue',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
