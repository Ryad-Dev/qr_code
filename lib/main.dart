import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:qr_code/qrcode.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QR Code',
      showSemanticsDebugger: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController textQr = TextEditingController();
  String textQrCodeScan = "";

  Future<void> scanQrCode() async {
    try {
      final qrCod = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "cancel", true, ScanMode.QR);
      if (qrCod.isNotEmpty) {
        print("My code qr : $qrCod");
        textQrCodeScan = qrCod;
        setState(() {});
      }
    } on PlatformException {
      print("exception");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("QR Code"),
          centerTitle: true,
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(15)),
                child: TextFormField(
                  cursorColor: Colors.blue,
                  controller: textQr,
                  style: const TextStyle(color: Colors.blue),
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(12),
                    border: InputBorder.none,
                    hintText: "Entrer votre lien",
                    hintStyle: TextStyle(color: Colors.blue),
                  ),
                  keyboardType: TextInputType.text,
                  obscureText: false,
                ),
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(CupertinoPageRoute(
                      builder: (BuildContext context) =>
                          CreateQrCode(textQrCode: textQr.text.trim())));
                },
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(15)),
                  child: const Center(
                      child: Text(
                    "Generate",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white),
                  )),
                ),
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: () => scanQrCode(),
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Theme.of(context).primaryColor, width: 1),
                      borderRadius: BorderRadius.circular(15)),
                  child: Center(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.document_scanner_outlined,
                          color: Theme.of(context).primaryColor),
                      const SizedBox(width: 10),
                      Text(
                        "Scanner",
                        style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).primaryColor),
                      ),
                    ],
                  )),
                ),
              ),
              const SizedBox(height: 30),
              if (textQrCodeScan.isNotEmpty || textQrCodeScan != "-1")
                Text(
                  textQrCodeScan,
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                )
            ],
          ),
        ));
  }
}
