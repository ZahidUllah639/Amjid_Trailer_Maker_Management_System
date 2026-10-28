/// Utility for formatting WhatsApp numbers
String formatWhatsAppNumber(String number) {
  // Remove all spaces and symbols
  String cleaned = number.replaceAll(RegExp(r'\D'), '');
  
  // If starts with 0 → convert to 92
  if (cleaned.startsWith('0')) {
    cleaned = '92${cleaned.substring(1)}';
  } 
  // If no country code and length is 10 (standard Pak mobile) → add 92
  else if (!cleaned.startsWith('92') && cleaned.length == 10) {
    cleaned = '92$cleaned';
  }
  return cleaned;
}
