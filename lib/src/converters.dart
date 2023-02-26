/// this [mapConversions] and [listConversions] used to easily convert value to common type
/// and not care about custom serializer.
///
/// in upstash js library this will work out of the box, but in dart need to explicitly cast the value,
/// you can also add new convert if you want using [addNewConverter]
///
final mapConversions = {
  // -------------------- MAP CONVERSION -----------------------
  // raw
  (Map<String, String>).toString(): (Map value) =>
      Map<String, String>.from(value),
  (Map<String, String?>).toString(): (Map value) =>
      Map<String, String>.from(value),
  (Map<String, int>).toString(): (Map value) => Map<String, int>.from(value),
  (Map<String, int?>).toString(): (Map value) => Map<String, int>.from(value),
  (Map<String, double>).toString(): (Map value) =>
      Map<String, double>.from(value),
  (Map<String, double?>).toString(): (Map value) =>
      Map<String, double>.from(value),
  (Map<String, bool>).toString(): (Map value) => Map<String, bool>.from(value),
  (Map<String, bool?>).toString(): (Map value) => Map<String, bool>.from(value),
  (Map<String, dynamic>).toString(): (Map value) =>
      Map<String, dynamic>.from(value),
  // list raw value
  (Map<String, List<String>>).toString(): (Map value) {
    return Map<String, List<String>>.fromEntries(
      value.entries
          .map((e) => MapEntry(e.key as String, List<String>.from(e.value))),
    );
  },
  (Map<String, List<int>>).toString(): (Map value) {
    return Map<String, List<int>>.fromEntries(
      value.entries
          .map((e) => MapEntry(e.key as String, List<int>.from(e.value))),
    );
  },
  (Map<String, List<double>>).toString(): (Map value) {
    return Map<String, List<double>>.fromEntries(
      value.entries
          .map((e) => MapEntry(e.key as String, List<double>.from(e.value))),
    );
  },
  (Map<String, List<bool>>).toString(): (Map value) {
    return Map<String, List<bool>>.fromEntries(
      value.entries
          .map((e) => MapEntry(e.key as String, List<bool>.from(e.value))),
    );
  },
  (Map<String, List<dynamic>>).toString(): (Map value) =>
      Map<String, List<dynamic>>.from(value),
  // map raw value inside the map
  (Map<String, Map<String, String>>).toString(): (Map value) {
    return Map<String, Map<String, String>>.fromEntries(
      value.entries.map(
          (e) => MapEntry(e.key as String, Map<String, String>.from(e.value))),
    );
  },
  (Map<String, Map<String, int>>).toString(): (Map value) {
    return Map<String, Map<String, int>>.fromEntries(
      value.entries.map(
          (e) => MapEntry(e.key as String, Map<String, int>.from(e.value))),
    );
  },
  (Map<String, Map<String, double>>).toString(): (Map value) {
    return Map<String, Map<String, double>>.fromEntries(
      value.entries.map(
          (e) => MapEntry(e.key as String, Map<String, double>.from(e.value))),
    );
  },
  (Map<String, Map<String, bool>>).toString(): (Map value) {
    return Map<String, Map<String, bool>>.fromEntries(
      value.entries.map(
          (e) => MapEntry(e.key as String, Map<String, bool>.from(e.value))),
    );
  },
  (Map<String, Map<String, dynamic>>).toString(): (Map value) {
    return Map<String, Map<String, dynamic>>.fromEntries(
      value.entries.map(
          (e) => MapEntry(e.key as String, Map<String, dynamic>.from(e.value))),
    );
  },
  // list raw value inside the map
  (Map<String, Map<String, List<String>>>).toString(): (Map value) {
    return Map<String, Map<String, List<String>>>.fromEntries(
      value.entries.map(
        (e) => MapEntry(
          e.key as String,
          Map<String, List<String>>.fromEntries(
            (e.value as Map).entries.map(
                  (e) => MapEntry(e.key as String, List<String>.from(e.value)),
                ),
          ),
        ),
      ),
    );
  },
  (Map<String, Map<String, List<int>>>).toString(): (Map value) {
    return Map<String, Map<String, List<int>>>.fromEntries(
      value.entries.map(
        (e) => MapEntry(
          e.key as String,
          Map<String, List<int>>.fromEntries(
            (e.value as Map)
                .entries
                .map((e) => MapEntry(e.key as String, List<int>.from(e.value))),
          ),
        ),
      ),
    );
  },
  (Map<String, Map<String, List<double>>>).toString(): (Map value) {
    return Map<String, Map<String, List<double>>>.fromEntries(
      value.entries.map(
        (e) => MapEntry(
          e.key as String,
          Map<String, List<double>>.fromEntries(
            (e.value as Map).entries.map(
                (e) => MapEntry(e.key as String, List<double>.from(e.value))),
          ),
        ),
      ),
    );
  },
  (Map<String, Map<String, List<bool>>>).toString(): (Map value) {
    return Map<String, Map<String, List<bool>>>.fromEntries(
      value.entries.map(
        (e) => MapEntry(
          e.key as String,
          Map<String, List<bool>>.fromEntries(
            (e.value as Map).entries.map(
                (e) => MapEntry(e.key as String, List<bool>.from(e.value))),
          ),
        ),
      ),
    );
  },
  (Map<String, Map<String, List<dynamic>>>).toString(): (Map value) {
    return Map<String, Map<String, List<dynamic>>>.fromEntries(
      value.entries.map(
        (e) => MapEntry(
          e.key as String,
          Map<String, List<dynamic>>.fromEntries(
            (e.value as Map).entries.map(
                (e) => MapEntry(e.key as String, List<dynamic>.from(e.value))),
          ),
        ),
      ),
    );
  },
};

final listConversions = {
  // -------------------- LIST CONVERSION -----------------------
  // raw
  (List<String>).toString(): (List value) => List<String>.from(value),
  (List<String?>).toString(): (List value) => List<String?>.from(value),
  (List<int>).toString(): (List value) => List<int>.from(value),
  (List<int?>).toString(): (List value) => List<int?>.from(value),
  (List<double>).toString(): (List value) => List<double>.from(value),
  (List<double?>).toString(): (List value) => List<double?>.from(value),
  (List<bool>).toString(): (List value) => List<bool>.from(value),
  (List<bool?>).toString(): (List value) => List<bool?>.from(value),
  (List<dynamic>).toString(): (List value) => List<dynamic>.from(value),
  // list with map: raw value
  (List<Map<String, String>>).toString(): (List value) {
    return List<Map<String, String>>.from(
        value.map((e) => Map<String, String>.from(e as Map)));
  },
  (List<Map<String, String>?>).toString(): (List value) {
    return List<Map<String, String>>.from(
        value.map((e) => Map<String, String>.from(e as Map)));
  },
  (List<Map<String, int>>).toString(): (List value) {
    return List<Map<String, int>>.from(
        value.map((e) => Map<String, int>.from(e as Map)));
  },
  (List<Map<String, int>?>).toString(): (List value) {
    return List<Map<String, int>>.from(
        value.map((e) => Map<String, int>.from(e as Map)));
  },
  (List<Map<String, double>>).toString(): (List value) {
    return List<Map<String, double>>.from(
        value.map((e) => Map<String, double>.from(e as Map)));
  },
  (List<Map<String, double>?>).toString(): (List value) {
    return List<Map<String, double>>.from(
        value.map((e) => Map<String, double>.from(e as Map)));
  },
  (List<Map<String, bool>>).toString(): (List value) {
    return List<Map<String, bool>>.from(
        value.map((e) => Map<String, bool>.from(e as Map)));
  },
  (List<Map<String, bool>?>).toString(): (List value) {
    return List<Map<String, bool>>.from(
        value.map((e) => Map<String, bool>.from(e as Map)));
  },
  (List<Map<String, dynamic>>).toString(): (List value) {
    return List<Map<String, dynamic>>.from(
        value.map((e) => Map<String, dynamic>.from(e as Map)));
  },
  (List<Map<String, dynamic>?>).toString(): (List value) {
    return List<Map<String, dynamic>>.from(
        value.map((e) => Map<String, dynamic>.from(e as Map)));
  },
  // list inside map
  (List<Map<String, List<String>>>).toString(): (List value) {
    return List<Map<String, List<String>>>.from(
      value.map(
        (e) => Map<String, List<String>>.fromEntries((e as Map).entries.map(
            (e) =>
                MapEntry(e.key as String, List<String>.from(e.value as List)))),
      ),
    );
  },
  (List<Map<String, List<int>>>).toString(): (List value) {
    return List<Map<String, List<int>>>.from(
      value.map(
        (e) => Map<String, List<int>>.fromEntries((e as Map).entries.map(
            (e) => MapEntry(e.key as String, List<int>.from(e.value as List)))),
      ),
    );
  },
  (List<Map<String, List<double>>>).toString(): (List value) {
    return List<Map<String, List<double>>>.from(
      value.map(
        (e) => Map<String, List<double>>.fromEntries((e as Map).entries.map(
            (e) =>
                MapEntry(e.key as String, List<double>.from(e.value as List)))),
      ),
    );
  },
  (List<Map<String, List<bool>>>).toString(): (List value) {
    return List<Map<String, List<bool>>>.from(
      value.map(
        (e) => Map<String, List<bool>>.fromEntries((e as Map).entries.map((e) =>
            MapEntry(e.key as String, List<bool>.from(e.value as List)))),
      ),
    );
  },
  (List<Map<String, List<dynamic>>>).toString(): (List value) {
    return List<Map<String, List<dynamic>>>.from(
      value.map(
        (e) => Map<String, List<dynamic>>.fromEntries((e as Map).entries.map(
            (e) => MapEntry(
                e.key as String, List<dynamic>.from(e.value as List)))),
      ),
    );
  },
  // map inside map
  (List<Map<String, Map<String, String>>>).toString(): (List value) {
    return List<Map<String, Map<String, String>>>.from(
      value.map(
        (e) => Map<String, Map<String, String>>.fromEntries((e as Map)
            .entries
            .map((e) => MapEntry(
                e.key as String, Map<String, String>.from(e.value as Map)))),
      ),
    );
  },
  (List<Map<String, Map<String, int>>>).toString(): (List value) {
    return List<Map<String, Map<String, int>>>.from(
      value.map(
        (e) => Map<String, Map<String, int>>.fromEntries((e as Map).entries.map(
            (e) => MapEntry(
                e.key as String, Map<String, int>.from(e.value as Map)))),
      ),
    );
  },
  (List<Map<String, Map<String, double>>>).toString(): (List value) {
    return List<Map<String, Map<String, double>>>.from(
      value.map(
        (e) => Map<String, Map<String, double>>.fromEntries((e as Map)
            .entries
            .map((e) => MapEntry(
                e.key as String, Map<String, double>.from(e.value as Map)))),
      ),
    );
  },
  (List<Map<String, Map<String, bool>>>).toString(): (List value) {
    return List<Map<String, Map<String, bool>>>.from(
      value.map(
        (e) => Map<String, Map<String, bool>>.fromEntries((e as Map)
            .entries
            .map((e) => MapEntry(
                e.key as String, Map<String, bool>.from(e.value as Map)))),
      ),
    );
  },
  (List<Map<String, Map<String, dynamic>>>).toString(): (List value) {
    return List<Map<String, Map<String, dynamic>>>.from(
      value.map(
        (e) => Map<String, Map<String, dynamic>>.fromEntries((e as Map)
            .entries
            .map((e) => MapEntry(
                e.key as String, Map<String, dynamic>.from(e.value as Map)))),
      ),
    );
  },
};

void addNewConverter(
  String castType, {
  Map<String, dynamic> Function(Map value)? mapType,
  List Function(List value)? listType,
}) {
  assert(mapType == null || listType == null);

  if (mapType != null) {
    mapConversions[castType] = mapType;
  } else if (listType != null) {
    listConversions[castType] = listType;
  }
}
