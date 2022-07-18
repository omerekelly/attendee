// ignore: file_names
class StudDetails {
  StudDetails({
    required this.name,
    required this.address,
    required this.phone,
    required this.email,
    required this.matNo,
    required this.faculty,
    required this.image,
    required this.department,
  });
  late final String name;
  late final String address;
  late final String phone;
  late final String email;
  late final String image;
  late final String matNo;
  late final String faculty;
  late final String department;

  StudDetails.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    address = json['address'];
    phone = json['phone'];
    email = json['email'];
    matNo = json['mat_no'];
    faculty = json['faculty'];
    image = json['image'];
    department = json['department'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['address'] = address;
    data['phone'] = phone;
    data['email'] = email;
    data['mat_no'] = matNo;
    data['image'] = image;
    data['faculty'] = faculty;
    data['department'] = department;
    return data;
  }
}
