import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _scanBarcodeResult = "Scan a QR code";

  Future<void> scanQrcode() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      debugPrint(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    } catch (e) {
      barcodeScanRes = 'Error: $e';
    }
    if (!mounted) return;
    setState(() {
      _scanBarcodeResult = barcodeScanRes;
    });
  }


  Future<void> _launchURL() async {
    if (await canLaunch(_scanBarcodeResult)) {
      await launch(_scanBarcodeResult);
    } else {

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open the link.'))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QR Code Scanner',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('QR Code Scanner'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton.icon(
                  onPressed: scanQrcode,
                  icon: Icon(Icons.qr_code_scanner),
                  label: Text('Scan QR Code'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Scan Result:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: _scanBarcodeResult.startsWith('http') ? _launchURL : null,
                  child: Text(
                    _scanBarcodeResult,
                    style: TextStyle(
                      fontSize: 16,
                      color: _scanBarcodeResult.startsWith('http')
                          ? Colors.blue
                          : Colors.black,
                      decoration: _scanBarcodeResult.startsWith('http')
                          ? TextDecoration.underline
                          : TextDecoration.none,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
