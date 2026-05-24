import 'package:equatable/equatable.dart';

class News  {
  String id;
   String guid;
   String imageurl;
   String title;
   String url;
   String source;
  String body;


  News(this.id, this.guid, this.imageurl, this.title, this.url, this.source,
      this.body);


  News.fromMap(Map map)
      : id = map['id'],
        guid = map['guid'],
        imageurl = map['imageurl'],
        title = map['title'],
        url = map['url'],
        source = map['source'],
        body = map['body'];
}
