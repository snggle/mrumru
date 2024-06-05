import 'dart:io';
import 'dart:typed_data';

class TestUtils {
  static List<Float32List> parseFileToFloat32List(File file) {
    List<String> lines = file.readAsLinesSync();
    List<Float32List> float32ListGroups = lines.map((String line) {
      List<double> doubleValues = line.split(',').map((String value) => double.parse(value.trim())).toList();
      return Float32List.fromList(doubleValues);
    }).toList();

    return float32ListGroups;
  }

  static Future<List<double>> readAsDoubleFromFile(File file) async {
    return (await file.readAsString()).split(', ').map(double.parse).toList();
  }

  static List<double> roundList(List<double> list, int decimalPlaces) {
    return list.map((double value) => double.parse(value.toStringAsFixed(decimalPlaces))).toList();
  }
}
