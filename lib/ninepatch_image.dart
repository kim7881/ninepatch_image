library ninepatch_image;

import 'package:flutter/material.dart';
import 'package:image_pixels/image_pixels.dart';

class NinePatchImage extends StatelessWidget {
  final bool hideLines;
  final ImageProvider imageProvider;
  final Widget child;

  const NinePatchImage({
    Key? key,
    required this.imageProvider,
    required this.child,
    this.hideLines = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ImagePixels(
      imageProvider: imageProvider,
      builder: (context, img) {
        var leftTop = -1;
        var leftBottom = -1;

        var rightTop = -1;
        var rightBottom = -1;

        if (img.height != null) {
          for (var i = 0; i < img.height!; i++) {
            var color = img.pixelColorAt!(0, i);
            if (color == Colors.black) {
              if (leftTop == -1) {
                leftTop = i;
              }
              if (leftTop != -1) {
                leftBottom = i;
              }
            }
          }

          for (var i = 0; i < img.width!; i++) {
            var color = img.pixelColorAt!(i, 0);
            if (color == Colors.black) {
              if (rightTop == -1) {
                rightTop = i;
              }
              if (rightTop != -1) {
                rightBottom = i;
              }
            }
          }
        } else {
          leftTop = 0;
          leftBottom = 0;
          rightTop = 0;
          rightBottom = 0;
        }

        double leftPadding = rightTop.toDouble();
        double topPadding = leftTop.toDouble();
        double rightPadding = (img.width ?? 0) - rightBottom.toDouble();
        double bottomPadding = (img.height ?? 0) - leftBottom.toDouble();

        return ClipPath(
          clipper: BlackLineClipper(hideLines: hideLines),
          child: Container(
            padding: EdgeInsets.fromLTRB(
              leftPadding < 0 ? 0 : leftPadding,
              topPadding < 0 ? 0 : topPadding,
              rightPadding < 0 ? 0 : rightPadding,
              bottomPadding < 0 ? 0 : bottomPadding,
            ),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: imageProvider,
                centerSlice: Rect.fromLTRB(
                  rightTop.toDouble(),
                  leftTop.toDouble(),
                  rightBottom.toDouble(),
                  leftBottom.toDouble(),
                ),
              ),
            ),
            child: child,
          ),
        );
      },
    );
  }
}

class BlackLineClipper extends CustomClipper<Path> {
  final bool hideLines;

  BlackLineClipper({required this.hideLines});

  @override
  Path getClip(Size size) {
    final path = Path();
    double x = hideLines ? 2 : 0;
    path.moveTo(x, x);
    path.lineTo(x, size.height - x);
    path.lineTo(size.width - x, size.height - x);
    path.lineTo(size.width - x, x);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(BlackLineClipper oldClipper) => true;
}
