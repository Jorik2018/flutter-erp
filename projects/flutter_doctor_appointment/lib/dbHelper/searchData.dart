import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_turtle_v2/models/doktorModel.dart';
import 'package:fast_turtle_v2/models/passiveAppoModel.dart';

class SearchService {
  searchById(String gelenId, String gelenPassword, int formKey) {
    if (formKey == 0) {
      return FirebaseFirestore.instance
          .collection('tblKullanici')
          .where('kimlikNo', isEqualTo: gelenId)
          .where('sifre', isEqualTo: gelenPassword)
          .get();
    } else if (formKey == 1) {
      return FirebaseFirestore.instance
          .collection('tblDoktor')
          .where('kimlikNo', isEqualTo: gelenId)
          .where('sifre', isEqualTo: gelenPassword)
          .get();
    } else if (formKey == 2) {
      return FirebaseFirestore.instance
          .collection('tblAdmin')
          .where('nickname', isEqualTo: gelenId)
          .where('password', isEqualTo: gelenPassword)
          .get();
    }
  }

  searchByPassword(String gelenSifre, int formKey) {
    if (formKey == 0) {
      return FirebaseFirestore.instance
          .collection('tblKullanici')
          .where('sifre', isEqualTo: gelenSifre)
          .get();
    } else if (formKey == 1) {
      return FirebaseFirestore.instance
          .collection('tblDoktor')
          .where('sifre', isEqualTo: gelenSifre)
          .get();
    } else if (formKey == 2) {
      return FirebaseFirestore.instance
          .collection('tblAdmin')
          .where('sifre', isEqualTo: gelenSifre)
          .get();
    }
  }

  searchHospitalByName(String value) {
    return FirebaseFirestore.instance
        .collection("tblHastane")
        .where('hastaneAdi', isEqualTo: value)
        .get();
  }

  searchHospitalById(int value) {
    return FirebaseFirestore.instance
        .collection("tblHastane")
        .where('hastaneId', isEqualTo: value)
        .get();
  }

  searchSectionById(int value) {
    return FirebaseFirestore.instance
        .collection("tblBolum")
        .where('bolumId', isEqualTo: value)
        .get();
  }

  searchSectionsByHospitalId(int hospitalId) {
    return FirebaseFirestore.instance
        .collection("tblBolum")
        .where('hastaneId', isEqualTo: hospitalId)
        .get();
  }

  searchSectionByHospitalIdAndSectionName(int hospitalId, String sectionName) {
    return FirebaseFirestore.instance
        .collection("tblBolum")
        .where('hastaneId', isEqualTo: hospitalId)
        .where('bolumAdi', isEqualTo: sectionName)
        .get();
  }

  searchDoctorAppointment(Doktor doktor, String tarih) {
    return FirebaseFirestore.instance
        .collection("tblAktifRandevu")
        .where('doktorTCKN', isEqualTo: doktor.kimlikNo)
        .where('randevuTarihi', isEqualTo: tarih)
        .get();
  }

  searchDoctorById(String kimlikNo) {
    return FirebaseFirestore.instance
        .collection("tblDoktor")
        .where('kimlikNo', isEqualTo: kimlikNo)
        .get();
  }

  searchUserById(String kimlikNo) {
    return FirebaseFirestore.instance
        .collection("tblKullanici")
        .where('kimlikNo', isEqualTo: kimlikNo)
        .get();
  }

  getHospitals() {
    return FirebaseFirestore.instance.collection("tblHastane").get();
  }

  getSections() {
    return FirebaseFirestore.instance.collection("tblBolum").get();
  }

  getLastSectionId() {
    return FirebaseFirestore.instance
        .collection("tblBolum")
        .orderBy("bolumId", descending: true)
        .get();
  }

  getLastHospitalId() {
    return FirebaseFirestore.instance
        .collection("tblHastane")
        .orderBy("hastaneId", descending: true)
        .get();
  }

  getDoctors() {
    return FirebaseFirestore.instance.collection("tblDoktor").get();
  }

  getPastAppointments() {
    return FirebaseFirestore.instance.collection("tblRandevuGecmisi").get();
  }

  searchPastAppointmentsByHastaTCKN(String tckn) {
    return FirebaseFirestore.instance
        .collection("tblRandevuGecmisi")
        .where('hastaTCKN', isEqualTo: tckn)
        .get();
  }

  searchActiveAppointmentsByHastaTCKN(String tckn) {
    return FirebaseFirestore.instance
        .collection("tblAktifRandevu")
        .where('hastaTCKN', isEqualTo: tckn)
        .get();
  }

  searchActiveAppointmentsWithHastaTCKNAndDoctorTCKN(
      String hastaTCKN, String doktorTCKN) {
    return FirebaseFirestore.instance
        .collection("tblAktifRandevu")
        .where('hastaTCKN', isEqualTo: hastaTCKN)
        .where('doktorTCKN', isEqualTo: doktorTCKN)
        .get();
  }

  searchDocOnUserFavList(PassAppointment rand) {
    return FirebaseFirestore.instance
        .collection("tblFavoriler")
        .where('hastaTCKN', isEqualTo: rand.hastaTCKN)
        .where('doktorTCKN', isEqualTo: rand.doktorTCKN)
        .get();
  }
}
