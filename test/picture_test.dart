import 'package:test/test.dart';
import 'package:tikd/base.dart';
import 'package:tikd/geometry.dart';
import 'package:tikd/picture.dart';
import 'package:tikd/style.dart';
import 'package:tikd/wrapper.dart';

void main() {
  test('Circle handles empty units', () {
    expect(Circle(center: xy(0, 0), radius: 1).toRaw(),
        equals('(0.0, 0.0) circle [radius=1.0] '));
  });

  test('Circle handles pt units', () {
    expect(Circle(center: xy(0, 0), radius: 1, unit: 'pt').toRaw(),
        equals('(0.0pt, 0.0pt) circle [radius=1.0pt] '));
  });

  test('Karl\'s example works', () async {
    final picture = TikzPicture(options: [Scale(3), LineCap.round()]);

    final axesStyle = CustomStyle(picture, 'axes', []);
    final importantLineStyle = CustomStyle(
      picture,
      'important line',
      [Thickness.veryThick()],
    );
    final informationTextStyle = CustomStyle(
      picture,
      'information text',
      [Corners.round(), Fill(Color.red % 10), InnerSep(1, unit: 'ex')],
    );

    final darkGreen = Color.green % 50 + Color.black;
    final darkOrange = Color.orange % 80 + Color.black;
    final angleColor = CustomColor(picture, 'anglecolor', darkGreen);
    final sinColor = CustomColor(picture, 'sincolor', Color.red);
    final tanColor = CustomColor(picture, 'tancolor', darkOrange);
    final cosColor = CustomColor(picture, 'coscolor', Color.blue);

    final grid = Grid(xy(-1.4, -1.4), xy(1.4, 1.4), step: 0.5);
    picture.draw(grid, options: [helpLinesStyle]);

    picture.draw(Circle(center: xy(0, 0), radius: 1));

    final xAxis = Lines([xy(-1.5, 0), xy(1.5, 0)])
      ..node = Node(place: Placement.right, content: r'$x$')
      ..coordinate = Coordinate('x axis');
    final yAxis = Lines([xy(0, -1.5), xy(0, 1.5)])
      ..node = Node(place: Placement.above, content: r'$y$')
      ..coordinate = Coordinate('y axis');
    final axesScope = Scope(options: [axesStyle])
      ..draw(xAxis, options: [singleArrowStyle])
      ..draw(yAxis, options: [singleArrowStyle]);
    picture.addScope(axesScope);
    for (final x in <double>[-1, -.5, 1]) {
      final tick = Lines([xy(0, 1), xy(0, -1)], unit: 'pt')
        ..node = Node(
            place: Placement.below,
            options: [Fill(Color.white)],
            content: '\$$x\$');
      axesScope.draw(tick, options: [Shift(xy(x, 0), unit: 'cm')]);
    }
    for (final y in <double>[-1, -.5, .5, 1]) {
      final tick = Lines([xy(1, 0), xy(-1, 0)], unit: 'pt')
        ..node = Node(
            place: Placement.left,
            options: [Fill(Color.white)],
            content: '\$$y\$');
      axesScope.draw(tick, options: [Shift(xy(0, y), unit: 'cm')]);
    }
    // Uncomment to update the expected lines.
    // print(picture.buildLines().join('\n'));

    // Uncomment to generate the SVG.
    // await LatexWrapper.fromPicture(picture).makeSvg('/tmp/picture_test.svg');

    expect(picture.buildLines().join('\n'), equals(r'''
[
  scale=3.0,
  line cap=round,
  axes/.style={},
  important line/.style={very thick},
  information text/.style={rounded corners, fill=red!10, inner sep=1.0ex},
]
\colorlet{anglecolor}{green!50!black}
\colorlet{sincolor}{red}
\colorlet{tancolor}{orange!80!black}
\colorlet{coscolor}{blue}
\draw[help lines] (-1.4, -1.4) grid [step=0.5] (1.4, 1.4) ;
\draw (0.0, 0.0) circle [radius=1.0] ;
\begin{scope}
  [
    axes,
  ]
  \draw[->] (-1.5, 0.0) -- (1.5, 0.0) node[right] {$x$};
  \draw[->] (0.0, -1.5) -- (0.0, 1.5) node[above] {$y$};
  \draw[shift={(-1.0cm, 0.0cm)}] (0.0pt, 1.0pt) -- (0.0pt, -1.0pt) node[below, fill=white] {$-1.0$};
  \draw[shift={(-0.5cm, 0.0cm)}] (0.0pt, 1.0pt) -- (0.0pt, -1.0pt) node[below, fill=white] {$-0.5$};
  \draw[shift={(1.0cm, 0.0cm)}] (0.0pt, 1.0pt) -- (0.0pt, -1.0pt) node[below, fill=white] {$1.0$};
  \draw[shift={(0.0cm, -1.0cm)}] (1.0pt, 0.0pt) -- (-1.0pt, 0.0pt) node[left, fill=white] {$-1.0$};
  \draw[shift={(0.0cm, -0.5cm)}] (1.0pt, 0.0pt) -- (-1.0pt, 0.0pt) node[left, fill=white] {$-0.5$};
  \draw[shift={(0.0cm, 0.5cm)}] (1.0pt, 0.0pt) -- (-1.0pt, 0.0pt) node[left, fill=white] {$0.5$};
  \draw[shift={(0.0cm, 1.0cm)}] (1.0pt, 0.0pt) -- (-1.0pt, 0.0pt) node[left, fill=white] {$1.0$};
\end{scope}'''));
  });
}
