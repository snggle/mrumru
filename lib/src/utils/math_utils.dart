import 'dart:math';

class MathUtils {
  /// The sinc function, often denoted as sinc(x), is a mathematical function that arises frequently in signal processing and the field of Fourier analysis.
  /// It is defined as sinc(x) = sin(x) / x, with the special case that sinc(0) = 1.
  static double sinc(double x) {
    if (x == 0) {
      return 1;
    }
    double piX = pi * x;
    return sin(piX) / piX;
  }
}
