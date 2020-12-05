import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:universal_html/html.dart';
import 'ui_fake.dart' if (dart.library.html) 'dart:ui' as ui;

class WebQrReader extends StatefulWidget {
  final WebQrReaderController controller;
  final double windowWidth;
  final double windowHeight;

  const WebQrReader({Key key, @required this.controller, this.windowHeight = 300, this.windowWidth = 300}) : super(key: key);

  @override
  _WebQrReaderState createState() => _WebQrReaderState();
}

class _WebQrReaderState extends State<WebQrReader> {
  var _rendered = false;
  IFrameElement _iFrameElement;
  @override
  void initState() {
    super.initState();
    if(kIsWeb){
      WidgetsBinding.instance.addPostFrameCallback((_) async{
        if(!_rendered){
          _rendered = true;
          while(_iFrameElement.contentWindow==null){
            await Future.delayed(Duration(milliseconds: 300));
          }
          _iFrameElement.contentWindow.postMessage(json.encode({"action":"setDimention","width":"${widget.windowWidth}px" , "height":"${widget.windowHeight}px"}), "*");
        }
        //html.window.frame
      });
      _iFrameElement = IFrameElement()
        ..allow = 'camera'
        ..width = "${widget.windowWidth.toInt()}px"
        ..height = "${widget.windowHeight.toInt()}px"
        ..src = '/packages/web_qr_reader/web/qr/index.html?version=${Random().nextInt(9999999)}'
        ..style.border = 'none'
        ..style.width = "${widget.windowWidth.toInt()}"
        ..style.height = "${widget.windowHeight.toInt()}";
      ui.platformViewRegistry.registerViewFactory(
          'flutter-qr-code',
              (int viewId) => _iFrameElement
      );
      widget.controller?.addListener(() {
        if(widget.controller.value.isCameraEnabled){
          if(_iFrameElement.contentWindow!=null)
            _iFrameElement.contentWindow.postMessage(json.encode({"action":"play"}), "*");
        }
        else{
          if(_iFrameElement.contentWindow!=null)
            _iFrameElement.contentWindow.postMessage(json.encode({"action":"pause"}), "*");
        }
      });
      _qrCheck();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: widget.windowWidth,
        height: widget.windowHeight,
        child: HtmlElementView(key: UniqueKey(), viewType: 'flutter-qr-code'));
  }

  _qrCheck() async {
    window.onMessage.listen((data) {
      if (data != null &&
          data.data != null &&
          "${data.data}".startsWith("(qr-code):")) {
        if (widget.controller != null)
          widget.controller._scanUpdateController.sink.add("${data.data}".replaceAll("(qr-code):", ""));
      }
    });
  }
}

class WebQrReaderController extends ValueNotifier<QrValue> {
  final StreamController<String> _scanUpdateController = StreamController<String>();

  WebQrReaderController({QrValue value = const QrValue.empty()}) : super(value);

  Stream<String> get scannedDataStream => _scanUpdateController.stream;

  play(){
    value = value.copyWith(isCameraEnabled: true);
  }

  pause(){
    value = value.copyWith(isCameraEnabled: false);
  }

  void dispose() {
    super.dispose();
    _scanUpdateController.close();
  }
}

class QrValue{
  final bool isCameraEnabled;

  QrValue({this.isCameraEnabled});

  const QrValue.empty():
      isCameraEnabled = true;

  copyWith({isCameraEnabled}){
    return QrValue(
      isCameraEnabled: isCameraEnabled??this.isCameraEnabled
    );
  }

}
