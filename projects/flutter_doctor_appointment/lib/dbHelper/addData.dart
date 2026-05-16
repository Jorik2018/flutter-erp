import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_turtle_v2/dbHelper/searchData.dart';
import 'package:fast_turtle_v2/models/activeAppointmentModel.dart';
import 'package:fast_turtle_v2/models/passiveAppoModel.dart';
import 'package:fast_turtle_v2/models/sectionModel.dart';
import 'package:fast_turtle_v2/models/userModel.dart';
import 'package:fast_turtle_v2/models/doktorModel.dart';
import 'package:fast_turtle_v2/models/adminModel.dart';
import 'package:fast_turtle_v2/models/hospitalModel.dart';

class AddService {
  String saveUser(User user) {
    FirebaseFirestore.instance.collection('tblKullanici').doc().set({
      'ad': user.adi,
      'soyad': user.soyadi,
      'kimlikNo': user.kimlikNo,
      'cinsiyet': user.cinsiyet,
      'dogumTarihi': user.dogumTarihi,
      'dogumYeri': user.dogumYeri,
      'sifre': user.sifre
    });
    return 'kullanıcı ekleme işlemi Tamamlandı';
  }

  void saveDoctor(Doktor dr, Section bolumu, Hospital hastanesi) {
    var randevular = [];
    FirebaseFirestore.instance.collection('tblDoktor').doc().set({
      'kimlikNo': dr.kimlikNo,
      'ad': dr.adi,
      'soyad': dr.soyadi,
      'sifre': dr.sifre,
      'bolumId': bolumu.bolumId,
      'hastaneId': hastanesi.hastaneId,
      'cinsiyet': dr.cinsiyet,
      'dogumTarihi': dr.dogumTarihi,
      'dogumYeri': dr.dogumYeri,
      'favoriSayaci' : 0,
      'randevular' : randevular
    });
  }

  void addActiveAppointment(Doktor dr, User user, String tarih) {
    FirebaseFirestore.instance.collection('tblAktifRandevu').doc().set({
      'doktorTCKN': dr.kimlikNo,
      'hastaTCKN': user.kimlikNo,
      'randevuTarihi': tarih,
      'doktorAdi': dr.adi,
      'doktorSoyadi': dr.soyadi,
      'hastaAdi': user.adi,
      'hastaSoyadi': user.soyadi
    });
  }

  void addDoctorToUserFavList(PassAppointment rand) {
    FirebaseFirestore.instance.collection('tblFavoriler').doc().set({
      'doktorTCKN': rand.doktorTCKN,
      'hastaTCKN': rand.hastaTCKN,
      'doktorAdi': rand.doktorAdi,
      'doktorSoyadi': rand.doktorSoyadi,
      'hastaAdi': rand.hastaAdi,
      'hastaSoyadi': rand.hastaSoyadi
    });
  }

  void addPastAppointment(ActiveAppointment randevu) {
    FirebaseFirestore.instance.collection('tblRandevuGecmisi').doc().set({
      'doktorTCKN': randevu.doktorTCKN,
      'hastaTCKN': randevu.hastaTCKN,
      'islemTarihi': randevu.randevuTarihi,
      'doktorAdi': randevu.doktorAdi,
      'doktorSoyadi': randevu.doktorSoyadi,
      'hastaAdi': randevu.hastaAdi,
      'hastaSoyadi': randevu.hastaSoyadi
    });
  }

  addDoctorAppointment(Doktor doktor) {
    FirebaseFirestore.instance
        .collection("tblDoktor")
        .doc(doktor.reference!.id)
        .set({'randevular': doktor.randevular}, SetOptions(merge: true));
  }

  closeDoctorAppointment(Admin admin) {
    FirebaseFirestore.instance
        .collection("tblAdmin")
        .doc(admin.reference!.id)
        .set({'kapatilanSaatler': admin.kapatilanSaatler}, SetOptions(merge: true));
  }

  String saveAdmin(Admin admin) {
    FirebaseFirestore.instance.collection("tblAdmin").doc().set({
      'Id': admin.id,
      'nicname': admin.nickname,
      'password': admin.password
    });
    return 'Admin ekleme işlem tamamlandı';
  }

  String saveHospital(Hospital hastane) {
    SearchService().getLastHospitalId().then((QuerySnapshot docs) {
      FirebaseFirestore.instance.collection("tblHastane").doc().set({
        'hastaneAdi': hastane.hastaneAdi,
        'hastaneId': docs.docs[0]['hastaneId'] + 1,
      });
    });

    return 'Hastane kaydı tamamlandı';
  }

  String saveSection(Section bolum, Hospital hastane) {
    SearchService().getLastSectionId().then((QuerySnapshot docs) {
      FirebaseFirestore.instance.collection("tblBolum").doc().set({
        "bolumAdi": bolum.bolumAdi,
        "bolumId": docs.docs[0]["bolumId"] + 1,
        "hastaneId": hastane.hastaneId
      });
    });
    return "Bölüm ekleme tamamlandı";
  }
}
