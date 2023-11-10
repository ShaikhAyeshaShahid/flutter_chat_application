class chat_user {
  String? image;
  String? name;
  String? about;
  String? createdAt;
  bool? isOnline;
  String? id;
  String? lastActive;
  String? email;
  String? pushToken;

  chat_user(
      {required this.image,
      required this.name,
      required this.about,
      required this.createdAt,
      required this.isOnline,
      required this.id,
      required this.lastActive,
      required this.email,
      required this.pushToken});

  chat_user.fromJson(Map<String, dynamic> json) {
    image = json['image'] ?? " ";
    name = json['name'] ?? " ";
    about = json['about'] ?? " ";
    createdAt = json['created_at'] ?? " ";
    isOnline = json['is_online'] ?? " ";
    id = json['id'] ?? " ";
    lastActive = json['last_active'] ?? " ";
    email = json['email'] ?? " ";
    pushToken = json['push_token'] ?? " ";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['name'] = this.name;
    data['about'] = this.about;
    data['created_at'] = this.createdAt;
    data['is_online'] = this.isOnline;
    data['id'] = this.id;
    data['last_active'] = this.lastActive;
    data['email'] = this.email;
    data['push_token'] = this.pushToken;
    return data;
  }
}
