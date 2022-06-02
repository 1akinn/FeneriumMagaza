-- phpMyAdmin SQL Dump
-- version 5.0.2
-- https://www.phpmyadmin.net/
--
-- Anamakine: 127.0.0.1:3306
-- Üretim Zamanı: 02 Haz 2022, 11:24:05
-- Sunucu sürümü: 8.0.21
-- PHP Sürümü: 7.3.21

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Veritabanı: `fenerium`
--

DELIMITER $$
--
-- Yordamlar
--
DROP PROCEDURE IF EXISTS `Fenerium_MusteriBakiye`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Fenerium_MusteriBakiye` (`id` VARCHAR(64))  BEGIN
    declare borc  float;
    declare odeme float;
    
    SELECT  SUM(satis_fiyat) into borc  
    FROM    Fenerium_satislar 
    WHERE   musteri_id = id;
    
    SELECT  SUM(odeme_tutar) into odeme  
    FROM    Fenerium_odemeler 
    WHERE   musteri_id = id;
    
    SELECT odeme - borc;
END$$

DROP PROCEDURE IF EXISTS `Fenerium_MusteriBul`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Fenerium_MusteriBul` (`filtre` VARCHAR(32))  BEGIN
    SELECT * FROM Fenerium_musteriler
    WHERE 
        musteri_id      LIKE  CONCAT('%',filtre,'%') OR
        musteri_ad      LIKE  CONCAT('%',filtre,'%') OR
        musteri_soyad   LIKE  CONCAT('%',filtre,'%') OR
        musteri_tel     LIKE  CONCAT('%',filtre,'%') OR
        musteri_mail    LIKE  CONCAT('%',filtre,'%') OR
        musteri_adres   LIKE  CONCAT('%',filtre,'%');
END$$

DROP PROCEDURE IF EXISTS `Fenerium_MusteriEkle`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Fenerium_MusteriEkle` (`id` VARCHAR(64), `ad` VARCHAR(64), `soy` VARCHAR(64), `tel` VARCHAR(25), `mail` VARCHAR(250), `adr` VARCHAR(250))  BEGIN
    INSERT INTO Fenerium_musteriler
    VALUES  (id, ad, soy, tel, mail, adr);
END$$

DROP PROCEDURE IF EXISTS `Fenerium_MusteriGuncelle`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Fenerium_MusteriGuncelle` (`id` VARCHAR(64), `ad` VARCHAR(64), `soy` VARCHAR(64), `tel` VARCHAR(25), `mail` VARCHAR(250), `adr` VARCHAR(250))  BEGIN
    UPDATE Fenerium_musteriler
    SET 
        musteri_ad      = ad,
        musteri_soyad   = soy,
        musteri_tel     = tel,
        musteri_mail    = mail,
        musteri_adres   = adr
    WHERE 
        musteri_id      = id;
END$$

DROP PROCEDURE IF EXISTS `Fenerium_MusterilerHepsi`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Fenerium_MusterilerHepsi` ()  BEGIN
    SELECT 
        musteri_id      as ID,
        musteri_ad      as Adı,
        musteri_soyad   as Soyadı,
        musteri_tel     as Telefon, 
        musteri_mail    as Mail,
        musteri_adres   as Adres
    FROM Fenerium_musteriler;
END$$

DROP PROCEDURE IF EXISTS `Fenerium_MusteriSatislar`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Fenerium_MusteriSatislar` (`id` VARCHAR(64))  BEGIN
    SELECT * FROM Fenerium_satislar
    WHERE musteri_id = id;
END$$

DROP PROCEDURE IF EXISTS `Fenerium_MusteriSil`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Fenerium_MusteriSil` (`id` VARCHAR(64))  BEGIN
    DELETE FROM Fenerium_musteriler
    WHERE   musteri_id  = id;
END$$

DROP PROCEDURE IF EXISTS `Fenerium_OdemeDetay`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Fenerium_OdemeDetay` ()  BEGIN
SELECT   
        o.odeme_id,
        m.musteri_id,
        CONCAT(musteri_ad,' ', musteri_soyad ) as `Müşteri Ad Soyad`,
        o.odeme_tarih as `Ödeme Tarihi`,
        o.odeme_tutar as `Ödeme Tutarı`,
        o.odeme_tur as `Ödeme Türü`,
        o.odeme_aciklama as `Açıklama`
        
FROM    Fenerium_musteriler m inner join  Fenerium_odemeler o 
    on m.musteri_id = o.musteri_id;
END$$

DROP PROCEDURE IF EXISTS `Fenerium_OdemeEkle`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Fenerium_OdemeEkle` (`oid` VARCHAR(64), `mid` VARCHAR(64), `tarih` DATETIME, `tutar` FLOAT, `tur` VARCHAR(25), `aciklama` VARCHAR(250))  BEGIN
    INSERT INTO Fenerium_odemeler
    VALUES  (oid, mid, tarih, tutar, tur, aciklama);
END$$

DROP PROCEDURE IF EXISTS `Fenerium_OdemeGuncelle`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Fenerium_OdemeGuncelle` (`oid` VARCHAR(64), `mid` VARCHAR(64), `tarih` DATETIME, `tutar` FLOAT, `tur` VARCHAR(25), `aciklama` VARCHAR(250))  BEGIN
    UPDATE Fenerium_odemeler
    SET
        musteri_id      = mid,
        odeme_tarih     = tarih,
        odeme_tutar     = tutar,
        odeme_tur       = tur,
        odeme_aciklama  = aciklama
    WHERE 
        odeme_id = oid; 
END$$

DROP PROCEDURE IF EXISTS `Fenerium_OdemelerToplam`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Fenerium_OdemelerToplam` ()  BEGIN
    SELECT  SUM(odeme_tutar)  
    FROM    Fenerium_odemeler ;
END$$

DROP PROCEDURE IF EXISTS `Fenerium_OdemeSil`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Fenerium_OdemeSil` (`oid` VARCHAR(64))  BEGIN
    DELETE FROM Fenerium_odemeler
    WHERE odeme_id = oid;
END$$

DROP PROCEDURE IF EXISTS `Fenerium_SatisDetay`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Fenerium_SatisDetay` ()  BEGIN
SELECT   
        s.satis_id,
        m.musteri_id,
        u.urun_id,
        CONCAT(musteri_ad,' ', musteri_soyad ) as `Müşteri Ad Soyad`,
        urun_ad as `Ürün`,
        urun_kategori as `Kategori`,
        urun_fiyat as `Birim Fiyat`,
        satis_fiyat as `Satış Fiyatı`,
        satis_tarih as `Satış Tarihi`
FROM    Fenerium_musteriler m inner join  Fenerium_satislar s 
    on m.musteri_id = s.musteri_id 
        inner join Fenerium_urunler u on s.urun_id = u.urun_id;
END$$

DROP PROCEDURE IF EXISTS `Fenerium_SatisEkle`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Fenerium_SatisEkle` (`sid` VARCHAR(64), `mid` VARCHAR(64), `uid` VARCHAR(64), `tarih` DATETIME, `fiyat` FLOAT)  BEGIN
    INSERT INTO Fenerium_satislar
    VALUES  (sid, mid, uid, tarih, fiyat);
END$$

DROP PROCEDURE IF EXISTS `Fenerium_SatisGuncelle`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Fenerium_SatisGuncelle` (`sid` VARCHAR(64), `mid` VARCHAR(64), `uid` VARCHAR(64), `tarih` DATETIME, `fiyat` FLOAT)  BEGIN
    UPDATE Fenerium_satislar
    SET 
        musteri_id    = mid,
        urun_id       = uid,
        satis_tarih   = tarih,
        satis_fiyat   = fiyat
    WHERE 
        satis_id      = sid;
END$$

DROP PROCEDURE IF EXISTS `Fenerium_SatislarToplam`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Fenerium_SatislarToplam` ()  BEGIN
    SELECT  SUM(satis_fiyat)  
    FROM    Fenerium_satislar ;
END$$

DROP PROCEDURE IF EXISTS `Fenerium_SatisSil`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Fenerium_SatisSil` (`id` VARCHAR(64))  BEGIN
    DELETE FROM Fenerium_satislar
    WHERE satis_id  = id;
END$$

DROP PROCEDURE IF EXISTS `Fenerium_UrunBul`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Fenerium_UrunBul` (`filtre` VARCHAR(32))  BEGIN
    SELECT * FROM Fenerium_urunler
    WHERE 
        urun_id       LIKE  CONCAT('%',filtre,'%') OR
        urun_ad       LIKE  CONCAT('%',filtre,'%') OR
        urun_kategori LIKE  CONCAT('%',filtre,'%') OR
        urun_fiyat    LIKE  CONCAT('%',filtre,'%') OR
        urun_stok     LIKE  CONCAT('%',filtre,'%') OR
        urun_birim    LIKE  CONCAT('%',filtre,'%') OR
        urun_detay    LIKE  CONCAT('%',filtre,'%') ;
END$$

DROP PROCEDURE IF EXISTS `Fenerium_UrunEkle`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Fenerium_UrunEkle` (`id` VARCHAR(64), `ad` VARCHAR(250), `kategori` VARCHAR(250), `fiyat` FLOAT, `stok` FLOAT, `birim` VARCHAR(16), `detay` VARCHAR(250))  BEGIN
    INSERT INTO Fenerium_urunler
    VALUES  (id, ad, kategori, fiyat, stok, birim, detay);
END$$

DROP PROCEDURE IF EXISTS `Fenerium_UrunGuncelle`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Fenerium_UrunGuncelle` (`id` VARCHAR(64), `ad` VARCHAR(250), `kategori` VARCHAR(250), `fiyat` FLOAT, `stok` FLOAT, `birim` VARCHAR(16), `detay` VARCHAR(250))  BEGIN
    UPDATE Fenerium_urunler
    SET 
        urun_ad       = ad,
        urun_kategori = kategori,
        urun_fiyat    = fiyat,
        urun_stok     = stok,
        urun_birim    = birim,
        urun_detay    = detay
    WHERE 
        urun_id       = id;
END$$

DROP PROCEDURE IF EXISTS `Fenerium_UrunlerHepsi`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Fenerium_UrunlerHepsi` ()  BEGIN
    SELECT * FROM Fenerium_urunler;
END$$

DROP PROCEDURE IF EXISTS `Fenerium_UrunSatislar`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Fenerium_UrunSatislar` (`id` VARCHAR(64))  BEGIN
    SELECT * FROM Fenerium_satislar
    WHERE urun_id = id;
END$$

DROP PROCEDURE IF EXISTS `Fenerium_UrunSil`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Fenerium_UrunSil` (`id` VARCHAR(64))  BEGIN
    DELETE FROM Fenerium_urunler
    WHERE urun_id  = id;
END$$

DROP PROCEDURE IF EXISTS `Fenerium_UrunStokGuncelle`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Fenerium_UrunStokGuncelle` (`id` VARCHAR(64), `stok` FLOAT)  BEGIN
    UPDATE Fenerium_urunler
    SET 
        urun_stok     = stok
    WHERE 
        urun_id       = id;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `fenerium_musteriler`
--

DROP TABLE IF EXISTS `fenerium_musteriler`;
CREATE TABLE IF NOT EXISTS `fenerium_musteriler` (
  `musteri_id` varchar(64) NOT NULL,
  `musteri_ad` varchar(64) NOT NULL,
  `musteri_soyad` varchar(64) NOT NULL,
  `musteri_tel` varchar(25) NOT NULL,
  `musteri_mail` varchar(250) NOT NULL,
  `musteri_adres` varchar(250) NOT NULL,
  PRIMARY KEY (`musteri_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Tablo döküm verisi `fenerium_musteriler`
--

INSERT INTO `fenerium_musteriler` (`musteri_id`, `musteri_ad`, `musteri_soyad`, `musteri_tel`, `musteri_mail`, `musteri_adres`) VALUES
('9deb1a09-13a1-430c-b939-34160fcd9357', 'Akın', 'Demirsoy', '0(534) 067-8050', 'akin@gmail.com', 'Bartın'),
('497aa5da-08a2-4ebd-87f1-b7da2fe6a910', 'Bayram', 'Akgül', '0(544) 444-4444', 'bayram@gmail.com', 'Bartın'),
('6de6ee2d-a1b2-4fe1-bb27-c365c54e6cfa', 'Cansu', 'Balikci', '0(544) 444-4444', 'cansu@gmail.com', 'İstanbul'),
('62446de3-63e3-4f9a-a507-f3d82aec6e55', 'Berfin', 'Turhak', '0(555) 555-5555', 'berfin@gmail.com', 'Antalya'),
('103e68a0-6369-4801-9770-fb25f1a66332', 'Acun', 'Ilıcalı', '0(533) 333-3333', 'acun@media.com', 'Dominik'),
('4ca4321d-2515-41da-a871-81f3d7053dde', 'Ali', 'Koç', '0(544) 444-4444', 'ali@koc.com', 'Fenerbahçe'),
('5cacea62-004d-473e-a6c6-755b8425578d', 'Altay', 'Bayındır', '0(522) 222-2222', 'altay@gmail.com', 'Kadıköy');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `fenerium_odemeler`
--

DROP TABLE IF EXISTS `fenerium_odemeler`;
CREATE TABLE IF NOT EXISTS `fenerium_odemeler` (
  `odeme_id` varchar(64) NOT NULL,
  `musteri_id` varchar(64) NOT NULL,
  `odeme_tarih` datetime NOT NULL,
  `odeme_tutar` float NOT NULL,
  `odeme_tur` varchar(25) NOT NULL,
  `odeme_aciklama` varchar(250) NOT NULL,
  PRIMARY KEY (`odeme_id`),
  KEY `musteri_id` (`musteri_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Tablo döküm verisi `fenerium_odemeler`
--

INSERT INTO `fenerium_odemeler` (`odeme_id`, `musteri_id`, `odeme_tarih`, `odeme_tutar`, `odeme_tur`, `odeme_aciklama`) VALUES
('7fa78f01-4b60-4be2-bf77-723c7959b86f', '497aa5da-08a2-4ebd-87f1-b7da2fe6a910', '2022-05-29 18:09:27', 2000, 'Kredi Kartı', 'diğer'),
('802ae8a6-eb24-48be-895b-3fbb3cb2930e', '9deb1a09-13a1-430c-b939-34160fcd9357', '2022-05-29 18:33:34', 60, 'Nakit', 'diğer'),
('73891b5d-26e2-41f9-8899-052db0fadcaa', '6de6ee2d-a1b2-4fe1-bb27-c365c54e6cfa', '2022-05-30 14:18:45', 60, 'Nakit', 'diğer'),
('5737e527-e17b-4709-b5a4-8cff82a7761c', '62446de3-63e3-4f9a-a507-f3d82aec6e55', '2022-05-30 14:34:29', 70, 'Nakit', 'diğer'),
('236dd149-6118-42da-9b6f-da41f5ae7ade', '103e68a0-6369-4801-9770-fb25f1a66332', '2022-05-30 15:20:44', 1000, 'Kredi Kartı', 'diğer'),
('d3042b32-2828-4e1e-993c-e463d2d46720', '4ca4321d-2515-41da-a871-81f3d7053dde', '2022-05-30 15:46:44', 6000, 'Nakit', 'diğer'),
('da96982b-e7ca-420f-8758-a85d25d9721d', '5cacea62-004d-473e-a6c6-755b8425578d', '2022-06-02 14:17:15', 40, 'Nakit', 'diğer');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `fenerium_satislar`
--

DROP TABLE IF EXISTS `fenerium_satislar`;
CREATE TABLE IF NOT EXISTS `fenerium_satislar` (
  `satis_id` varchar(64) NOT NULL,
  `musteri_id` varchar(64) NOT NULL,
  `urun_id` varchar(64) NOT NULL,
  `satis_tarih` datetime NOT NULL,
  `satis_fiyat` float NOT NULL,
  PRIMARY KEY (`satis_id`),
  KEY `musteri_id` (`musteri_id`),
  KEY `urun_id` (`urun_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Tablo döküm verisi `fenerium_satislar`
--

INSERT INTO `fenerium_satislar` (`satis_id`, `musteri_id`, `urun_id`, `satis_tarih`, `satis_fiyat`) VALUES
('249cc320-8183-47f9-a976-6546e5563417', '9deb1a09-13a1-430c-b939-34160fcd9357', 'a17db21a-876f-4b3b-ade9-b03add8f3ebb', '2022-05-29 18:33:15', 50),
('553d2da3-d11c-4d80-994c-50e50dc972a8', '497aa5da-08a2-4ebd-87f1-b7da2fe6a910', '7633a60a-f866-4afc-a8a4-8dd7480d4a25', '2022-05-29 21:07:18', 100),
('35e77146-1b72-4d38-89fb-9f2deee160b0', '62446de3-63e3-4f9a-a507-f3d82aec6e55', 'a17db21a-876f-4b3b-ade9-b03add8f3ebb', '2022-05-30 14:34:14', 60),
('da124c2e-8ba9-4de7-9263-3f0d90208b08', '103e68a0-6369-4801-9770-fb25f1a66332', '7633a60a-f866-4afc-a8a4-8dd7480d4a25', '2022-05-30 15:20:19', 600),
('e410db9e-3ce5-457c-99ce-6637ecedd71d', '4ca4321d-2515-41da-a871-81f3d7053dde', 'bcb13bef-8d84-4c2d-9c59-756502a6831e', '2022-05-30 15:46:28', 500),
('11eb3323-8291-4fb9-b82f-600fb9cd6fe2', '5cacea62-004d-473e-a6c6-755b8425578d', '38bdd32e-ce7f-4ea0-bbe5-ed309e86b57b', '2022-06-02 14:16:54', 50);

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `fenerium_urunler`
--

DROP TABLE IF EXISTS `fenerium_urunler`;
CREATE TABLE IF NOT EXISTS `fenerium_urunler` (
  `urun_id` varchar(64) NOT NULL,
  `urun_ad` varchar(250) NOT NULL,
  `urun_kategori` varchar(250) NOT NULL,
  `urun_fiyat` float NOT NULL,
  `urun_stok` float NOT NULL,
  `urun_birim` varchar(16) NOT NULL,
  `urun_detay` varchar(250) NOT NULL,
  PRIMARY KEY (`urun_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Tablo döküm verisi `fenerium_urunler`
--

INSERT INTO `fenerium_urunler` (`urun_id`, `urun_ad`, `urun_kategori`, `urun_fiyat`, `urun_stok`, `urun_birim`, `urun_detay`) VALUES
('a17db21a-876f-4b3b-ade9-b03add8f3ebb', 'Erkek Beyaz Tribün Palamut Nakış', 'T-shirt', 200, 1000, 'Adet', '%100 Pamuk\r\n\r\n• 30C de yıkanabilir\r\n\r\n• Ağartıcı kullanılmaz\r\n\r\n• Santrifüjlü makinede kurutulmaz\r\n\r\n• Ilık ütü yapınız\r\n\r\n• Kuru temizleme yapılmaz'),
('7633a60a-f866-4afc-a8a4-8dd7480d4a25', 'Fenerbahçe 2021 Çubuklu Forma', 'Forma', 379, 1000, 'Adet', '%100 POLYESTER\r\n\r\nBASKIYI ÜTÜLEMEYİNİZ !\r\n\r\nRENKLİLERE ÖZEL DETERJAN KULLANINIZ.\r\n\r\nTERTSTEN YIKAYIP ÜTÜLEYİNİZ.\r\n\r\nBENZER RENKLERLE BİRLİKTE YIKAYINIZ.'),
('706af81f-15c5-43cf-a129-2b232657bfaf', 'Kadın Antrasit Trend Yarım Kol Tshirt', 'T-shirt', 280, 1000, 'Adet', '%64 Modal %36 Polyester\r\n\r\n• 30C de yıkanabilir\r\n\r\n• Ağartıcı kullanılmaz\r\n\r\n• Santrifüjlü makinede kurutulmaz\r\n\r\n• Ilık ütü yapınız\r\n\r\n• Kuru temizleme yapılmaz'),
('bcb13bef-8d84-4c2d-9c59-756502a6831e', 'Erkek Sarı Efsane 10 Sweat', 'Sweatshirt', 450, 500, 'Adet', '%86 Pamuk , %13 Polyester\r\n30C de yıkanabilir\r\nAğartıcı kullanılmaz\r\nSantrifüjlü makinede kurutulmaz\r\nIlık ütü yapınız\r\nKuru temizleme yapılmaz'),
('38bdd32e-ce7f-4ea0-bbe5-ed309e86b57b', 'Erkek Tribün Basic Şort', 'Şort', 269, 1000, 'Adet', '%78 Pamuk, %18 Polyester, %4 Elastan\r\n30C de yıkanabilir\r\nAğartıcı kullanılmaz\r\nSantrifüjlü makinede kurutulmaz\r\nIlık ütü yapınız\r\nKuru temizleme yapılmaz');
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
