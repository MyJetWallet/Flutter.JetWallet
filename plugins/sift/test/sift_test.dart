import 'package:flutter_test/flutter_test.dart';
import 'package:sift/sift.dart';
import 'package:sift/sift_platform_interface.dart';
import 'package:sift/sift_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

void main() {
  final SiftPlatform initialPlatform = SiftPlatform.instance;

  test('$MethodChannelSift is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelSift>());
  });

  test('getPlatformVersion', () async {
    Sift siftPlugin = Sift();

    expect(await siftPlugin.getPlatformVersion(), '42');
  });
}
