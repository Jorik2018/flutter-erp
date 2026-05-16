import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_turtle_v2/dbHelper/searchData.dart';
import 'package:fast_turtle_v2/models/sectionModel.dart';
import 'package:fast_turtle_v2/models/userModel.dart';
import 'package:fast_turtle_v2/models/doktorModel.dart';
import 'package:fast_turtle_v2/models/hospitalModel.dart';

class UpdateService {
  updateUser(User user) {
    FirebaseFirestore.instance
        .collection("tblKullanici")
        .doc(user.reference!.id)
        .update({
      'sifre': user.sifre.toString(),
      'ad': user.adi,
      'soyad': user.soyadi
    });
  }

  // String updateUserFavList(String kimlikNo, String doktorAdSoyad) {
  //   User temp;
  //   SearchService().searchUserById(kimlikNo).then((QuerySnapshot docs) {
  //     temp = User.fromMap(docs.docs[0].data);
  //     temp.reference = docs.docs[0].reference;
  //     if (!temp.favoriDoktorlar.contains(doktorAdSoyad)) {
  //       temp.favoriDoktorlar.add(doktorAdSoyad);

  //       FirebaseFirestore.instance
  //           .collection("tblKullanici")
  //           .doc(temp.reference.id)
  //           .update({'favoriDoktorlar': temp.favoriDoktorlar});
  //     }
  //   });

  //   return "Güncelleme gerçekleştirildi";
  // }

  String updateDoktor(Doktor doktor) {
    FirebaseFirestore.instance
        .collection("tblDoktor")
        .doc(doktor.reference!.id)
        .update({
      'ad': doktor.adi,
      'sifre': doktor.sifre.toString(),
      'soyad': doktor.soyadi
    });
    return "Güncelleme gerçekleştirildi";
  }

  String updateDoktorFavCountPlus(String doktorNo) {
    Doktor doktor;
    SearchService().searchDoctorById(doktorNo).then((QuerySnapshot docs) {
      doktor = Doktor.fromMap(docs.docs[0].data as Map<String, dynamic>);
      doktor.reference = docs.docs[0].reference;
      FirebaseFirestore.instance
          .collection("tblDoktor")
          .doc(doktor.reference!.id)
          .update({'favoriSayaci': doktor.favoriSayaci! + 1});
    });

    return "Güncelleme gerçekleştirildi";
  }

  String updateDoktorFavCountMinus(String doktorNo) {
    Doktor doktor;
    SearchService().searchDoctorById(doktorNo).then((QuerySnapshot docs) {
      doktor = Doktor.fromMap(docs.docs[0].data as Map<String, dynamic>);
      doktor.reference = docs.docs[0].reference;
      FirebaseFirestore.instance
          .collection("tblDoktor")
          .doc(doktor.reference!.id)
          .update({'favoriSayaci': doktor.favoriSayaci! - 1});
    });

    return "Güncelleme gerçekleştirildi";
  }

  String updateDoctorAppointments(String kimlikNo, String islemTarihi) {
    Doktor temp;
    SearchService().searchDoctorById(kimlikNo).then((QuerySnapshot docs) {
      temp = Doktor.fromMap(docs.docs[0].data  as Map<String, dynamic>);
      temp.reference = docs.docs[0].reference;
      if (temp.randevular.contains(islemTarihi)) {
        temp.randevular.remove(islemTarihi);

        FirebaseFirestore.instance
            .collection("tblDoktor")
            .doc(temp.reference!.id)
            .update({'randevular': temp.randevular});
      }
    });

    return "Güncelleme gerçekleştirildi";
  }

  String updateHastane(Hospital hastane) {
    FirebaseFirestore.instance
        .collection("tblHastane")
        .doc(hastane.reference!.id)
        .update({'hastaneAdi': hastane.hastaneAdi.toString()});
    return "Güncelleme gerçekleştirildi";
  }

  String updateSection(Section bolum) {
    FirebaseFirestore.instance
        .collection("tblBolum")
        .doc(bolum.reference!.id)
        .update({'bolumAdi': bolum.bolumAdi.toString()});
    return "Güncelleme gerçekleştirildi";
  }
}
