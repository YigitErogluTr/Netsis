SELECT
    B.RAPORKODU,
    B.NETHESKODU,
    B.ACIKLAMA,
    B.DOVIZTIPI,

    SUM(B.HESBORCTOP)   AS TOPLAM_BORC_TRY,
    SUM(B.HESALACTOP)   AS TOPLAM_ALACAK_TRY,

    SUM(
        CASE
            -- Banka, POS, bekleyen nakitler
            WHEN B.NETHESKODU LIKE '102%' 
              OR B.NETHESKODU LIKE '108%'
                THEN B.HESBORCTOP - B.HESALACTOP

            -- Krediler, leasing, KMH, verilen çekler
            WHEN B.NETHESKODU LIKE '300%'
              OR B.NETHESKODU LIKE '301%'
              OR B.NETHESKODU LIKE '302%'
              OR B.NETHESKODU LIKE '400%'
              OR B.NETHESKODU LIKE '401%'
              OR B.NETHESKODU LIKE '402%'
              OR B.NETHESKODU LIKE '103%'
                THEN B.HESALACTOP - B.HESBORCTOP

            ELSE 0
        END
    ) AS BAKIYE_TRY,

    SUM(B.HESBORCTOPDOV) AS TOPLAM_BORC_DOV,
    SUM(B.HESALACTOPDOV) AS TOPLAM_ALACAK_DOV,

    SUM(
        CASE
            WHEN B.NETHESKODU LIKE '102%' 
              OR B.NETHESKODU LIKE '108%'
                THEN B.HESBORCTOPDOV - B.HESALACTOPDOV

            WHEN B.NETHESKODU LIKE '300%'
              OR B.NETHESKODU LIKE '301%'
              OR B.NETHESKODU LIKE '302%'
              OR B.NETHESKODU LIKE '400%'
              OR B.NETHESKODU LIKE '401%'
              OR B.NETHESKODU LIKE '402%'
              OR B.NETHESKODU LIKE '103%'
                THEN B.HESALACTOPDOV - B.HESBORCTOPDOV

            ELSE 0
        END
    ) AS DOVIZ_BAKIYE

FROM TBLBNKHESSABIT B
WHERE
(
       B.NETHESKODU LIKE '102%'  -- Bankalar
    OR B.NETHESKODU LIKE '108%'  -- POS / Diğer hazır değerler
    OR B.NETHESKODU LIKE '103%'  -- Verilen çekler
    OR B.NETHESKODU LIKE '300%'  -- KV Krediler
    OR B.NETHESKODU LIKE '301%'  -- KV Leasing
    OR B.NETHESKODU LIKE '302%'  -- KV Ert. Fin.
    OR B.NETHESKODU LIKE '400%'  -- UV Krediler
    OR B.NETHESKODU LIKE '401%'  -- UV Leasing
    OR B.NETHESKODU LIKE '402%'  -- UV Ert. Fin.
)
GROUP BY
    B.RAPORKODU,
    B.NETHESKODU,
    B.ACIKLAMA,
    B.DOVIZTIPI
ORDER BY
    B.NETHESKODU;
