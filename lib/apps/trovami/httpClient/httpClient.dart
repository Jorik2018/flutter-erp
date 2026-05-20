
import 'dart:async';
import 'dart:convert';
import 'dart:io';


class HttpClientFireBase{

    late HttpClient client;

    HttpClientFireBase(){
      client=new HttpClient();
    }

  dynamic get({url}) async {
     HttpClientResponse response = await client.getUrl(Uri.parse(url))
        .then((HttpClientRequest request) {
      return request.close();
    });
     return response;

  }

  put({body,url}){
    client.putUrl(Uri.parse(url))
        .then((HttpClientRequest request) {
      // Optionally set up headers...
      // Optionally write to the request object...
      // Then call close.
      request.write(body);
      return request.close();
    }).then((HttpClientResponse response) {
      return response;
      // Process the response.
    });
  }

  post({body,url}){
    client.postUrl(Uri.parse(url))
        .then((HttpClientRequest request) {
      request.write(body);
      return request.close();
    }).then((HttpClientResponse response) {
      return response;
    });
  }
}