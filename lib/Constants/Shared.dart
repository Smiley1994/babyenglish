

class Manager {

  factory Manager() =>_getInstance();
  static Manager get instance => _getInstance();
  static Manager _instance;
  Manager._internal() {
    // 初始化
  }

  static Manager _getInstance() {
    if (_instance == null) {
      _instance = new Manager._internal();
    }
    return _instance;
  }
}

String vipStatus;