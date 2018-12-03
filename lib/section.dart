class Sdk {
  Config config;
  List<DynamicSections> dynamicSections;

  Sdk({this.config, this.dynamicSections});

  Sdk.fromJson(Map<String, dynamic> json) {
    config =
        json['config'] != null ? new Config.fromJson(json['config']) : null;
    if (json['dynamic_sections'] != null) {
      dynamicSections = new List<DynamicSections>();
      json['dynamic_sections'].forEach((v) {
        dynamicSections.add(new DynamicSections.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.config != null) {
      data['config'] = this.config.toJson();
    }
    if (this.dynamicSections != null) {
      data['dynamic_sections'] =
          this.dynamicSections.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Config {
  String color;
  String timestamp;
  String name;
  String comment;
  String id;

  Config({this.color, this.timestamp, this.name, this.comment, this.id});

  Config.fromJson(Map<String, dynamic> json) {
    color = json['color'];
    timestamp = json['timestamp'];
    name = json['name'];
    comment = json['comment'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['color'] = this.color;
    data['timestamp'] = this.timestamp;
    data['name'] = this.name;
    data['comment'] = this.comment;
    data['id'] = this.id;
    return data;
  }
}

class DynamicSections {
  String href;
  String name;
  String backgroundColor;

  DynamicSections({this.href, this.name, this.backgroundColor});

  DynamicSections.fromJson(Map<String, dynamic> json) {
    href = json['href'];
    name = json['name'];
    backgroundColor = json['background-color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['href'] = this.href;
    data['name'] = this.name;
    data['background-color'] = this.backgroundColor;
    return data;
  }
}

class Paths {
   String status;
   String timestamp;
   var result;

  Paths({this.status, this.timestamp, this.result});

  Paths.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    timestamp = json['timestamp'];
    result = json['result'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['timestamp'] = this.timestamp;
    data['result'] = this.result;
    return data;
  }

  Paths.fromJsonMap(Map map)
      : status = map['status'],
        timestamp = map['timestamp'],
        result = map['result'];
       
}