import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';

class NewsDetails extends StatelessWidget {
  final String url;


  NewsDetails({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News Details'),
      ),
      body: WebView(
        initialUrl: url,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
