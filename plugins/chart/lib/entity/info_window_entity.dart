import '../entity/candle_model.dart';

class InfoWindowEntity {
  InfoWindowEntity(this.kLineEntity, {required this.isLeft});

  CandleModel kLineEntity;
  bool isLeft = false;
}
