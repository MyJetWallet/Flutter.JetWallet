enum ScreenSizeEnum { small, large }

const _smallHeightBreakpoint = 800;

ScreenSizeEnum deviceSizeFrom(double screenHeight) {
  return screenHeight < _smallHeightBreakpoint ? ScreenSizeEnum.small : ScreenSizeEnum.large;
}
