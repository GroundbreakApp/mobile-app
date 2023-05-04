import 'package:flutter/material.dart';
import 'package:ground_break/utils/utils.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CalendlyPage extends StatelessWidget {
  CalendlyPage({
    Key? key,
    required this.url,
  })  : _controller = WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..loadRequest(Uri.parse(url)),
        super(key: key);

  final String url;
  final WebViewController _controller;

  static Route route({required String url}) =>
      AppUIUtils.fadeTransitionBuilder(CalendlyPage(url: url));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Book an Event')),
      body: WebViewWidget(
        controller: _controller,
      ),
    );
  }
}
