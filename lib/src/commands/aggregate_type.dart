enum AggregateType {
  sum('sum'),
  min('min'),
  max('max');

  final String value;

  const AggregateType(this.value);
}
