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
### 📂 SQL Araç Seti Yapısı

- **00_konfigurasyon**
  - Placeholder ve parametreleme mantığı

- **01_ana_veriler**
  - Stok, cari ve kod hiyerarşisi kontrolleri

- **02_stok**
  - Envanter, stok bakiye, maliyet, seri/lot izleme

- **03_satis_alis**
  - Satış, iade, alış ve cari bakiye analizleri

- **04_finans**
  - Gelir tablosu, bilanço, banka, çek/senet ve dekont bazlı raporlar
sql/
├─ 00_konfigurasyon/
│  └─ 00_placeholderlar.md
│
├─ 01_ana_veriler/
│  ├─ 01_stok_kart_hareket_kod_doluluk.sql
│  ├─ 02_hareketi_olan_cariler.sql
│  ├─ 03_cari_ust_kod_esleme.sql
│  └─ 04_stok_grup_kod_hiyerarsisi.sql
│
├─ 02_stok/
│  ├─ 01_stok_karti_envanter_gorsel.sql
│  ├─ 02_stok_bakiye_son_giris_nf_satis_fiyat.sql
│  ├─ 03_toplam_stok_maliyeti_doviz_bazli.sql
│  ├─ 04_seri_lot_bazli_anlik_stok.sql
│  ├─ 05_seri_hangi_cariye_hangi_belge.sql
│  └─ 06_seri_fiyat_doviz_bilgisi.sql
│
├─ 03_satis_alis/
│  ├─ 01_satis_ve_satis_iade_detay_doviz_cevrimli.sql
│  ├─ 02_alis_ve_tedarikci_iade_doviz_cevrimli.sql
│  ├─ 03_musteri_borc_alacak_bakiye.sql
│  └─ 04_satici_borc_alacak_bakiye.sql
│
├─ 04_finans/
│  ├─ 01_gelir_tablosu_ozet.sql
│  ├─ 02_bilanco_ozet.sql
│  ├─ 03_aylik_gelir_gider_net_kar.sql
│  ├─ 04_bilanco_hesap_detay.sql
│  ├─ 05_banka_borc_alacak_bakiye.sql
│  ├─ 06_faturasiz_gelir_gider_dekontlar.sql
│  ├─ 07_musteri_cekleri_portfoy.sql
│  ├─ 08_musteri_cekleri_tahsilde.sql
│  ├─ 09_borc_cekleri_bekleyen.sql
│  ├─ 10_musteri_cekleri_teminat.sql
│  ├─ 11_musteri_cekleri_ciro_edilen.sql
│  ├─ 12_musteri_cekleri_iade_iptal.sql
│  ├─ 13_borc_cekleri_odenmis.sql
│  ├─ 14_borc_cekleri_vadesi_gecen.sql
│  └─ 15_borc_cekleri_iade_iptal.sql
│
├─ .gitignore
└─ README.md


---

## Notlar
- TR karakter düzeltme için bazı alanlarda `REPLACE(REPLACE(...))` kullanılmıştır.
- `{{KUR_TABLOSU}}` tablosu/view beklenen kolonlar:
  - `TARIH`
  - `ISIM` (örn: USD / EUR gibi)
  - `DOV_SATIS` (kur)
- Görsel tablon yoksa `05_stok_karti_envanter_gorsel.sql` içindeki görsel join’lerini silebilirsin.
