-- Veritabanı Adı: yemekhane_sistemi
CREATE DATABASE IF NOT EXISTS yemekhane_sistemi;
USE yemekhane_sistemi;

-- ====================================
-- Tablo: kullanicilar
-- Kullanıcı bilgilerini tutar (admin ve kullanıcılar için)
-- ====================================
CREATE TABLE IF NOT EXISTS kullanicilar (
    id INT AUTO_INCREMENT PRIMARY KEY, -- Benzersiz kullanıcı ID
    ad VARCHAR(50) NOT NULL,           -- Kullanıcının adı
    soyad VARCHAR(50) NOT NULL,        -- Kullanıcının soyadı
    email VARCHAR(100) UNIQUE NOT NULL,-- Kullanıcının e-posta adresi (benzersiz)
    sifre VARCHAR(100) NOT NULL,       -- Kullanıcının şifresi
    rol ENUM('admin', 'kullanici') DEFAULT 'kullanici', -- Kullanıcının rolü
    bakiye DECIMAL(10,2) DEFAULT 0.00, -- Kullanıcının bakiye bilgisi
    token VARCHAR(255) DEFAULT NULL,   -- Kullanıcı oturum token bilgisi
    okul_no VARCHAR(50) DEFAULT NULL   -- Kullanıcının okul numarası
);

-- ====================================
-- Tablo: rezervasyonlar
-- Kullanıcı rezervasyonlarını tutar
-- ====================================
CREATE TABLE IF NOT EXISTS rezervasyonlar (
    id INT AUTO_INCREMENT PRIMARY KEY, -- Benzersiz rezervasyon ID
    isim_soyisim VARCHAR(255) NOT NULL DEFAULT 'Bilinmiyor', -- Kullanıcının adı ve soyadı
    tarih DATETIME NOT NULL,            -- Rezervasyon tarihi
    saat TIME,                          -- Rezervasyon saati
    ogun ENUM('öğle', 'akşam') NOT NULL,-- Öğün türü (öğle/akşam)
    email VARCHAR(255) NOT NULL DEFAULT 'bilinmiyor@example.com', -- Kullanıcı e-postası
    okul_no VARCHAR(50) NOT NULL,       -- Kullanıcının okul numarası
    ucret VARCHAR(50),                  -- Rezervasyon ücreti
    durum VARCHAR(255) DEFAULT NULL,    -- Rezervasyon durumu (Bugün, Geçmiş, vb.)
    yemek_türü VARCHAR(255) DEFAULT NULL, -- Rezervasyona ait yemek türü
    kullanici_id INT,                   -- Kullanıcı ile ilişki
    menu_id INT,                        -- Menü ile ilişki
    FOREIGN KEY (kullanici_id) REFERENCES kullanicilar(id) ON DELETE CASCADE
);

-- ====================================
-- Tablo: yemek_menusu
-- Günlük yemek menüsünü tutar
-- ====================================
CREATE TABLE IF NOT EXISTS yemek_menusu (
    id INT AUTO_INCREMENT PRIMARY KEY, -- Benzersiz yemek menüsü ID
    tarih DATE NOT NULL,               -- Menünün tarihi
    corba VARCHAR(100) NOT NULL,       -- Çorba ismi
    anaYemek VARCHAR(100) NOT NULL,    -- Ana yemek ismi
    yardimciYemek VARCHAR(100) NOT NULL, -- Yardımcı yemek ismi
    corba_gramaj VARCHAR(50),          -- Çorbanın gramajı
    corba_kalori VARCHAR(50),          -- Çorbanın kalorisi
    anaYemek_gramaj VARCHAR(50),       -- Ana yemeğin gramajı
    anaYemek_kalori VARCHAR(50),       -- Ana yemeğin kalorisi
    yardimciYemek_gramaj VARCHAR(50),  -- Yardımcı yemeğin gramajı
    yardimciYemek_kalori VARCHAR(50),  -- Yardımcı yemeğin kalorisi
    ekstra VARCHAR(100),               -- Ekstra yemek ismi
    ekstra_gramaj VARCHAR(50),         -- Ekstra yemeğin gramajı
    ekstra_kalori VARCHAR(50)          -- Ekstra yemeğin kalorisi
);

-- ====================================
-- Tablo: bakiye_islemleri
-- Kullanıcıların bakiye hareketlerini tutar
-- ====================================
CREATE TABLE IF NOT EXISTS bakiye_islemleri (
    id INT AUTO_INCREMENT PRIMARY KEY, -- Benzersiz işlem ID
    kullanici_id INT NOT NULL,         -- Kullanıcı ile ilişki
    tarih DATETIME DEFAULT CURRENT_TIMESTAMP, -- İşlem tarihi
    islem_tipi VARCHAR(255) NOT NULL DEFAULT 'Bilinmiyor', -- İşlem tipi (Bakiye Yüklendi, vb.)
    tutar DECIMAL(10,2) NOT NULL,      -- İşlem tutarı
    FOREIGN KEY (kullanici_id) REFERENCES kullanicilar(id) ON DELETE CASCADE
);

-- ====================================
-- Tablo: yorumlar
-- Kullanıcıların yorumlarını tutar
-- ====================================
CREATE TABLE IF NOT EXISTS yorumlar (
    id INT AUTO_INCREMENT PRIMARY KEY, -- Benzersiz yorum ID
    isim VARCHAR(50) NOT NULL,         -- Yorumu yapan kullanıcının ismi
    eposta VARCHAR(100) NOT NULL,      -- Yorumu yapan kullanıcının e-postası
    yorum TEXT NOT NULL,               -- Yorum metni
    tarih TIMESTAMP DEFAULT CURRENT_TIMESTAMP -- Yorum tarihi
);

-- ====================================
-- Tablo: kart_bilgileri
-- Kullanıcıların ödeme kart bilgilerini tutar
-- ====================================
CREATE TABLE IF NOT EXISTS kart_bilgileri (
    id INT AUTO_INCREMENT PRIMARY KEY, -- Benzersiz kart bilgisi ID
    kullanici_id INT NOT NULL,         -- Kullanıcı ile ilişki
    kart_numarasi VARCHAR(16) NOT NULL,-- Kart numarası
    son_kullanma_tarihi VARCHAR(5) NOT NULL, -- Kartın son kullanma tarihi (MM/YY)
    cvc VARCHAR(3) NOT NULL,           -- Kartın CVC numarası
    eklenme_tarihi DATETIME DEFAULT CURRENT_TIMESTAMP, -- Kartın eklenme tarihi
    FOREIGN KEY (kullanici_id) REFERENCES kullanicilar(id) ON DELETE CASCADE
);

-- ====================================
-- Tablo: islem_gecmisi
-- Kullanıcıların işlem geçmişini tutar
-- ====================================
CREATE TABLE IF NOT EXISTS islem_gecmisi (
    id INT AUTO_INCREMENT PRIMARY KEY, -- Benzersiz işlem geçmişi ID
    kullanici_id INT NOT NULL,         -- Kullanıcı ile ilişki
    islem_turu ENUM('Bakiye Yüklendi', 'Rezervasyon Harcaması') NOT NULL, -- İşlem türü
    tutar DECIMAL(10,2) NOT NULL,      -- İşlem tutarı
    tarih DATETIME DEFAULT CURRENT_TIMESTAMP, -- İşlem tarihi
    FOREIGN KEY (kullanici_id) REFERENCES kullanicilar(id) ON DELETE CASCADE
);

-- ====================================
-- Tablo: kullanicimenuler
-- Kullanıcılar ile yemek menüleri arasındaki ilişkileri tutar
-- ====================================
CREATE TABLE IF NOT EXISTS kullanicimenuler (
    kullanici_id INT NOT NULL,         -- Kullanıcı ID
    menu_id INT NOT NULL,              -- Menü ID
    PRIMARY KEY (kullanici_id, menu_id), -- Birincil anahtar (ikili ilişki)
    FOREIGN KEY (kullanici_id) REFERENCES kullanicilar(id), -- Kullanıcı ile ilişki
    FOREIGN KEY (menu_id) REFERENCES yemek_menusu(id) -- Menü ile ilişki
);
-- ====================================
-- Tetikleyici: rezervasyon_bakiye_dusur
-- Rezervasyon ekleme işleminden sonra kullanıcının bakiyesini düşürür
-- ====================================
DELIMITER $$
CREATE TRIGGER rezervasyon_bakiye_dusur
AFTER INSERT ON rezervasyonlar
FOR EACH ROW
BEGIN
    DECLARE mevcut_bakiye DECIMAL(10,2);
    DECLARE rezervasyon_ucreti DECIMAL(10,2);

    -- Kullanıcının mevcut bakiyesini al
    SELECT bakiye INTO mevcut_bakiye
    FROM kullanicilar
    WHERE id = NEW.kullanici_id;

    SET rezervasyon_ucreti = CAST(NEW.ucret AS DECIMAL(10,2));

    -- Bakiyeyi kontrol et
    IF mevcut_bakiye < rezervasyon_ucreti THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Yetersiz bakiye!';
    END IF;

    -- Bakiyeyi güncelle
    UPDATE kullanicilar
    SET bakiye = mevcut_bakiye - rezervasyon_ucreti
    WHERE id = NEW.kullanici_id;
END$$
DELIMITER ;

-- ====================================
-- Tetikleyici: bakiye_yukleme_islem_ekle
-- Kullanıcının bakiyesi artırıldığında işlem geçmişine kayıt ekler
-- ====================================
DELIMITER $$
CREATE TRIGGER bakiye_yukleme_islem_ekle
AFTER UPDATE ON kullanicilar
FOR EACH ROW
BEGIN
    IF NEW.bakiye > OLD.bakiye THEN
        INSERT INTO bakiye_islemleri (kullanici_id, tarih, islem_tipi, tutar)
        VALUES (NEW.id, NOW(), 'Bakiye Yüklendi', NEW.bakiye - OLD.bakiye);
    END IF;
END$$
DELIMITER ;
-- ====================================
-- Prosedür: Bakiye Güncelleme
-- Kullanıcı bakiyesini artırır veya azaltır
-- ====================================
DELIMITER $$
CREATE PROCEDURE BakiyeGuncelle(
    IN kullaniciID INT,
    IN miktar DECIMAL(10,2)
)
BEGIN
    -- Kullanıcı bakiyesini güncelle
    UPDATE kullanicilar
    SET bakiye = bakiye + miktar
    WHERE id = kullaniciID;

    -- İşlem geçmişine kayıt ekle
    IF miktar > 0 THEN
        INSERT INTO bakiye_islemleri (kullanici_id, tarih, islem_tipi, tutar)
        VALUES (kullaniciID, NOW(), 'Bakiye Yüklendi', miktar);
    ELSE
        INSERT INTO bakiye_islemleri (kullanici_id, tarih, islem_tipi, tutar)
        VALUES (kullaniciID, NOW(), 'Rezervasyon Harcaması', miktar);
    END IF;
END$$
DELIMITER ;

-- ====================================
-- Prosedür: Haftalık Menü Listeleme
-- Belirtilen tarih aralığındaki menüleri listeler
-- ====================================
DELIMITER $$
CREATE PROCEDURE HaftalikMenu(
    IN baslangicTarihi DATE,
    IN bitisTarihi DATE
)
BEGIN
    SELECT tarih, corba, anaYemek, yardimciYemek, ekstra
    FROM yemek_menusu
    WHERE tarih BETWEEN baslangicTarihi AND bitisTarihi
    ORDER BY tarih ASC;
END$$
DELIMITER ;

-- ====================================
-- Prosedür: Rezervasyon Ekle
-- Rezervasyon oluşturur ve bakiyeyi günceller
-- ====================================
DELIMITER $$
CREATE PROCEDURE RezervasyonEkle(
    IN kullaniciID INT,
    IN tarih DATE,
    IN ogun VARCHAR(10),
    IN rezervasyon_ucreti DECIMAL(10,2)
)
BEGIN
    DECLARE mevcut_bakiye DECIMAL(10,2);

    -- Kullanıcının mevcut bakiyesini al
    SELECT bakiye INTO mevcut_bakiye
    FROM kullanicilar
    WHERE id = kullaniciID;

    -- Yetersiz bakiye kontrolü
    IF mevcut_bakiye < rezervasyon_ucreti THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Yetersiz bakiye!';
    END IF;

    -- Rezervasyon ekle
    INSERT INTO rezervasyonlar (kullanici_id, tarih, ogun, ucret)
    VALUES (kullaniciID, tarih, ogun, rezervasyon_ucreti);

    -- Kullanıcının bakiyesini güncelle
    UPDATE kullanicilar
    SET bakiye = mevcut_bakiye - rezervasyon_ucreti
    WHERE id = kullaniciID;
END$$
DELIMITER ;
-- ====================================
-- Görünüm: GunlukRezervasyonlar
-- Bugün yapılmış rezervasyonları listeler
-- ====================================
CREATE VIEW GunlukRezervasyonlar AS
SELECT isim_soyisim, tarih, ogun, durum
FROM rezervasyonlar
WHERE tarih = CURDATE();

-- ====================================
-- Görünüm: TumKullaniciRezervasyonlari
-- Tüm kullanıcıların rezervasyonlarını listeler
-- ====================================
CREATE VIEW TumKullaniciRezervasyonlari AS
SELECT kullanici_id, isim_soyisim, tarih, ogun, durum
FROM rezervasyonlar
ORDER BY tarih DESC;
-- ====================================
-- Fonksiyon: ToplamKaloriHesapla
-- Belirtilen menüye ait toplam kaloriyi hesaplar
-- ====================================
DELIMITER $$
CREATE FUNCTION ToplamKaloriHesapla(menuID INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE toplam_kalori DECIMAL(10,2);

    -- Menüye ait kalorileri toplar
    SELECT 
        COALESCE(SUM(
            CAST(corba_kalori AS DECIMAL(10,2)) +
            CAST(anaYemek_kalori AS DECIMAL(10,2)) +
            CAST(yardimciYemek_kalori AS DECIMAL(10,2)) +
            CAST(ekstra_kalori AS DECIMAL(10,2))
        ), 0)
    INTO toplam_kalori
    FROM yemek_menusu
    WHERE id = menuID;

    RETURN toplam_kalori;
END$$
DELIMITER ;

-- ====================================
-- Fonksiyon: KullaniciBakiyesi
-- Kullanıcının mevcut bakiyesini döner
-- ====================================
DELIMITER $$
CREATE FUNCTION KullaniciBakiyesi(kullaniciID INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE bakiye DECIMAL(10,2);

    -- Kullanıcının mevcut bakiyesini döner
    SELECT bakiye INTO bakiye
    FROM kullanicilar
    WHERE id = kullaniciID;

    RETURN bakiye;
END$$
DELIMITER ;
-- ====================================
-- Kullanıcıların e-posta adreslerini benzersiz yapıyoruz
-- ====================================
ALTER TABLE kullanicilar
ADD UNIQUE(email);

-- ====================================
-- Yemek menüsü tablosunda bir gün ve öğün için yalnızca bir menü eklenebilir
-- ====================================
ALTER TABLE yemek_menusu
ADD UNIQUE(tarih, corba, anaYemek, yardimciYemek);

-- ====================================
-- Rezervasyonların bir gün ve öğün için yalnızca bir kez yapılmasını sağlıyoruz
-- ====================================
ALTER TABLE rezervasyonlar
ADD UNIQUE(kullanici_id, tarih, ogun);
-- Bugün yapılan rezervasyonların detaylarını getirir
SELECT isim_soyisim, ogun, tarih, durum
FROM rezervasyonlar
WHERE DATE(tarih) = CURDATE();
-- Haftalık yemek menüsünü getirir
SELECT tarih, corba, anaYemek, yardimciYemek, ekstra
FROM yemek_menusu
WHERE tarih BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 7 DAY)
ORDER BY tarih ASC;
-- Belirli bir kullanıcıya ait tüm rezervasyonları listeler
SELECT r.id, r.tarih, r.ogun, r.durum, y.corba, y.anaYemek
FROM rezervasyonlar r
JOIN yemek_menusu y ON r.menu_id = y.id
WHERE r.kullanici_id = 2; -- Kullanıcı ID'sini değiştirin
-- Kullanıcıların toplam harcama tutarlarını getirir
SELECT k.ad, k.soyad, SUM(CAST(r.ucret AS DECIMAL(10,2))) AS toplam_harcama
FROM rezervasyonlar r
JOIN kullanicilar k ON r.kullanici_id = k.id
GROUP BY r.kullanici_id;
-- Her menü için toplam kaloriyi getirir
SELECT id, tarih, ToplamKaloriHesapla(id) AS toplam_kalori
FROM yemek_menusu;
-- Yeni kullanıcı ekleme
INSERT INTO kullanicilar (ad, soyad, email, sifre, rol, bakiye, okul_no)
VALUES ('Ali', 'Veli', 'ali.veli@etu.edu.tr', 'ali123', 'kullanici', 150.00, '987654');

-- Yeni yemek menüsü ekleme
INSERT INTO yemek_menusu (tarih, corba, anaYemek, yardimciYemek, ekstra, corba_kalori, anaYemek_kalori, yardimciYemek_kalori, ekstra_kalori)
VALUES ('2024-12-31', 'Domates Çorbası', 'Et Sote', 'Bulgur Pilavı', 'Ayran', '150', '300', '200', '100');

-- Yeni rezervasyon ekleme
INSERT INTO rezervasyonlar (kullanici_id, tarih, ogun, ucret, durum, menu_id)
VALUES (1, '2024-12-31', 'öğle', 25.00, 'Bugün', 1);

SHOW TABLES;
DESCRIBE kullanicilar;
DESCRIBE rezervasyonlar;
DESCRIBE yemek_menusu;
DESCRIBE bakiye_islemleri;
DESCRIBE yorumlar;
DESCRIBE islem_gecmisi;
DESCRIBE kart_bilgileri;
SELECT * FROM kullanicilar;
SELECT * FROM rezervasyonlar;
SELECT * FROM yemek_menusu;
SELECT * FROM bakiye_islemleri;
SELECT * FROM yorumlar;
SELECT * FROM islem_gecmisi;
SELECT * FROM kart_bilgileri;
SELECT 
    TABLE_NAME, 
    COLUMN_NAME, 
    CONSTRAINT_NAME, 
    REFERENCED_TABLE_NAME, 
    REFERENCED_COLUMN_NAME
FROM 
    INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE 
    TABLE_SCHEMA = 'yemekhane_sistemi';
DELIMITER //

CREATE PROCEDURE BakiyeEkle(
    IN kullanici_id INT,
    IN eklenen_tutar DECIMAL(10,2)
)
BEGIN
    -- Mevcut bakiye kontrolü ve güncelleme
    UPDATE kullanicilar
    SET bakiye = bakiye + eklenen_tutar
    WHERE id = kullanici_id;

    -- İşlem geçmişine kayıt ekleme
    INSERT INTO bakiye_islemleri (kullanici_id, islem_tipi, tutar)
    VALUES (kullanici_id, 'Bakiye Yüklendi', eklenen_tutar);
END;
//

DELIMITER ;
DELIMITER //

CREATE PROCEDURE RezervasyonHarcama(
    IN kullanici_id INT,
    IN harcama_tutar DECIMAL(10,2)
)
BEGIN
    DECLARE mevcut_bakiye DECIMAL(10,2);

    -- Kullanıcının mevcut bakiyesini al
    SELECT bakiye INTO mevcut_bakiye
    FROM kullanicilar
    WHERE id = kullanici_id;

    -- Yetersiz bakiye kontrolü
    IF mevcut_bakiye < harcama_tutar THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Yetersiz bakiye!';
    ELSE
        -- Bakiyeyi düşür
        UPDATE kullanicilar
        SET bakiye = mevcut_bakiye - harcama_tutar
        WHERE id = kullanici_id;

        -- İşlem geçmişine kayıt ekleme
        INSERT INTO bakiye_islemleri (kullanici_id, islem_tipi, tutar)
        VALUES (kullanici_id, 'Rezervasyon Harcaması', -harcama_tutar);
    END IF;
END;
//

DELIMITER ;
CREATE VIEW KullaniciRezervasyonDetaylari AS
SELECT
    r.id AS rezervasyon_id,
    k.ad AS kullanici_ad,
    k.soyad AS kullanici_soyad,
    r.tarih AS rezervasyon_tarihi,
    r.ogun AS ogun_tipi,
    r.yemek_türü AS yemek_turu,
    r.ucret AS rezervasyon_ucreti
FROM
    rezervasyonlar r
INNER JOIN
    kullanicilar k ON r.kullanici_id = k.id;
CREATE VIEW GunlukYemekMenusu AS
SELECT
    tarih,
    corba,
    anaYemek,
    yardimciYemek,
    ekstra
FROM
    yemek_menusu;
