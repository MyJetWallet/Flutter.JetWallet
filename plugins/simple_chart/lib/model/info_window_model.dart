import 'candle_model.dart';

class InfoWindowModel {
  InfoWindowModel(this.kLineEntity, {required this.isLeft});

  CandleModel kLineEntity;
  bool isLeft = false;
}
