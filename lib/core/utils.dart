
String maskIdiomInSentence(String idiom, String sentence) {
  final idiomWords = idiom.toLowerCase().split(' ');
  final sentenceTokens = sentence.split(RegExp(r'(\s+)')); // keep spaces
  int idiomIndex = 0;

  return sentenceTokens.map((token) {
    // Preserve spaces
    if (token.trim().isEmpty) return token;

    // Clean word for comparison
    final wordClean = token.replaceAll(RegExp(r'[^\w]'), '').toLowerCase();

    // Check if current token matches current idiom word
    if (idiomIndex < idiomWords.length && wordClean.contains(idiomWords[idiomIndex])) {
      idiomIndex++;
      // Mask letters, keep punctuation
      return token.split('').map((c) {
        return RegExp(r'\w').hasMatch(c) ? '_' : c;
      }).join('');
    } else {
      return token; // keep extra words as-is
    }
  }).join(' ').replaceAllMapped(
    RegExp(r'(_\s*)+'),
        (match) => '_' * match.group(0)!.replaceAll(' ', '').length,
  );
}