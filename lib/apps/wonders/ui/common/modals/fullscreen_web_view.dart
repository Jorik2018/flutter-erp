import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_erp/apps/wonders/common_libs.dart';

class FullscreenWebView extends StatelessWidget {
  
  const FullscreenWebView(this.url, {Key? key}) : super(key: key);

  final String url;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: InAppWebView(
          /**The argument type 'Uri' can't be assigned to the parameter type 'WebUri?' */
          initialUrlRequest: URLRequest(url: WebUri(url)),
        ),
      ),
    );
  }
}
