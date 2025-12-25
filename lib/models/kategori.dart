class Kategori {
  final int? id;
  final String namaKategori;
  final String? deskripsi; // Changed to nullable

  const Kategori({ // Added const for optimization
    this.id,
    required this.namaKategori,
    this.deskripsi,
  });

  // 1. CopyWith: Essential for editing immutable objects
  Kategori copyWith({
    int? id,
    String? namaKategori,
    String? deskripsi,
  }) {
    return Kategori(
      id: id ?? this.id,
      namaKategori: namaKategori ?? this.namaKategori,
      deskripsi: deskripsi ?? this.deskripsi,
    );
  }

  // 2. FromMap: Added safety check
  factory Kategori.fromMap(Map<String, dynamic> map) {
    return Kategori(
      id: map['id'] as int?,
      namaKategori: map['nama_kategori'] as String,
      // Handle potential nulls from DB gracefully
      deskripsi: map['deskripsi'] as String?, 
    );
  }

  // 3. ToMap
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama_kategori': namaKategori,
      'deskripsi': deskripsi,
    };
  }

  // 4. toString: Makes debugging much easier
  @override
  String toString() {
    return 'Kategori(id: $id, nama: $namaKategori, desc: $deskripsi)';
  }
}