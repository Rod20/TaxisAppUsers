import 'package:flutter/material.dart';
import 'package:servisurusers/ui/resources/ui_helpers.dart';

class ServisurHeader extends StatelessWidget {
  double mHeightImg;
  double mFontSizeTitle;
  Widget mSizedBox;
  Widget mSizedBoxBottom;

  ServisurHeader({
    this.mHeightImg,
    this.mFontSizeTitle
  });

  ServisurHeader.small() {
    mHeightImg = 100.0;
    mFontSizeTitle = 30.0;
    mSizedBox = UIHelper.verticalSpaceMedium();
    mSizedBoxBottom = UIHelper.verticalSpaceSmall();
  }

  ServisurHeader.medium() {
    mHeightImg = 130.0;
    mFontSizeTitle = 36.0;
    mSizedBox = UIHelper.verticalSpaceLarge();
    mSizedBoxBottom = UIHelper.verticalSpaceLarge();
  }

  @override
  Widget build(BuildContext context) {
    final sizeScreen = MediaQuery.of(context).size;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        mSizedBox,
        Container(
          width: sizeScreen.width,
          height: mHeightImg,
          child: Image.asset("assets/icon/icon.png"),
        ),
        mSizedBoxBottom,
      ],
    );
  }
}
