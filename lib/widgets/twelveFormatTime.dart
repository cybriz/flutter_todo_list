class TwelveFormatTime {
  static int setHour(int hour) {
    switch (hour) {
      case 13:
        return hour = 1;
        break;
      case 14:
        return hour = 2;
        break;
      case 15:
        return hour = 3;
        break;
      case 16:
        return hour = 4;
        break;
      case 17:
        return hour = 5;
        break;
      case 18:
        return hour = 6;
        break;
      case 19:
        return hour = 7;
        break;
      case 20:
        return hour = 8;
        break;
      case 21:
        return hour = 9;
        break;
      case 22:
        return hour = 10;
        break;
      case 23:
        return hour = 11;
        break;
      case 24:
        return hour = 12;
        break;
      default:
        return hour = 1;
        break;
    }
  }
}
