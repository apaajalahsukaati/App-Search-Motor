class Motor {
  final String merek;
  final String model;
  final String tahunProduksi;
  final String warna;
  final String harga;
  final String stok;
  final String gambar;

  Motor({
    required this.merek,
    required this.model,
    required this.tahunProduksi,
    required this.warna,
    required this.harga,
    required this.stok,
    required this.gambar,
  });


  factory Motor.fromJson(Map<String, dynamic> json) {
    return Motor(
      merek: json['Merek'].toString(),
      model: json['Model'].toString(),
      tahunProduksi: json['TahunProduksi'].toString(),
      warna: json['Warna'].toString(),
      harga: json['Harga'].toString(),
      stok: json['Stok'].toString(),
      gambar: json['gambar'].toString(),
    );
  }
}