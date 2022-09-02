import 'dart:io';

import 'package:bitcoin_ticker/logic/coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'currency_card.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedValue;
  List<String> resultList = ['?', '?', '?'];
  bool showProgressIndicator = false;
  bool isSnackBarShowing = false;

  @override
  void initState() {
    selectedValue = currenciesList.first;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(
                  height: 9,
                ),
                ...List.generate(
                  cryptoList.length,
                  ((index) {
                    return CurrencyCard(
                      currency: cryptoList[index],
                      sum: resultList[index],
                      selectedValue: selectedValue,
                    );
                  }),
                ),
              ],
            ),
            if (showProgressIndicator)
              const Center(child: CircularProgressIndicator()),
            Container(
                height: 150.0,
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 30.0),
                color: Colors.lightBlue,
                child: Platform.isIOS
                    ? CupertinoPicker(
                        backgroundColor: Colors.lightBlue,
                        itemExtent: 25,
                        onSelectedItemChanged: (int selectedIndex) async {
                          setState(() {
                            selectedValue = currenciesList[selectedIndex];
                            showProgressIndicator = true;
                          });
                          _updateValues();
                        },
                        children: currenciesList
                            .map((e) => Text(
                                  e,
                                  style: TextStyle(color: Colors.white),
                                ))
                            .toList(),
                      )
                    : DropdownButton(
                        value: selectedValue,
                        items: currenciesList
                            .map((value) => DropdownMenuItem(
                                  child: Text(value),
                                  value: value,
                                ))
                            .toList(),
                        onChanged: (value) async {
                          setState(() {
                            selectedValue = value;
                            showProgressIndicator = true;
                          });
                          _updateValues();
                        },
                      )),
          ]),
    );
  }

  Future<void> _updateValues() async {
    final btcResponse = await CoinData()
        .getCoinData(currency: selectedValue, crypto: cryptoList[0]);
    final ethResponse = await CoinData()
        .getCoinData(currency: selectedValue, crypto: cryptoList[1]);
    final ltcResponse = await CoinData()
        .getCoinData(currency: selectedValue, crypto: cryptoList[2]);
    if ((btcResponse.error != null ||
            ethResponse.error != null ||
            ltcResponse.error != null) &&
        !isSnackBarShowing) {
      isSnackBarShowing = true;
      ScaffoldMessenger.of(context)
          .showSnackBar(
            SnackBar(
              content: Text(btcResponse.error),
            ),
          )
          .closed
          .then(
        (value) {
          isSnackBarShowing = false;
        },
      );
    } else if (btcResponse.error == null &&
        ethResponse.error == null &&
        ltcResponse.error == null) {
      resultList[0] = btcResponse.result;
      resultList[1] = ethResponse.result;
      resultList[2] = ltcResponse.result;
    }
    setState(() {
      showProgressIndicator = false;
    });
  }
}
