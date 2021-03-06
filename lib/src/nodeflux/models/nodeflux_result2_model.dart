import 'nodeflux_face_liveness_model.dart';
import 'nodeflux_face_match_model.dart';

class NodefluxResult2Model {
  final NodefluxFaceLivenessModel? face_liveness;
  final NodefluxFaceMatchModel? face_match;
  late final String? nik;
  final String? nama;
  final String? agama;
  final String? rt_rw;
  final String? alamat;
  final String? provinsi;
  final String? kecamatan;
  final String? pekerjaan;
  final String? tempat_lahir;
  final String? jenis_kelamin;
  final String? tanggal_lahir;
  final String? berlaku_hingga;
  final String? golongan_darah;
  final String? kabupaten_kota;
  final String? kelurahan_desa;
  final String? kewarganegaraan;
  final String? status_perkawinan;

  NodefluxResult2Model({
    this.nik,
    this.nama,
    this.agama,
    this.rt_rw,
    this.alamat,
    this.provinsi,
    this.kecamatan,
    this.pekerjaan,
    this.tempat_lahir,
    this.jenis_kelamin,
    this.tanggal_lahir,
    this.berlaku_hingga,
    this.golongan_darah,
    this.kabupaten_kota,
    this.kelurahan_desa,
    this.kewarganegaraan,
    this.status_perkawinan,
    this.face_liveness,
    this.face_match,
  });

  factory NodefluxResult2Model.fromJson(Map<String, dynamic> json) => NodefluxResult2Model(
    nik: json['nik'],
    nama: json["nama"],
    agama: json["agama"],
    rt_rw: json["rt_rw"],
    alamat: json["alamat"],
    provinsi: json["provinsi"],
    kecamatan: json["kecamatan"],
    pekerjaan: json["pekerjaan"],
    tempat_lahir: json["tempat_lahir"],
    jenis_kelamin: json["jenis_kelamin"],
    tanggal_lahir: json["tanggal_lahir"],
    berlaku_hingga: json["berlaku_hingga"],
    golongan_darah: json["golongan_darah"],
    kabupaten_kota: json["kabupaten_kota"],
    kelurahan_desa: json["kelurahan_desa"],
    kewarganegaraan: json["kewarganegaraan"],
    status_perkawinan: json["status_perkawinan"],
  );

  Map<String, dynamic> toJson() => {
    "nik": nik,
    "nama": nama,
    "agama": agama,
    "rt_rw": rt_rw,
    "alamat": alamat,
    "provinsi": provinsi,
    "kecamatan": kecamatan,
    "pekerjaan": pekerjaan,
    "tempat_lahir": tempat_lahir,
    "jenis_kelamin": jenis_kelamin,
    "tanggal_lahir": tanggal_lahir,
    "berlaku_hingga": berlaku_hingga,
    "golongan_darah": golongan_darah,
    "kabupaten_kota": kabupaten_kota,
    "kelurahan_desa": kelurahan_desa,
    "kewarganegaraan": kewarganegaraan,
    "status_perkawinan": status_perkawinan,
  };

  factory NodefluxResult2Model.fromJsonForMatchLiveness(Map<String, dynamic> json) => NodefluxResult2Model(
  //face_liveness: List<NodefluxFaceLivenessModel>.from(json["face_liveness"].map((x) => NodefluxFaceLivenessModel.fromJson(x))), // jalan
  //face_match:List<NodefluxFaceMatchModel>.from(json["face_match"].map((x) => NodefluxFaceMatchModel.fromJson(x))),
  face_liveness: NodefluxFaceLivenessModel.fromJson(json["face_liveness"]),
  face_match: NodefluxFaceMatchModel.fromJson(json["face_match"]),
  );

  Map<String, dynamic> toJsonForMatchLiveness() => {
    "face_liveness": face_liveness?.toJson(),
    "face_match": face_match?.toJson(),
    //"face_match": List<dynamic>.from(face_match.map((x) => x.toJson())), // jalan (tp gak jalan kalo kosong)
  };

  factory NodefluxResult2Model.fromJsonForLiveness(Map<String, dynamic> json) => NodefluxResult2Model(
  face_liveness: NodefluxFaceLivenessModel.fromJson(json["face_liveness"]),
  );

  Map<String, dynamic> toJsonForLiveness() => {
    "face_liveness": face_liveness?.toJson(),
  };
}