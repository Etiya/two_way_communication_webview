import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Material App Bar'),
        ),
        body: Center(
          child: Container(
            child: buildWebView(),
          ),
        ),
      ),
    );
  }

  Widget buildWebView() {
    WebViewController? _webViewController;

    return WebView(
      initialUrl: 'about:blank',
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (WebViewController webViewController) async {
        _webViewController = webViewController;
        String fileContent = await rootBundle.loadString('assets/index.html');
        _webViewController?.loadUrl(Uri.dataFromString(fileContent,
                mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
            .toString());
      },
      javascriptChannels: <JavascriptChannel>{
        JavascriptChannel(
          name: 'messageHandler',
          onMessageReceived: (JavascriptMessage message) {
            log(message.message.toString());
            log("message from the web view=\"${message.message}\"");
            final script =
                "document.getElementById('value').innerText=\"${message.message}\"";
            _webViewController?.runJavascript(script);
          },
        )
      },
    );
  }
}
