import 'package:tikd/base.dart';
import 'package:tikd/path.dart';
import 'package:tikd/picture.dart';

abstract class StyleOption extends Referable {}

String joinOptions(List<StyleOption> options) =>
    options.isEmpty ? '' : '[${options.join(', ')}]';

class StringOption extends StyleOption {
  StringOption(this.value);
  final String value;

  @override
  String get definition => value;
}

final helpLinesStyle = StringOption('help lines');
final singleArrowStyle = StringOption('->');

class Thickness extends StringOption {
  Thickness.veryThick() : super('very thick');
  Thickness.veryThin() : super('very thin');

  @override
  String get definition => value;
}

class DoubleOption extends StyleOption {
  DoubleOption(this.name, this.value, {this.unit = ''});
  final String name;
  final double value;
  final String unit;
  String get vu => '$value$unit';

  @override
  String get definition => '$name=$vu';
}

class Scale extends DoubleOption {
  Scale(double v, {String unit = ''}) : super('scale', v, unit: unit);
}

class TextWidth extends DoubleOption {
  TextWidth(double w, {String unit = ''}) : super('text width', w, unit: unit);
}

class Placement extends StyleOption {
  Placement.above({double? by, String unit = ''}) : this._('above', by, unit);
  Placement.below({double? by, String unit = ''}) : this._('below', by, unit);
  Placement.left({double? by, String unit = ''}) : this._('left', by, unit);
  Placement.right({double? by, String unit = ''}) : this._('right', by, unit);

  Placement._(this.name, this.value, this.unit);
  final String name;
  final double? value;
  final String unit;

  @override
  String get definition => '$name${value == null ? '' : '=$value$unit'}';
}

class Shift extends StyleOption {
  Shift(this.xy);
  final XY xy;

  @override
  String get definition => 'shift={$xy}';
}

class LineCap extends StringOption {
  LineCap.round() : super('round');
  LineCap.butt() : super('butt');

  @override
  String get definition => 'line cap=$value';
}

class Corners extends StringOption {
  Corners.rounded() : super('rounded');

  @override
  String get definition => '$value corners';
}

abstract class Color extends StyleOption {
  static final SingleColor red = SingleColor.red();
  static final SingleColor green = SingleColor.green();
  static final SingleColor blue = SingleColor.blue();
  static final SingleColor orange = SingleColor.orange();
  static final SingleColor black = SingleColor.black();
  static final SingleColor white = SingleColor.white();
}

class SingleColor extends Color {
  SingleColor.red() : this._('red');
  SingleColor.green() : this._('green');
  SingleColor.blue() : this._('blue');
  SingleColor.orange() : this._('orange');
  SingleColor.black() : this._('black');
  SingleColor.white() : this._('white');

  SingleColor._(this.name, {this.percent});
  final String name;
  final int? percent;

  SingleColor operator %(int percent) => SingleColor._(name, percent: percent);
  MixedColor operator +(SingleColor other) => MixedColor([this, other]);

  @override
  String get definition => '$name${percent == null ? '' : '!$percent'}';
}

class MixedColor extends Color {
  MixedColor(this.colors);
  final List<SingleColor> colors;
  MixedColor operator +(SingleColor other) => MixedColor([...colors, other]);

  @override
  String get definition => colors.join('!');
}

class CustomColor extends Color {
  CustomColor(Picture picture, this.name, this.color) {
    picture.addRaw(definition);
  }
  final String name;
  final Color color;

  @override
  String get definition => '\\colorlet{$name}{$color}';

  @override
  String get reference => name;
}

class Fill extends StyleOption {
  Fill(this.color);
  final Color color;

  @override
  String get definition => 'fill=$color';
}

class Draw extends StyleOption {
  Draw(this.color);
  final Color color;

  @override
  String get definition => 'draw=$color';
}

class InnerSep extends StyleOption {
  InnerSep(this.sep, {this.unit = ''});
  final double sep;
  final String unit;

  @override
  String get definition => 'inner sep=$sep$unit';
}

class CustomStyle extends StyleOption {
  CustomStyle(Picture picture, this.name, this.options) {
    picture.addStyle(this);
  }
  final String name;
  final List<StyleOption> options;

  @override
  String get definition => '$name/.style={${options.join(', ')}}';

  @override
  String get reference => name;
}

class Intersection extends StyleOption {
  Intersection(this.pathNameA, this.pathNameB, this.byName);
  final String pathNameA, pathNameB;
  final String byName;

  StringPosition get position => StringPosition('($byName)');

  @override
  String get definition =>
      'name intersections={of=$pathNameA and $pathNameB, by=$byName}';
}
