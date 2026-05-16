import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_turtle_v2/models/activeAppointmentModel.dart';
import 'package:fast_turtle_v2/models/doktorModel.dart';
import 'package:fast_turtle_v2/models/favListModel.dart';
import 'package:fast_turtle_v2/models/hospitalModel.dart';
import 'package:fast_turtle_v2/models/sectionModel.dart';

class DelService {
  ActiveAppointment activeAppointment = ActiveAppointment();

  // This method delete a doctor also her/his active appoit
  deleteDoctorbyTCKN(Doktor doktor) {
    FirebaseFirestore.instance
        .collection("tblDoktor")
        .doc(doktor.reference!.id)
        .delete();
    FirebaseFirestore.instance
        .collection("tblAktifRandevu")
        .where('doktorTCKN', isEqualTo: doktor.kimlikNo).get()
        .then((QuerySnapshot docs) {
      if (docs.docs.isNotEmpty) {
        for (var i = 0; i < docs.docs.length; i++) {
          FirebaseFirestore.instance
              .collection("tblAktifRandevu")
              .doc(docs.docs[i].reference.id)
              .delete();
        }
      }
    });
  }

  deleteActiveAppointment(ActiveAppointment randevu) {
    FirebaseFirestore.instance
        .collection('tblAktifRandevu')
        .doc(randevu.reference!.id)
        .delete();
  }

  deleteDocFromUserFavList(FavoriteList fav) {
    FirebaseFirestore.instance
        .collection('tblFavoriler')
        .doc(fav.reference!.id)
        .delete();
  }

  deleteSectionBySectionId(Section bolum, var referans) {
    FirebaseFirestore.instance
        .collection("tblBolum")
        .doc(referans.id)
        .delete();
    FirebaseFirestore.instance
        .collection("tblDoktor")
        .where('bolumId', isEqualTo: bolum.bolumId)
        .get()
        .then((QuerySnapshot docs) {
      if (docs.docs.isNotEmpty) {
        for (var i = 0; i < docs.docs.length; i++) {
          FirebaseFirestore.instance
              .collection("tblAktifRandevu")
              .where('doktorTCKN', isEqualTo: docs.docs[i]['kimlikNo']).get()
              .then((QuerySnapshot docs) {
            if (docs.docs.isNotEmpty) {
              for (var i = 0; i < docs.docs.length; i++) {
                FirebaseFirestore.instance
                    .collection("tblAktifRandevu")
                    .doc(docs.docs[i].reference.id)
                    .delete();
              }
            }
          });

          FirebaseFirestore.instance
              .collection("tblDoktor")
              .doc(docs.docs[i].reference.id)
              .delete();
        }
      }
    });
  }

  deleteHospitalById(Hospital hastane) {
    Section section = Section();
    FirebaseFirestore.instance
        .collection("tblBolum")
        .where('hastaneId', isEqualTo: hastane.hastaneId)
        .get()
        .then((QuerySnapshot docs) {
      for (var i = 0; i < docs.docs.length; i++) {
        section = Section.fromMap(docs.docs[i].data as Map<String, dynamic>);
        deleteSectionBySectionId(section, docs.docs[i].reference);
      }
    });

    FirebaseFirestore.instance
        .collection("tblHastane")
        .doc(hastane.reference!.id)
        .delete();
  }
}
