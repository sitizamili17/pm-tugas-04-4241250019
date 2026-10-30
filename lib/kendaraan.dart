/// Kerangka semua kendaraan. Tidak bisa dibuat objeknya langsung.
abstract class Kendaraan {
  final String plat;
  final DateTime waktuMasuk;

  Kendaraan(this.plat, this.waktuMasuk);

  /// Wajib diisi subclass.
  String get jenis;
  int get tarifPerJam;

  /// Biaya = jumlah jam (dibulatkan ke atas, minimal 1 jam) x tarif per jam.
  int biaya(DateTime keluar) {
    final menit = keluar.difference(waktuMasuk).inMinutes;
    var jam = (menit / 60).ceil();
    if (jam < 1) jam = 1;
    return jam * tarifPerJam;
  }
}

class Motor extends Kendaraan {
  Motor(super.plat, super.waktuMasuk);

  @override
  String get jenis => 'Motor';

  @override
  int get tarifPerJam => 2000;
}

class Mobil extends Kendaraan {
  Mobil(super.plat, super.waktuMasuk);

  @override
  String get jenis => 'Mobil';

  @override
  int get tarifPerJam => 5000;
}

class Truk extends Kendaraan {
  Truk(super.plat, super.waktuMasuk);

  @override
  String get jenis => 'Truk';

  @override
  int get tarifPerJam => 10000;
}

/// Mixin: kemampuan tambahan berupa diskon 50% untuk member.
mixin Berlangganan on Kendaraan {
  @override
  int biaya(DateTime keluar) => super.biaya(keluar) ~/ 2;
}

/// Mobil milik member: mewarisi Mobil, lalu mencampurkan Berlangganan.
class MobilMember extends Mobil with Berlangganan {
  MobilMember(super.plat, super.waktuMasuk);

  @override
  String get jenis => 'Mobil (member)';
}
