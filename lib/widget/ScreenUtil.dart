import 'package:flutter_screenutil/flutter_screenutil.dart';

screenutilInit(context) {
  ScreenUtil.init(
    context,
    width: defaultScreenWidth,
    height: defaultScreenHeight,
    allowFontScaling: fontScaling,
  );
}

double defaultScreenWidth = 750.0;
double defaultScreenHeight = 1334.0;
bool fontScaling = false;

/* Screen and Widget Size */
double screenWidthDp = ScreenUtil.screenWidthDp;
double screenHeightDp = ScreenUtil.screenHeightDp;
double statusBarHeight = ScreenUtil.statusBarHeight;
double appBarHeight = screenHeightDp / 10;
double textFieldHeight = screenHeightDp / 12;

/* FontSize */
double s7 = ScreenUtil().setSp(7.0);
double s8 = ScreenUtil().setSp(8.0);
double s9 = ScreenUtil().setSp(9.0);
double s10 = ScreenUtil().setSp(10.0);
double s11 = ScreenUtil().setSp(11.0);
double s12 = ScreenUtil().setSp(12.0);
double s13 = ScreenUtil().setSp(13.0);
double s14 = ScreenUtil().setSp(14.0);
double s15 = ScreenUtil().setSp(15.0);
double s16 = ScreenUtil().setSp(16.0);
double s17 = ScreenUtil().setSp(17.0);
double s18 = ScreenUtil().setSp(18.0);
double s19 = ScreenUtil().setSp(19.0);
double s20 = ScreenUtil().setSp(20.0);
double s21 = ScreenUtil().setSp(21.0);
double s22 = ScreenUtil().setSp(22.0);
double s23 = ScreenUtil().setSp(23.0);
double s24 = ScreenUtil().setSp(24.0);
double s25 = ScreenUtil().setSp(25.0);
double s26 = ScreenUtil().setSp(26.0);
double s27 = ScreenUtil().setSp(27.0);
double s28 = ScreenUtil().setSp(28.0);
double s29 = ScreenUtil().setSp(29.0);
double s30 = ScreenUtil().setSp(30.0);
double s32 = ScreenUtil().setSp(32.0);
double s34 = ScreenUtil().setSp(34.0);
double s35 = ScreenUtil().setSp(35.0);
double s36 = ScreenUtil().setSp(36.0);
double s38 = ScreenUtil().setSp(38.0);
double s40 = ScreenUtil().setSp(40.0);
double s42 = ScreenUtil().setSp(42.0);
double s46 = ScreenUtil().setSp(46.0);
double s48 = ScreenUtil().setSp(48.0);
double s52 = ScreenUtil().setSp(52.0);
double s54 = ScreenUtil().setSp(54.0);
double s58 = ScreenUtil().setSp(58.0);
double s60 = ScreenUtil().setSp(60.0);
double s65 = ScreenUtil().setSp(65.0);
double s70 = ScreenUtil().setSp(70.0);
double s81 = ScreenUtil().setSp(81.0);
double s90 = ScreenUtil().setSp(90.0);
double s100 = ScreenUtil().setSp(100.0);
double s200 = ScreenUtil().setSp(200.0);
double s300 = ScreenUtil().setSp(300.0);


