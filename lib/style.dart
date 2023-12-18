import 'package:tikd/base.dart';

abstract class StyleOption extends RawElement {}

abstract class StringOption extends StyleOption {
  StringOption(this.value);
  final String value;
}

class Thickness extends StringOption {
  Thickness.veryThick() : super('very thick');
  Thickness.veryThin() : super('very thin');

  @override
  String toRaw() => value;
}

class Scale extends StyleOption {
  Scale(this.scale);
  final double scale;

  @override
  String toRaw() => 'scale=$scale';
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

abstract class Color extends StyleOption {}

class ColorName extends StringOption {
  ColorName.red() : super('red');
  ColorName.green() : super('green');
  ColorName.blue() : super('blue');
  ColorName.orange() : super('orange');
  ColorName.black() : super('black');

  Color get color => SingleColor(this);
  Color percent(int p) => SingleColor(this, percent: p);

  @override
  String toRaw() => value;
}

class SingleColor extends Color {
  SingleColor(this.name, {this.percent});
  final ColorName name;
  final int? percent;

  @override
  String toRaw() => '$name${percent == null ? '' : '!$percent'}';
}

class MixedColor extends Color {
  MixedColor(this.colors);
  final List<SingleColor> colors;

  @override
  String toRaw() => colors.join('!');
}

class Fill extends StyleOption {
  Fill(this.color);
  final Color color;

  @override
  String toRaw() => 'fill=$color';
}

class InnerSep extends StyleOption {
  InnerSep(this.sep, {this.unit = ''});
  final double sep;
  final String unit;

  @override
  String toRaw() => 'inner sep=$sep$unit';
}

class Style implements RawElement {
  Style(this.name, this.options);
  final String name;
  final List<StyleOption> options;

  @override
  String toRaw() => '$name/.style={${options.join(', ')}}';
}
