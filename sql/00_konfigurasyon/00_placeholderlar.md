# Placeholderlar (Şirket/DB bilgisi içermez)

Bu repodaki SQL dosyaları şirket adı / veritabanı adı içermez.
Çalıştırmadan önce aşağıdaki placeholder’ları kendi ortamına göre değiştir.

## Zorunlu
- {{VT_A}} : Şirket A veritabanı adı (örn: SIRKETA2025)
- {{VT_B}} : Şirket B veritabanı adı (örn: SIRKETB2025)
- {{SIRKET_A}} : Şirket A etiketi (örn: SIRKET_A)
- {{SIRKET_B}} : Şirket B etiketi (örn: SIRKET_B)
- {{YIL}} : Yıl (örn: 2025)
- {{TARIH_BAS}} : başlangıç (örn: '2025-01-01')
- {{TARIH_BIT}} : bitiş (örn: '2025-12-31')
- {{KUR_TABLOSU}} : kur tablosu/view (örn: dbo.KUR_TABLO)

## Not
- Bazı sorgularda opsiyonel “hariç tut” listesi vardır, boş bırakabilirsin.
- Görsel tablon yoksa (örn: _BYS_SKU_IMAGE) ilgili join bloğunu silebilirsin.
