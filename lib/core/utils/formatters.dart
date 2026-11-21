//(VIV [Shared Formatters — 2026-10-04])

String formatHashrate(double value) {
  if (value >= 1000000000000) {
    return '${(value / 1000000000000).toStringAsFixed(2)} TH/s';
  }

  if (value >= 1000000000) {
    return '${(value / 1000000000).toStringAsFixed(2)} GH/s';
  }

  if (value >= 1000000) {
    return '${(value / 1000000).toStringAsFixed(2)} MH/s';
  }

  if (value >= 1000) {
    return '${(value / 1000).toStringAsFixed(2)} KH/s';
  }

  return '${value.toStringAsFixed(2)} H/s';
}

String formatInteger(int value) {
  return value.toString().replaceAllMapped(
    RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
    (match) => '${match.group(1)} ',
  );
}
