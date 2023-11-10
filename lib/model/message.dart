class Message {
  String? toId;
  String? msg;
  String? read;
  Type? type;
  String? sent;
  String? fromId;

  Message({this.toId, this.msg, this.read, this.type, this.sent, this.fromId});

  Message.fromJson(Map<String, dynamic> json) {
    toId = json['toId'].toString();
    msg = json['msg'].toString();
    read = json['read'].toString();
    type = json['type'].toString() ==Type.image.name? Type.image: Type.text;
    sent = json['sent'].toString();
    fromId = json['fromId'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    print("message type from model ${this.type}");
    print("message type from model ${this.msg}");
    data['toId'] = this.toId;
    data['msg'] = this.msg;
    data['read'] = this.read;
   //data['type'] = this.type.toString() ==Type.image.name? Type.image: Type.text;
    data['sent'] = this.sent;
    data['fromId'] = this.fromId;
    return data;
  }
}

enum Type {text, image}

