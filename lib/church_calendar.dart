class NameOfDay {
  final _value;
  const NameOfDay._internal(this._value);

  int toInt() => _value as int;
}

const pascha = const NameOfDay._internal(100000);
const palmSunday = const NameOfDay._internal(100001);
const ascension = const NameOfDay._internal(100002);
const pentecost = const NameOfDay._internal(100003);

const theotokosLiveGiving = const NameOfDay._internal(100100);
const theotokosDubenskaya = const NameOfDay._internal(100101);
const theotokosChelnskaya = const NameOfDay._internal(100103);
const theotokosWall = const NameOfDay._internal(100105);
const theotokosSevenArrows = const NameOfDay._internal(100106);
const firstCouncil = const NameOfDay._internal(100107);
const theotokosTabynsk = const NameOfDay._internal(100108);
const newMartyrsOfRussia = const NameOfDay._internal(100109);

class Days {
  Days(this.days);
  int days;

  DateTime operator +(DateTime d) => d.add(Duration(days: days));
  DateTime operator -(DateTime d) => d.subtract(Duration(days: days));
}

class ChurchCalendar {
  static DateTime currentDate;
  static int currentYear;

  static Map<DateTime, List<NameOfDay>> feasts;

  static DateTime paschaDay(int year) {
    final a = (19 * (year % 19) + 15) % 30;
    final b = (2 * (year % 4) + 4 * (year % 7) + 6 * a + 6) % 7;

    return ((a + b > 10)
            ? DateTime(year, 4, a + b - 9)
            : DateTime(year, 3, 22 + a + b))
        .add(Duration(days: 13));
  }

  static DateTime nearestSundayBefore(DateTime d) => Days(d.weekday) - d;
  static DateTime nearestSundayAfter(DateTime d) => Days(7 - d.weekday) + d;

  static set date(DateTime date) {
    currentDate = date;

    if (currentYear != date.year) {
      currentYear = date.year;

      final P = paschaDay(currentYear);
      var newMartyrs = DateTime(currentYear, 2, 7);

      switch (newMartyrs.weekday) {
        case DateTime.sunday:
          break;

        case DateTime.monday:
        case DateTime.tuesday:
        case DateTime.wednesday:
          newMartyrs = nearestSundayBefore(newMartyrs);
          break;

        default:
          newMartyrs = nearestSundayAfter(newMartyrs);
      }

      feasts = {
        Days(7) - P: [palmSunday],
        P: [pascha],
        Days(39) + P: [ascension],
        Days(49) + P: [pentecost],
        Days(5) + P: [theotokosLiveGiving],
        Days(24) + P: [theotokosDubenskaya],
        Days(42) + P: [theotokosChelnskaya, firstCouncil],
        Days(56) + P: [theotokosWall, theotokosSevenArrows],
        Days(61) + P: [theotokosTabynsk],
        newMartyrs: [newMartyrsOfRussia]
      };
    }
  }
}
