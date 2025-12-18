/* 05 - STOK KARTI + ENVANTER + (OPSİYONEL) GÖRSEL YOLU (mevcut VT)
   Not: _BYS_SKU_IMAGE tablon yoksa img bloğunu sil.
*/

SELECT
    a.STOK_KODU AS [Stok Kodu],
    REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(a.STOK_ADI,'Ð','Ğ'),'Ý','İ'),'Þ','Ş'),'ð','ğ'),'ý','ı'),'þ','ş') AS [Stok Tanımı],
    a.OLCU_BR1 AS [Ölçü Birimi],
    a.BARKOD1 AS [Barkod],
    ISNULL(p.TOPLAM_GIRIS,0) AS [Toplam Giriş],
    ISNULL(p.TOPLAM_CIKIS,0) AS [Toplam Çıkış],
    ISNULL(p.STOK_MIKTARI,0) AS [Stok Miktarı],
    g.GRUP_ISIM AS [Ana Grup],
    k1.GRUP_ISIM AS [Kod1],
    k2.GRUP_ISIM AS [Kod2],
    k3.GRUP_ISIM AS [Kod3],
    a.SATICI_KODU AS [Satıcı Kodu],
    REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(v.CARI_ISIM,'Ð','Ğ'),'Ý','İ'),'Þ','Ş'),'ð','ğ'),'ý','ı'),'þ','ş') AS [Satıcı Adı],
    a.ALIS_DOV_TIP AS [Döviz Tip Kodu],
    CASE WHEN a.ALIS_DOV_TIP=0 THEN 'TRY'
         WHEN a.ALIS_DOV_TIP=1 THEN 'USD'
         WHEN a.ALIS_DOV_TIP=2 THEN 'EUR'
         ELSE 'Bilinmiyor' END AS [Döviz Tipi],
    a.DOV_MAL_FIAT AS [Döviz Maliyet],
    a.DOV_ALIS_FIAT AS [Alış Fiyatı],
    a.BIRIM_AGIRLIK AS [Ağırlık],
    a.EN  AS [En (cm)],
    a.BOY AS [Boy (cm)],
    a.GENISLIK AS [Yükseklik (cm)],
    ISNULL(img.FOTOGRAF_SAYISI,0) AS [Fotoğraf Sayısı],
    img.MIN_FOTOGRAF_YOLU AS [Fotoğraf Yolu]
FROM TBLSTSABIT a
LEFT JOIN TBLSTGRUP g ON a.GRUP_KODU = g.GRUP_KOD
LEFT JOIN TBLSTOKKOD1 k1 ON a.KOD_1 = k1.GRUP_KOD
LEFT JOIN TBLSTOKKOD2 k2 ON a.KOD_2 = k2.GRUP_KOD
LEFT JOIN TBLSTOKKOD3 k3 ON a.KOD_3 = k3.GRUP_KOD
LEFT JOIN TBLCASABIT v ON a.SATICI_KODU = v.CARI_KOD
LEFT JOIN (
    SELECT
        STOK_KODU,
        SUM(TOP_GIRIS_MIK) AS TOPLAM_GIRIS,
        SUM(TOP_CIKIS_MIK) AS TOPLAM_CIKIS,
        SUM(TOP_GIRIS_MIK) - SUM(TOP_CIKIS_MIK) AS STOK_MIKTARI
    FROM TBLSTOKPH
    GROUP BY STOK_KODU
) p ON a.STOK_KODU = p.STOK_KODU
LEFT JOIN (
    SELECT
        STOK_KODU,
        COUNT(*) AS FOTOGRAF_SAYISI,
        MIN(IMAGEPATH) AS MIN_FOTOGRAF_YOLU
    FROM _BYS_SKU_IMAGE
    GROUP BY STOK_KODU
) img ON img.STOK_KODU = a.STOK_KODU;
