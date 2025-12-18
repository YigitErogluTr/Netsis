/* 07 - SERİ / LOT BAZLI ANLIK STOK (mevcut VT) */

WITH DEPO_SERI AS (
    SELECT
        t.STOK_KODU AS StokKod,
        s.STOK_ADI  AS StokAdi,
        s.OLCU_BR1  AS OlcuBr,
        t.DEPOKOD   AS DepoKod,
        d.DEPO_ISMI AS DepoAdi,
        t.SERI_NO   AS SeriNo,
        t.YEDEK1    AS Hucre,
        t.ACIK1     AS Lot,
        SUM(CASE WHEN t.GCKOD='G' THEN t.MIKTAR
                 WHEN t.GCKOD='C' THEN -t.MIKTAR
                 ELSE 0 END) AS Bakiye
    FROM TBLSERITRA t
    LEFT JOIN TBLSTSABIT s ON t.STOK_KODU = s.STOK_KODU
    LEFT JOIN TBLSTOKDP d ON t.DEPOKOD = d.DEPO_KODU
    GROUP BY
        t.STOK_KODU, s.STOK_ADI, s.OLCU_BR1,
        t.DEPOKOD, d.DEPO_ISMI,
        t.SERI_NO, t.YEDEK1, t.ACIK1
    HAVING SUM(CASE WHEN t.GCKOD='G' THEN t.MIKTAR
                    WHEN t.GCKOD='C' THEN -t.MIKTAR
                    ELSE 0 END) <> 0
)
SELECT *
FROM DEPO_SERI
ORDER BY StokKod, DepoKod, Hucre, Lot;
