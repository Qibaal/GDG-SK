String getImageAssetByTitle(String title) {
  // print(title);
  switch (title.toLowerCase()) {
    // case 'the phoenix hotel':
    //   return 'assets/phoenix.jpg';
    // case 'melia purosani yogyakarta':
    //   return 'assets/melia.jpg';
    // case 'borobudur temple':
    //   return 'assets/borobudur.jpg';
    // case 'prambanan temple':
    //   return 'assets/prambanan.jpg';
    // case 'gudeg yu djum':
    //   return 'assets/gudeg.jpg';
    // case 'sate klathak pak pong':
    //   return 'assets/sateklathak.jpg';
    // case 'angkringan lik man':
    //   return 'assets/angkringan.jpg';
    // case 'grand aston yogyakarta':
    //   return 'assets/aston.jpg';

    // // Previously defined cases
    case 'four seasons resort bali at sayan':
      return 'assets/fourseasons.jpg';
    case 'the ritz-carlton, bali':
      return 'assets/ritzcarlton.jpg';
    case 'mulia resort & villas nusa dua':
      return 'assets/muliaresort.jpg';
    case 'nasi ayam kedewatan ibu mangku':
      return 'assets/kedewatan.jpg';
    case 'warung babi guling ibu oka 3':
      return 'assets/ibuoka.jpg';
    case 'locavore':
      return 'assets/locavore.jpg';
    case 'tanah lot temple':
      return 'assets/tanahlot.jpeg';
    case 'ubud monkey forest':
      return 'assets/ubuhmonkey.jpg';
    case 'tegallalang rice terraces':
      return 'assets/tegallalang.jpg';

    default:
      return 'assets/city.jpg';
  }
}
