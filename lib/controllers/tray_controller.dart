import 'dart:async';
import 'dart:io';
import 'package:get/get.dart';
import 'package:tray_manager/tray_manager.dart';

const _kIconTypeDefault = 'default';
const _kIconTypeOriginal = 'original';

class TrayController extends GetxController {
  RxBool istrayon = false.obs;

  String _iconType = _kIconTypeOriginal;

  Timer? _timer;

  destroytrayicon() {
    trayManager.destroy();
  }

  Future<void> _handleSetIcon(String iconType) async {
    _iconType = iconType;
    String iconPath =
        Platform.isWindows ? 'assets/tray_icon.ico' : 'assets/tray_icon.png';

    if (_iconType == 'original') {
      iconPath = Platform.isWindows
          ? 'assets/tray_icon_original.ico'
          : 'assets/tray_icon_original.png';
    }

    await trayManager.setIcon(iconPath);
  }

  void startIconFlashing() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      _handleSetIcon(
        _iconType == _kIconTypeOriginal
            ? _kIconTypeDefault
            : _kIconTypeOriginal,
      );
    });
  }

  void stopIconFlashing() {
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
      _handleSetIcon(_kIconTypeOriginal);
    }

  }

  flashing() {
    bool isFlashing = (_timer != null && _timer!.isActive);
    isFlashing ? stopIconFlashing : startIconFlashing;
  }

  setdefaulticon() {
    _handleSetIcon(_kIconTypeDefault);
  }

  setoriginalicon() {
    _handleSetIcon(_kIconTypeOriginal);
  }

  showicon() {
    istrayon.value = true;
  }

  // Not using this

  // popupmenue() async {
  //   await trayManager.setContextMenu(_menu);
  //   await trayManager.popUpContextMenu();
  // }

  @override
  void onInit() {
    super.onInit();
          _handleSetIcon(_kIconTypeOriginal);
  }
}
