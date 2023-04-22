import 'dart:math';

class PerlinNoiseGenerator {
  final int seed;
  final double frequency;

  PerlinNoiseGenerator({this.seed = 0, this.frequency = 1.0});

  double noise(double x, double y) {
    // Scale the coordinates by the frequency
    x *= frequency;
    y *= frequency;

    // Determine grid cell coordinates
    int x0 = x.floor();
    int x1 = x0 + 1;
    int y0 = y.floor();
    int y1 = y0 + 1;

    // Determine interpolation weights
    double sx = x - x0;
    double sy = y - y0;

    // Calculate dot products
    double n0 = _dotGridGradient(x0, y0, x, y);
    double n1 = _dotGridGradient(x1, y0, x, y);
    double ix0 = _lerp(n0, n1, sx);

    n0 = _dotGridGradient(x0, y1, x, y);
    n1 = _dotGridGradient(x1, y1, x, y);
    double ix1 = _lerp(n0, n1, sx);

    return _lerp(ix0, ix1, sy);
  }

  double _dotGridGradient(int ix, int iy, double x, double y) {
    // Generate a random gradient vector
    Random random = Random(seed ^ (iy * 12731 + ix * 46817) & 0xffffffff);
    List<double> gradient = [_randomBetween(random, -1.0, 1.0), _randomBetween(random, -1.0, 1.0)];

    // Compute the distance vector
    double dx = x - ix;
    double dy = y - iy;

    // Compute the dot-product
    return (dx * gradient[0] + dy * gradient[1]);
  }

  double _lerp(double a0, double a1, double w) {
    return (1.0 - w) * a0 + w * a1;
  }

  double _randomBetween(Random random, double min, double max) {
    return min + random.nextDouble() * (max - min);
  }
}