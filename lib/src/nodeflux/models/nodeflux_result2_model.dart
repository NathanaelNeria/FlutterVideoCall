import 'package:json_annotation/json_annotation.dart';

class NodefluxResult2Model {
  @JsonKey(defaultValue: null)
  @JsonKey(required: false)
  String nik;

  @JsonKey(defaultValue: null)
  @JsonKey(required: false)
  String nama;

  @JsonKey(defaultValue: null)
  @JsonKey(required: false)
  String agama;

  @JsonKey(defaultValue: null)
  @JsonKey(required: false)
  String rt_rw;

  @JsonKey(defaultValue: null)
  @JsonKey(required: false)
  String alamat;

  @JsonKey(defaultValue: null)
  @JsonKey(required: false)
  String provinsi;

  @JsonKey(defaultValue: null)
  @JsonKey(required: false)
  String kecamatan;

  @JsonKey(defaultValue: null)
  @JsonKey(required: false)
  String pekerjaan;

  @JsonKey(defaultValue: null)
  @JsonKey(required: false)
  String tempat_lahir;

  @JsonKey(defaultValue: null)
  @JsonKey(required: false)
  String jenis_kelamin;

  @JsonKey(defaultValue: null)
  @JsonKey(required: false)
  String tanggal_lahir;

  @JsonKey(defaultValue: null)
  @JsonKey(required: false)
  String berlaku_hingga;

  @JsonKey(defaultValue: null)
  @JsonKey(required: false)
  String golongan_darah;

  @JsonKey(defaultValue: null)
  @JsonKey(required: false)
  String kabupaten_kota;

  @JsonKey(defaultValue: null)
  @JsonKey(required: false)
  String kelurahan_desa;

  @JsonKey(defaultValue: null)
  @JsonKey(required: false)
  String kewarganegaraan;

  @JsonKey(defaultValue: null)
  @JsonKey(required: false)
  String status_perkawinan;

  NodefluxResult2Model({
    required this.nik,
    required this.nama,
    required this.agama,
    required this.rt_rw,
    required this.alamat,
    required this.provinsi,
    required this.kecamatan,
    required this.pekerjaan,
    required this.tempat_lahir,
    required this.jenis_kelamin,
    required this.tanggal_lahir,
    required this.berlaku_hingga,
    required this.golongan_darah,
    required this.kabupaten_kota,
    required this.kelurahan_desa,
    required this.kewarganegaraan,
    required this.status_perkawinan,
  });

  factory NodefluxResult2Model.fromJson(Map<String, dynamic> json) =>
      NodefluxResult2Model(
        nik: json["nik"],
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

  Map<String, dynamic> toJson() =>
      {
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
}