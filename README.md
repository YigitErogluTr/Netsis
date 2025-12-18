# SQL Araç Seti (Genel / Çoklu Şirket – NETSİS ERP)

Bu repo; **birden fazla şirket / veritabanı** üzerinde çalışabilecek şekilde tasarlanmış,
**hiçbir şirket adı, veritabanı adı veya firmaya özel kod içermeyen**, tamamen
**placeholder tabanlı** SQL sorgularından oluşur.

Amaç; NETSİS ERP üzerinde çalışan danışmanlar, raporlama ekipleri ve BI geliştiricileri için
**tekrar kullanılabilir, standart ve güvenli** bir SQL araç seti sunmaktır.

> ⚠️ Bu repodaki hiçbir dosyada gerçek şirket adı veya veritabanı bulunmaz.  
> Tüm sorgular **güvenli paylaşım** prensibiyle hazırlanmıştır.

---

## 🎯 Amaç ve Kapsam

Bu SQL araç seti aşağıdaki ana ihtiyaçları kapsar:

- **Ana Veriler**
  - Stok ve cari kart kalite kontrolleri
  - Kod doluluk oranları
  - Grup / alt grup / hiyerarşi analizleri
  - Hareketi olan ana verilerin tespiti

- **Stok**
  - Envanter ve bakiye analizleri
  - Son giriş net fiyatı ve satış fiyatı ile maliyet hesapları
  - Döviz bazlı stok maliyetleri
  - Seri / lot bazlı anlık stok ve izlenebilirlik

- **Satış / Alış**
  - Satış ve satış iade detay raporları (kur çevrimli)
  - Alış ve tedarikçi iade analizleri
  - Müşteri ve satıcı borç / alacak bakiyeleri

- **Finans**
  - Gelir tablosu özet
  - Bilanço özet
  - Aylık gelir – gider – net kâr
  - Bilanço hesap detayları
  - Banka borç / alacak bakiyeleri
  - Faturasız gelir–gider (dekont / manuel fiş) tespiti
  - Müşteri ve borç çekleri (portföy, tahsil, teminat, ciro, vade, iptal)

---

## 🔐 Güvenli Paylaşım Prensibi

- Dosyalarda **şirket ismi yoktur**
- Veritabanı adı **placeholder** olarak tanımlıdır
- Özel cari, stok, hesap kodları **bulunmaz**
- Sadece aşağıdaki yapı kullanılır:

```text
{{VT_A}}      {{VT_B}}
{{SIRKET_A}}  {{SIRKET_B}}
{{YIL}}
{{TARIH_BAS}} {{TARIH_BIT}}
{{KUR_TABLOSU}}
