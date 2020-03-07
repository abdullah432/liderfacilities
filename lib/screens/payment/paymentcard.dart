enum CardType {
  MasterCard,
  Visa,
  Verve,
  Others, // Any other card issuer
  Invalid // We'll use this when the card is invalid
}

class PaymentCard {
  CardType type;
  String number;
  String name;
  int month;
  int year;
  int cvv;

  PaymentCard(
      {this.type, this.number, this.name, this.month, this.year, this.cvv});
}