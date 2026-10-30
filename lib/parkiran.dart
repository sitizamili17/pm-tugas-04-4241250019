import 'dart:async';

import 'kendaraan.dart';

/// Exception kustom: dilempar saat parkiran sudah penuh.
class ParkirPenuh implements Exception {
  final int kapasitas;

  ParkirPenuh(this.kapasitas);

  @override
  String toString() => 'Parkiran penuh (kapasitas $kapasitas)';
}

class Parkiran {
  final int kapasitas;

  // Privat (diawali _): tidak bisa diakses dari luar berkas ini.
  final Map<String, Kendaraan> _terparkir = {};
  int _pendapatan = 0;
  final StreamController<String> _kejadian =
      StreamController<String>.broadcast();

  Parkiran(this.kapasitas);

  int get sisa => kapasitas - _terparkir.length;
  int get pendapatan => _pendapatan;

  /// Stream kejadian untuk layar pos jaga.
  Stream<String> get kejadian => _kejadian.stream;

  /// Kendaraan masuk. Palang disimulasikan dengan Future.delayed.
  Future<void> masuk(Kendaraan k) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (_terparkir.length >= kapasitas) {
      throw ParkirPenuh(kapasitas);
    }
    _terparkir[k.plat] = k;
    _kejadian.add('MASUK ${k.jenis} ${k.plat} (sisa $sisa)');
  }

  /// Kendaraan keluar pada [waktu]. Mengembalikan biaya yang dibayar.
  Future<int> keluar(String plat, {required DateTime waktu}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final k = _terparkir.remove(plat); // Kendaraan? (null bila tidak ada)
    if (k == null) {
      throw Exception('Kendaraan $plat tidak ditemukan');
    }
    final bayar = k.biaya(waktu);
    _pendapatan += bayar;
    _kejadian.add('KELUAR ${k.jenis} ${k.plat} bayar Rp$bayar');
    return bayar;
  }

  /// Menutup stream setelah semua kejadian selesai.
  Future<void> tutup() => _kejadian.close();
}
