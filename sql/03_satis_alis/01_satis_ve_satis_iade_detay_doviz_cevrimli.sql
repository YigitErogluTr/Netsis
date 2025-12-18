/* 08 - SATIŞ & SATIŞ İADE DETAY (Döviz Çevrimli) | 2 VT
   Gerekli: {{KUR_TABLOSU}} (TARIH, ISIM, DOV_SATIS)
*/

WITH KURLAR AS (
    SELECT
        TARIH,
        ISIM AS DOVIZ_TURU,
        DOV_SATIS AS KUR
    FROM {{KUR_TABLOSU}}
),
HARIC_CARILER AS (
    -- Hariç tutulacak cari kodlar varsa buraya ekle
    -- SELECT 'X01-0001' AS CARI_KOD UNION ALL SELECT 'X01-0002'
    SELECT CAST(NULL AS varchar(50)) AS CARI_KOD WHERE 1=0
)

-- =====================================================
-- ==================== VT_A ===========================
-- =====================================================
SELECT
    '{{SIRKET_A}}' AS SIRKET,

    CASE 
        WHEN s.STHAR_GCKOD = 'C' THEN 'SATIS'
        WHEN s.STHAR_GCKOD = 'G' THEN 'SATIS IADE'
    END AS HAREKET_TIPI,

    s.STHAR_TARIH AS FATURA_TARIH,
    s.FISNO AS FATURA_NO,
    s.AMBAR_KABULNO AS SIPARIS_NO,
    s.STHAR_CARIKOD AS CARI_KOD,
    c.GRUP_KODU AS CARI_GRUP,
    c.ULKE_KODU AS ULKE_KODU,

    REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
        c.CARI_ISIM,'Ð','Ğ'),'Ý','İ'),'Þ','Ş'),'ð','ğ'),'ý','ı'),'þ','ş') AS CARI_TANIM,

    s.STOK_KODU AS STOK_KODU,
    tek.KULL8S AS ERP_STOK_KODU,

    REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
        st.STOK_ADI,'Ð','Ğ'),'Ý','İ'),'Þ','Ş'),'ð','ğ'),'ý','ı'),'þ','ş') AS STOK_ADI,

    st.OLCU_BR1 AS OLCU_BIRIM,

    CASE 
        WHEN s.STHAR_GCKOD = 'C' THEN s.STHAR_GCMIK
        WHEN s.STHAR_GCKOD = 'G' THEN -s.STHAR_GCMIK
    END AS MIKTAR,

    s.STHAR_NF AS BIRIM_FIYAT_TRY,

    (s.STHAR_NF / NULLIF(ISNULL(k.KUR,1),0)) AS BIRIM_FIYAT_DOVIZ,

    CASE 
        WHEN s.STHAR_GCKOD = 'C' THEN (s.STHAR_GCMIK * s.STHAR_NF)
        WHEN s.STHAR_GCKOD = 'G' THEN -(s.STHAR_GCMIK * s.STHAR_NF)
    END AS TOPLAM_TRY,

    CASE 
        WHEN s.STHAR_GCKOD = 'C'
            THEN ((s.STHAR_GCMIK * s.STHAR_NF) / NULLIF(ISNULL(k.KUR,1),0))
        WHEN s.STHAR_GCKOD = 'G'
            THEN -((s.STHAR_GCMIK * s.STHAR_NF) / NULLIF(ISNULL(k.KUR,1),0))
    END AS TOPLAM_DOVIZ,

    s.STHAR_DOVTIP AS DOVIZ_TIP,

    CASE s.STHAR_DOVTIP
        WHEN 0 THEN 'TRY'
        WHEN 1 THEN 'USD'
        WHEN 2 THEN 'EUR'
        ELSE 'Bilinmiyor'
    END AS DOVIZ_TURU,

    ISNULL(k.KUR,1) AS KUR

FROM {{VT_A}}.dbo.TBLSTHAR s
LEFT JOIN {{VT_A}}.dbo.TBLSTSABIT    st  ON s.STOK_KODU = st.STOK_KODU
LEFT JOIN {{VT_A}}.dbo.TBLSTSABITEK  tek ON s.STOK_KODU = tek.STOK_KODU
LEFT JOIN {{VT_A}}.dbo.TBLCASABIT    c   ON s.STHAR_CARIKOD = c.CARI_KOD
LEFT JOIN KURLAR k 
    ON CAST(s.STHAR_TARIH AS date) = CAST(k.TARIH AS date)
   AND (
        (s.STHAR_DOVTIP = 1 AND k.DOVIZ_TURU IN ('USD','DOLAR','US DOLLAR'))
     OR (s.STHAR_DOVTIP = 2 AND k.DOVIZ_TURU IN ('EUR','EURO'))
   )

WHERE s.STHAR_HTUR = 'J'
  AND s.STHAR_GCKOD IN ('C','G')   -- SATIŞ + SATIŞ İADE
  AND s.STHAR_TARIH BETWEEN {{TARIH_BAS}} AND {{TARIH_BIT}}
  AND NOT EXISTS (
        SELECT 1 
        FROM HARIC_CARILER h 
        WHERE h.CARI_KOD = s.STHAR_CARIKOD
  )

UNION ALL

-- =====================================================
-- ==================== VT_B ===========================
-- =====================================================
SELECT
    '{{SIRKET_B}}',

    CASE 
        WHEN s.STHAR_GCKOD = 'C' THEN 'SATIS'
        WHEN s.STHAR_GCKOD = 'G' THEN 'SATIS IADE'
    END,

    s.STHAR_TARIH,
    s.FISNO,
    s.AMBAR_KABULNO,
    s.STHAR_CARIKOD,
    c.GRUP_KODU,
    c.ULKE_KODU,

    REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
        c.CARI_ISIM,'Ð','Ğ'),'Ý','İ'),'Þ','Ş'),'ð','ğ'),'ý','ı'),'þ','ş'),

    s.STOK_KODU,
    tek.KULL8S,

    REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
        st.STOK_ADI,'Ð','Ğ'),'Ý','İ'),'Þ','Ş'),'ð','ğ'),'ý','ı'),'þ','ş'),

    st.OLCU_BR1,

    CASE 
        WHEN s.STHAR_GCKOD = 'C' THEN s.STHAR_GCMIK
        WHEN s.STHAR_GCKOD = 'G' THEN -s.STHAR_GCMIK
    END,

    s.STHAR_NF,

    (s.STHAR_NF / NULLIF(ISNULL(k.KUR,1),0)),

    CASE 
        WHEN s.STHAR_GCKOD = 'C' THEN (s.STHAR_GCMIK * s.STHAR_NF)
        WHEN s.STHAR_GCKOD = 'G' THEN -(s.STHAR_GCMIK * s.STHAR_NF)
    END,

    CASE 
        WHEN s.STHAR_GCKOD = 'C'
            THEN ((s.STHAR_GCMIK * s.STHAR_NF) / NULLIF(ISNULL(k.KUR,1),0))
        WHEN s.STHAR_GCKOD = 'G'
            THEN -((s.STHAR_GCMIK * s.STHAR_NF) / NULLIF(ISNULL(k.KUR,1),0))
    END,

    s.STHAR_DOVTIP,

    CASE s.STHAR_DOVTIP
        WHEN 0 THEN 'TRY'
        WHEN 1 THEN 'USD'
        WHEN 2 THEN 'EUR'
        ELSE 'Bilinmiyor'
    END,

    ISNULL(k.KUR,1)

FROM {{VT_B}}.dbo.TBLSTHAR s
LEFT JOIN {{VT_B}}.dbo.TBLSTSABIT    st  ON s.STOK_KODU = st.STOK_KODU
LEFT JOIN {{VT_B}}.dbo.TBLSTSABITEK  tek ON s.STOK_KODU = tek.STOK_KODU
LEFT JOIN {{VT_B}}.dbo.TBLCASABIT    c   ON s.STHAR_CARIKOD = c.CARI_KOD
LEFT JOIN KURLAR k 
    ON CAST(s.STHAR_TARIH AS date) = CAST(k.TARIH AS date)
   AND (
        (s.STHAR_DOVTIP = 1 AND k.DOVIZ_TURU IN ('USD','DOLAR','US DOLLAR'))
     OR (s.STHAR_DOVTIP = 2 AND k.DOVIZ_TURU IN ('EUR','EURO'))
   )

WHERE s.STHAR_HTUR = 'J'
  AND s.STHAR_GCKOD IN ('C','G')
  AND s.STHAR_TARIH BETWEEN {{TARIH_BAS}} AND {{TARIH_BIT}}
  AND NOT EXISTS (
        SELECT 1 
        FROM HARIC_CARILER h 
        WHERE h.CARI_KOD = s.STHAR_CARIKOD
  )

ORDER BY FATURA_TARIH;
