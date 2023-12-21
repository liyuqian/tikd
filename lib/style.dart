import 'package:tikd/base.dart';
import 'package:tikd/geometry.dart';
import 'package:tikd/picture.dart';

abstract class StyleOption extends RawElement {}

String joinOptions(List<StyleOption> options) =>
    options.isEmpty ? '' : '[${options.join(', ')}]';

class StringOption extends StyleOption {
  StringOption(this.value);
  final String value;

  @override
  String toRaw() => value;
}

final helpLinesStyle = StringOption('help lines');
final singleArrowStyle = StringOption('->');

class Thickness extends StringOption {
  Thickness.veryThick() : super('very thick');
  Thickness.veryThin() : super('very thin');

  @override
  String toRaw() => value;
}

abstract class DoubleOption extends StyleOption {
  DoubleOption(this.value, {this.unit = ''});
  final double value;
  final String unit;
  String get vu => '$value$unit';
}

class Scale extends DoubleOption {
  Scale(super.value);

  @override
  String toRaw() => 'scale=$value';
}

class Left extends DoubleOption {
  Left(super.value, {super.unit = ''});

  @override
  String toRaw() => 'left=$vu';
}

class Shift extends StyleOption {
  Shift(this.xy);
  final XY xy;

  @override
  String toRaw() => 'shift={$xy}';
}

class LineCap extends StringOption {
  LineCap.round() : super('round');
  LineCap.butt() : super('butt');

  @override
  String toRaw() => 'line cap=$value';
}

class Corners extends StringOption {
  Corners.round() : super('rounded');

  @override
  String toRaw() => '$value corners';
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
  String toRaw() => '$name${percent == null ? '' : '!$percent'}';
}

class MixedColor extends Color {
  MixedColor(this.colors);
  final List<SingleColor> colors;
  MixedColor operator +(SingleColor other) => MixedColor([...colors, other]);

  @override
  String toRaw() => colors.join('!');
}

class CustomColor extends Color {
  CustomColor(TikzPicture picture, this.name, this.color) {
    picture.addRaw(definition);
  }
  final String name;
  final Color color;

  @override
  String get definition => '\\colorlet{$name}{$color}';

  @override
  String toRaw() => name;
}

class Fill extends StyleOption {
  Fill(this.color);
  final Color color;

  @override
  String toRaw() => 'fill=$color';
}

class Draw extends StyleOption {
  Draw(this.color);
  final Color color;

  @override
  String toRaw() => 'draw=$color';
}

class InnerSep extends StyleOption {
  InnerSep(this.sep, {this.unit = ''});
  final double sep;
  final String unit;

  @override
  String toRaw() => 'inner sep=$sep$unit';
}

class CustomStyle extends StyleOption {
  CustomStyle(TikzPicture picture, this.name, this.options) {
    picture.addStyle(this);
  }
  final String name;
  final List<StyleOption> options;

  @override
  String get definition => '$name/.style={${options.join(', ')}}';

  @override
  String toRaw() => name;
}
