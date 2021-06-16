const List<String> kButtonsText = [
  'C',
  '( )',
  '%',
  '\u00F7',
  '7',
  '8',
  '9',
  'x',
  '4',
  '5',
  '6',
  '-',
  '1',
  '2',
  '3',
  '+',
  '00',
  '0',
  '.',
  '='
];

const Map<String, int> kOperators = {
  '+': 1,
  '-': 1,
  'x': 2,
  '\u00F7': 2,
  '%': 2,
  '(': 0,
  ')': 0
};

const int kTextAnimationSpeed = 200;
