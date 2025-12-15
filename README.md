# SQL Araç Seti (Genel / Çoklu Şirket)

Bu repo; **2 farklı şirket/veritabanı** için kullanılabilen ama **hiçbir şirket adı / veritabanı adı / özel kod** içermeyen,
tamamen **placeholder** tabanlı SQL sorgularını içerir.

Amaç:
- **Ana Veriler:** Stok/Cari kalite kontrolleri (kod doluluk, hiyerarşi, hareket var mı)
- **Satış/Alış:** Detay raporlar (kur çevirimli)
- **Stok:** Seri/Lot bazlı anlık stok ve envanter çıktıları
- **Finans:** Gelir tablosu, bilanço, aylık net kâr

✅ Güvenli paylaşım: Dosyalarda şirket ismi yoktur. Sadece `{{...}}` placeholder vardır.

---

## Hızlı Başlangıç

1) Repo’yu klonla
2) `sql/00_konfigurasyon/00_placeholderlar.md` içindeki placeholder’ları kendi ortamına göre belirle
3) `.sql` dosyalarında Replace/Find ile değiştir
4) SQL Server üzerinde çalıştır

Örnek:
- `{{VT_A}}` → `COMPANYA2025`
- `{{VT_B}}` → `COMPANYB2025`
- `{{SIRKET_A}}` → `SIRKET_A`
- `{{SIRKET_B}}` → `SIRKET_B`
- `{{YIL}}` → `2025`
- `{{TARIH_BAS}}` → `'2025-01-01'`
- `{{TARIH_BIT}}` → `'2025-12-31'`
- `{{KUR_TABLOSU}}` → `dbo.KUR_TABLO`

---

## Kategoriler

### 01_ana_veriler
- Stok kartları: Alış/Satış hareketi var mı + Grup/Kod doluluk
- Hareketi olan cariler listesi
- Cari üst kod eşlemesi
- Stok grup–kod hiyerarşisi

### 02_stok
- Stok kartı + envanter (onhand) + opsiyonel görsel yolu
- Döviz tipine göre toplam stok maliyeti
- Seri/Lot bazlı anlık stok

### 03_satis_alis
- Satış detay (kur çevirimli) – çoklu veritabanı
- Alış + tedarikçi iade (kur çevirimli) – çoklu veritabanı

### 04_finans
- Gelir tablosu özet
- Bilanço özet
- Aylık gelir/gider/net kâr
- Bilanço hesap detay

---

## Notlar
- TR karakter düzeltme için bazı alanlarda `REPLACE(REPLACE(...))` kullanılmıştır.
- `{{KUR_TABLOSU}}` tablosu/view beklenen kolonlar:
  - `TARIH`
  - `ISIM` (örn: USD / EUR gibi)
  - `DOV_SATIS` (kur)
- Görsel tablon yoksa `05_stok_karti_envanter_gorsel.sql` içindeki görsel join’lerini silebilirsin.
