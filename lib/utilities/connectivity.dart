import 'dart:async';
import 'package:bcard/utilities/localStorage.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:connectivity/connectivity.dart';

class AppConnectivity {
  static Connectivity _connectivity;
  static bool _connected = false, _insideNoInternetScreen = false;
  static StreamSubscription<ConnectivityResult> _connectivityResults;
  static BuildContext _context;
  static Timer _connectivityTimer;
  static bool _disposed = false;
  static Function(BuildContext) _tobeCalledFunction;

  static bool get isConnected => _connected ?? false;

  static Future<void> init() async {
    _connectivity = new Connectivity();
    await _checkConnectivity();
    _subscribeConnectivity();
    _connectivityTimer = Timer.periodic(Duration(seconds: 15), (_) async {
      /* if (!_disposed) {
        if (await _pingResult()) {
          _connected = true;
          getBackFromNoInternetScreen();
        } else {
          _connected = false;
          navigateToNoInternetScreen();
        }
      } */
    });
  }

  static set context(BuildContext context) {
    _context = context;
  }

  static Future<void> _checkConnectivity() async {
    ConnectivityResult res = await _connectivity.checkConnectivity();
    if (res == ConnectivityResult.mobile || res == ConnectivityResult.wifi) {
      _connected = await _pingResult();
      getBackFromNoInternetScreen();
    } else {
      _connected = false;
      navigateToNoInternetScreen();
    }
  }

  static Future<bool> _pingResult() async {
    try {
      final pingResult = await InternetAddress.lookup("google.com");
      if (pingResult.isNotEmpty && pingResult.first.rawAddress.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } on SocketException catch (e) {
      print(e);
      return false;
    }
  }

  static void _subscribeConnectivity() {
    _connectivityResults =
        _connectivity.onConnectivityChanged.listen((res) async {
      if (res == ConnectivityResult.mobile || res == ConnectivityResult.wifi) {
        _connected = await _pingResult();
        getBackFromNoInternetScreen();
        if (!AppConfig.firstSyncDone) AppConfig.synchroniseChangesToServer();
      } else {
        _connected = false;
        navigateToNoInternetScreen();
      }
    });
  }

  static void navigateToNoInternetScreen() {
    /* if (_context != null && !_insideNoInternetScreen) {
      Navigator.push(
        _context,
        MaterialPageRoute(
          builder: (context) => NoInternetScreen(),
        ),
      );
      _insideNoInternetScreen = true;
    } */
  }

  static void getBackFromNoInternetScreen() {
    /* if (_tobeCalledFunction != null) {
      _tobeCalledFunction(_context);
      _tobeCalledFunction = null;
    }
    if (_context != null && _insideNoInternetScreen) {
      Navigator.pop(_context);
      _insideNoInternetScreen = false;
    } */
  }

  static set whenConnectedFunction(
      Function(BuildContext) whenConnectedFunction) {
    _tobeCalledFunction = whenConnectedFunction;
  }

  static void dispose() {
    _connectivityResults.cancel();
    if (_connectivityTimer != null && _connectivityTimer.isActive) {
      _connectivityTimer.cancel();
    }
  }
}
