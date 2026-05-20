import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_erp/apps/wonders/common_libs.dart';
import 'package:flutter_erp/apps/wonders/ui/common/modals/fullscreen_web_view.dart';

class AboutDialogContent extends StatelessWidget {
  const AboutDialogContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void handleTap(String url) => Navigator.push(
      context,
      CupertinoPageRoute(builder: (_) => FullscreenWebView(url)),
    );

    List<TextSpan> buildSpan(String label, {String? link}) {
      if (link == null || link.isEmpty) {
        return [TextSpan(text: label)];
      }

      return [
        TextSpan(
          text: label,
          recognizer: TapGestureRecognizer()..onTap = () => handleTap(link),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: $styles.colors.accent1,
          ),
        ),
      ];
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          Gap($styles.insets.sm),
          RichText(
            text: TextSpan(
              style: $styles.text.bodySmall.copyWith(color: Colors.black),
              children: [
                ...buildSpan($strings.homeMenuAboutWonderous),
                ...buildSpan(
                  $strings.homeMenuAboutBuilt($strings.homeMenuAboutFlutter, $strings.homeMenuAboutGskinner),
                  link:'https://flutter.dev, https://gskinner.com/flutter'
                ),
                ...buildSpan('\n\n'),
                ...buildSpan(
                  $strings.homeMenuAboutLearn($strings.homeMenuAboutApp),
                  link:'https://wonderous.app'
                ),
                ...buildSpan('\n\n'),
                ...buildSpan(
                  $strings.homeMenuAboutSource($strings.homeMenuAboutRepo),
                  link:'https://github.com/gskinnerTeam/flutter-wonders-app',
                ),
                ...buildSpan('\n\n'),
                ...buildSpan(
                  $strings.homeMenuAboutPublic($strings.homeMenuAboutMet),
                  link:'https://www.metmuseum.org/about-the-met/policies-and-documents/open-access',
                ),
                ...buildSpan('\n\n'),
                ...buildSpan(
                  $strings.homeMenuAboutPhotography([
                    $strings.homeMenuAboutUnsplash,
                    'https://unsplash.com/@gskinner/collections',
                  ]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
