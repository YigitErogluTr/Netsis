


SELECT
    CS.CARI_KOD,
    CS.CARI_ISIM,
    CS.VADE_GUNU AS CARI_VADESI,

    -- 🔹 BAKIYE (aynı tarih kuralına tabi)
    SUM(
        CASE 
            WHEN CS.DOVIZ_TIPI = 0 
                THEN H.BORC - H.ALACAK
            ELSE H.DOVIZ_TUTAR
        END
    ) AS BAKIYE,

    -- 🔹 Döviz adı
    CASE 
        WHEN CS.DOVIZ_TIPI = 0 THEN 'TRY'
        ELSE D.ISIM
    END AS DOVIZ_TIPI_ADI,

    CS.RAPOR_KODU3,

    -- 🔹 Son fatura bilgileri (aynı filtre!)
    MAX(H.TARIH)       AS SON_FATURA_TARIHI,
    MAX(H.VADE_TARIHI) AS SON_FATURA_VADESI

FROM TBLCASABIT CS
INNER JOIN TBLCAHAR H
    ON CS.CARI_KOD = H.CARI_KOD

LEFT JOIN _BYS_DOVIZ_BUL D
    ON CS.DOVIZ_TIPI = D.SIRA

WHERE CS.CARI_TIP = 'S'

-- 🔴 Döviz tipi uyumu
AND (
        CS.DOVIZ_TIPI = 0
     OR H.DOVIZ_TURU = CS.DOVIZ_TIPI
    )

-- 🔴 TEK VE MERKEZİ TARİH KURALI
AND H.TARIH <= 
    CASE 
        WHEN CS.RAPOR_KODU3 LIKE '%ÇEK%' 
            THEN EOMONTH(GETDATE(), -1)
        ELSE GETDATE()
    END

GROUP BY
    CS.CARI_KOD,
    CS.CARI_ISIM,
    CS.VADE_GUNU,
    CS.DOVIZ_TIPI,
    D.ISIM,
    CS.RAPOR_KODU3

HAVING 
    SUM(
        CASE 
            WHEN CS.DOVIZ_TIPI = 0 
                THEN H.BORC - H.ALACAK
            ELSE H.DOVIZ_TUTAR
        END
    ) <> 0

ORDER BY
    CS.CARI_KOD;
