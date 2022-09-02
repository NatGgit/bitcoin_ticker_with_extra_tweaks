import 'dart:convert';
import 'dart:developer';

import 'package:bitcoin_ticker/logic/simple_response.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

class CoinData {
  final _baseUrl = 'https://rest.coinapi.io/v1/exchangerate/';
  final _apiKey = 'C6D044C8-C340-4705-93A2-8268A4750630';

  Future<SimpleResponse> getCoinData(
      {@required String currency, @required String crypto}) async {
    try {
      final result = await http.get(Uri.parse('$_baseUrl$crypto/$currency'),
          headers: {"X-CoinAPI-Key": _apiKey});
      final json = jsonDecode(result.body);
      return SimpleResponse(
          error: json['error'],
          result: (json['rate'] as double)?.toStringAsFixed(2));
    } catch (error, stack) {
      log(error.toString(), stackTrace: stack);
      return null;
    }
  }
}
