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
  static final SingleColor red = ColorName.red().color;
  static final SingleColor green = ColorName.green().color;
  static final SingleColor blue = ColorName.blue().color;
  static final SingleColor orange = ColorName.orange().color;
  static final SingleColor black = ColorName.black().color;
  static final SingleColor white = ColorName.white().color;
}

class ColorName extends StringOption {
  ColorName.red() : super('red');
  ColorName.green() : super('green');
  ColorName.blue() : super('blue');
  ColorName.orange() : super('orange');
  ColorName.black() : super('black');
  ColorName.white() : super('white');

  SingleColor get color => SingleColor(this);

  @override
  String toRaw() => value;
}

class SingleColor extends Color {
  SingleColor(this.name, {this.percent});
  final ColorName name;
  final int? percent;

  SingleColor operator %(int percent) => SingleColor(name, percent: percent);
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
  CustomColor(TikzPicture picture, this.name, Color color) {
    picture.addRaw('\\colorlet{$name}{$color}');
  }
  final String name;

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
  String get definition => '$name/.style={${options.join(', ')}}';

  @override
  String toRaw() => name;
}
