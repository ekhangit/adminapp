class ChatMessage {
  final String message;
  final bool isSentByMe;
  final DateTime timestamp;

  ChatMessage({
    required this.message,
    required this.isSentByMe,
    required this.timestamp,
  });
}

class MessageItemModel {
  String name;
  String mostRecentMessage;
  String messageDate;
  String type;

  MessageItemModel(
    this.name,
    this.mostRecentMessage,
    this.messageDate,
    this.type,
  );
}






class MessageHelper {

  static var messageList = [
    MessageItemModel("John wick", "We had meeting tomorrow.", "10:10 PM"  , "msj"),
    MessageItemModel("Tom hardy", "Shine bright Like diamond", "10:20 PM"  , "msj"),
    MessageItemModel("Tom hardy", "Shine bright Like diamond", "10:30 PM" ,"msj" ),
    MessageItemModel("Tom hardy", "Shine bright Like diamond", "10:40 PM" ,"msj" ),
    MessageItemModel("John Alia", "https://cdn.pixabay.com/photo/2021/03/02/16/34/woman-6063087_960_720.jpg", " 10:58 AM", "image"),
    MessageItemModel("Ema watson", "https://cdn.pixabay.com/photo/2021/03/02/16/34/woman-6063087_960_720.jpg", "11:00 PM" ,  "image"),
    MessageItemModel("Tom hardy", "Shine bright Like diamond", "11:20 PM" , "msj"),
    MessageItemModel("Ronaldo", "Ronaldo is best!", "10:10 PM", "msj"),
    MessageItemModel("Tom hardy", "https://cdn.pixabay.com/photo/2017/12/01/08/02/paint-2990357_960_720.jpg", "11:30 PM" ,"image" ),
    MessageItemModel("Tom hardy", "Shine bright Like diamond", "11:40 PM" ,  "msj"),
    MessageItemModel("Tom hardy", "Shine bright Like diamond", "11:50 PM" , "msj"),
    MessageItemModel("Tom hardy", "Shine bright Like diamond", "12:00 AM" , "msj"),
    MessageItemModel("Tom hardy", "Do subscribe", "12:10 AM" , "msj"),


  ];

  static MessageItemModel getCHatList(int position) {
    return messageList[position];
  }

  static var itemCount = messageList.length;

}


class ChatItemModel {

  String name;
  String mostRecentMessage;
  String messageDate;
  String image;
  
  ChatItemModel(this.name, this.mostRecentMessage, this.messageDate , this.image);

}

class ChatHelper {

  static var chatList = [
    ChatItemModel("John wick", "We had meeting tomorrow.", "10:28 PM" , "https://cdn.pixabay.com/photo/2016/11/21/14/53/man-1845814_960_720.jpg"),
    ChatItemModel("John Alia", "Give me reminder", " 10:28 AM", "https://cdn.pixabay.com/photo/2021/03/02/16/34/woman-6063087_960_720.jpg"),
    ChatItemModel("Ema watson", "Learning flutter and node", "Yesterday" , "https://cdn.pixabay.com/photo/2017/04/05/10/45/girl-2204622_960_720.jpg" ),
    ChatItemModel("Tom hardy", "Shine bright Like diamond", "Wednesday" , "https://cdn.pixabay.com/photo/2017/12/01/08/02/paint-2990357_960_720.jpg" ),
    ChatItemModel("Ronaldo", "Ronaldo is best!", "16/01/2022", "https://cdn.pixabay.com/photo/2021/05/01/09/59/city-6220689_960_720.jpg")];

  static ChatItemModel getChatItem(int position) {
    return chatList[position];
  }

  static var itemCount = chatList.length;

}