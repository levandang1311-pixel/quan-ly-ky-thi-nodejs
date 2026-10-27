-- =====================================================================
-- HỆ THỐNG QUẢN LÝ KỲ THI KẾT THÚC HỌC PHẦN  -  MySQL 8.0.16+
-- Chạy toàn bộ script trong MySQL Workbench (Ctrl+Shift+Enter)
-- =====================================================================

DROP DATABASE IF EXISTS quan_ly_ky_thi;
CREATE DATABASE quan_ly_ky_thi
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE quan_ly_ky_thi;

-- ---------------------------------------------------------------------
-- 1. DANH MỤC CƠ SỞ
-- ---------------------------------------------------------------------

CREATE TABLE khoa (
  id        INT AUTO_INCREMENT PRIMARY KEY,
  ma_khoa   VARCHAR(10)  NOT NULL UNIQUE,
  ten_khoa  VARCHAR(150) NOT NULL UNIQUE
) ENGINE=InnoDB COMMENT='Khoa / đơn vị đào tạo';

CREATE TABLE lop (
  id       INT AUTO_INCREMENT PRIMARY KEY,
  ma_lop   VARCHAR(20)  NOT NULL UNIQUE,
  ten_lop  VARCHAR(100) NOT NULL,
  khoa_id  INT NOT NULL,
  INDEX idx_lop_khoa (khoa_id),
  CONSTRAINT fk_lop_khoa FOREIGN KEY (khoa_id) REFERENCES khoa(id)
) ENGINE=InnoDB;

CREATE TABLE sinh_vien (
  id         INT AUTO_INCREMENT PRIMARY KEY,
  cmt        VARCHAR(12)  NOT NULL UNIQUE COMMENT 'Số CMND/CCCD',
  ma_sv      VARCHAR(15)  NOT NULL UNIQUE COMMENT 'Mã số sinh viên',
  ho_ten     VARCHAR(100) NOT NULL,
  ngay_sinh  DATE         NOT NULL,
  lop_id     INT NOT NULL,
  khoa_id    INT NOT NULL,
  INDEX idx_sv_lop (lop_id),
  INDEX idx_sv_khoa (khoa_id),
  INDEX idx_sv_ho_ten (ho_ten),
  CONSTRAINT fk_sv_lop  FOREIGN KEY (lop_id)  REFERENCES lop(id),
  CONSTRAINT fk_sv_khoa FOREIGN KEY (khoa_id) REFERENCES khoa(id)
) ENGINE=InnoDB;

CREATE TABLE giang_vien (
  id         INT AUTO_INCREMENT PRIMARY KEY,
  cmt        VARCHAR(12)  NOT NULL UNIQUE,
  ma_gv      VARCHAR(15)  NOT NULL UNIQUE COMMENT 'Mã số giảng viên',
  ho_ten     VARCHAR(100) NOT NULL,
  ngay_sinh  DATE         NOT NULL,
  hoc_vi     ENUM('cu_nhan','thac_si','tien_si','pho_giao_su','giao_su')
             NOT NULL DEFAULT 'cu_nhan',
  khoa_id    INT NOT NULL COMMENT 'Khoa công tác',
  tham_nien  SMALLINT NOT NULL DEFAULT 0 COMMENT 'Số năm công tác',
  INDEX idx_gv_khoa (khoa_id),
  INDEX idx_gv_hoc_vi (hoc_vi),
  CONSTRAINT fk_gv_khoa FOREIGN KEY (khoa_id) REFERENCES khoa(id),
  CONSTRAINT ck_gv_tham_nien CHECK (tham_nien >= 0)
) ENGINE=InnoDB;

CREATE TABLE hoc_phan (
  id            INT AUTO_INCREMENT PRIMARY KEY,
  ma_hoc_phan   VARCHAR(15)  NOT NULL UNIQUE,
  ten_hoc_phan  VARCHAR(150) NOT NULL,
  so_tin_chi    SMALLINT     NOT NULL,
  khoa_id       INT NOT NULL COMMENT 'Khoa quản lý học phần',
  INDEX idx_hp_khoa (khoa_id),
  CONSTRAINT fk_hp_khoa FOREIGN KEY (khoa_id) REFERENCES khoa(id),
  CONSTRAINT ck_hp_tin_chi CHECK (so_tin_chi > 0)
) ENGINE=InnoDB;

CREATE TABLE phong_thi (
  id        INT AUTO_INCREMENT PRIMARY KEY,
  ma_phong  VARCHAR(15) NOT NULL UNIQUE,
  toa_nha   VARCHAR(50) NOT NULL,
  suc_chua  SMALLINT    NOT NULL COMMENT 'Sức chứa tối đa',
  INDEX idx_phong_toa_nha (toa_nha),
  CONSTRAINT ck_phong_suc_chua CHECK (suc_chua > 0)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 2. TỔ CHỨC KỲ THI
-- ---------------------------------------------------------------------

CREATE TABLE ky_thi (
  id             INT AUTO_INCREMENT PRIMARY KEY,
  ten_ky_thi     VARCHAR(150) NOT NULL,
  hoc_ky         ENUM('HK1','HK2','HK_HE') NOT NULL,
  nam_hoc        VARCHAR(9) NOT NULL COMMENT 'Ví dụ 2025-2026',
  ngay_bat_dau   DATE,
  ngay_ket_thuc  DATE,
  UNIQUE KEY uq_ky_thi_hocky_namhoc (hoc_ky, nam_hoc),
  CONSTRAINT ck_ky_thi_ngay CHECK (ngay_ket_thuc IS NULL OR ngay_bat_dau IS NULL
                                   OR ngay_ket_thuc >= ngay_bat_dau)
) ENGINE=InnoDB COMMENT='Mỗi kỳ thi gắn với một học kỳ, năm học';

CREATE TABLE ca_thi (
  id            INT AUTO_INCREMENT PRIMARY KEY,
  ma_ca_thi     VARCHAR(20) NOT NULL UNIQUE,
  ky_thi_id     INT NOT NULL,
  hoc_phan_id   INT NOT NULL,
  phong_thi_id  INT NOT NULL,
  ngay_thi      DATE NOT NULL,
  gio_bat_dau   TIME NOT NULL,
  gio_ket_thuc  TIME NOT NULL,
  UNIQUE KEY uq_ca_thi_id_kythi_hocphan (id, ky_thi_id, hoc_phan_id),
  INDEX idx_ca_kythi_hocphan (ky_thi_id, hoc_phan_id),
  INDEX idx_ca_phong_ngay_gio (phong_thi_id, ngay_thi, gio_bat_dau),
  INDEX idx_ca_ngay_gio (ngay_thi, gio_bat_dau, gio_ket_thuc),
  CONSTRAINT fk_ca_kythi   FOREIGN KEY (ky_thi_id)    REFERENCES ky_thi(id),
  CONSTRAINT fk_ca_hocphan FOREIGN KEY (hoc_phan_id)  REFERENCES hoc_phan(id),
  CONSTRAINT fk_ca_phong   FOREIGN KEY (phong_thi_id) REFERENCES phong_thi(id),
  CONSTRAINT ck_ca_gio CHECK (gio_ket_thuc > gio_bat_dau)
) ENGINE=InnoDB COMMENT='Một học phần trong kỳ thi có thể có nhiều ca thi';

CREATE TABLE de_thi (
  id         INT AUTO_INCREMENT PRIMARY KEY,
  ca_thi_id  INT NOT NULL,
  ma_de      VARCHAR(10) NOT NULL COMMENT 'Ví dụ A, B, C',
  UNIQUE KEY uq_de_thi_ca_made (ca_thi_id, ma_de),
  CONSTRAINT fk_de_ca FOREIGN KEY (ca_thi_id) REFERENCES ca_thi(id)
) ENGINE=InnoDB COMMENT='Mã đề sử dụng trong từng ca thi';

CREATE TABLE giam_thi (
  id             INT AUTO_INCREMENT PRIMARY KEY,
  ca_thi_id      INT NOT NULL,
  giang_vien_id  INT NOT NULL,
  vai_tro        ENUM('giam_thi_1','giam_thi_2','giam_thi_phu')
                 NOT NULL DEFAULT 'giam_thi_phu',
  UNIQUE KEY uq_giam_thi_ca_gv (ca_thi_id, giang_vien_id),
  INDEX idx_gt_gv (giang_vien_id),
  CONSTRAINT fk_gt_ca FOREIGN KEY (ca_thi_id)     REFERENCES ca_thi(id),
  CONSTRAINT fk_gt_gv FOREIGN KEY (giang_vien_id) REFERENCES giang_vien(id)
) ENGINE=InnoDB COMMENT='Phân công coi thi';

-- ---------------------------------------------------------------------
-- 3. ĐĂNG KÝ THI & KẾT QUẢ
-- ---------------------------------------------------------------------

CREATE TABLE dang_ky_thi (
  id            INT AUTO_INCREMENT PRIMARY KEY,
  sinh_vien_id  INT NOT NULL,
  ky_thi_id     INT NOT NULL,
  hoc_phan_id   INT NOT NULL,
  ca_thi_id     INT NOT NULL,
  so_bao_danh   VARCHAR(15) NOT NULL COMMENT 'SBD riêng cho từng ca thi',
  de_thi_id     INT NOT NULL COMMENT 'Mã đề SV nhận',
  ngay_dang_ky  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uq_dkt_sv_kythi_hocphan (sinh_vien_id, ky_thi_id, hoc_phan_id),
  UNIQUE KEY uq_dkt_ca_sbd (ca_thi_id, so_bao_danh),
  UNIQUE KEY uq_dkt_sv_ca (sinh_vien_id, ca_thi_id),
  INDEX idx_dkt_ca (ca_thi_id),
  INDEX idx_dkt_de (de_thi_id),
  CONSTRAINT fk_dkt_sv FOREIGN KEY (sinh_vien_id) REFERENCES sinh_vien(id),
  CONSTRAINT fk_dkt_de FOREIGN KEY (de_thi_id)    REFERENCES de_thi(id),
  CONSTRAINT fk_dkt_ca_thi FOREIGN KEY (ca_thi_id, ky_thi_id, hoc_phan_id)
    REFERENCES ca_thi(id, ky_thi_id, hoc_phan_id)
) ENGINE=InnoDB COMMENT='Mỗi SV chỉ thi 1 ca duy nhất cho mỗi học phần trong kỳ thi';

CREATE TABLE ket_qua_thi (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  dang_ky_thi_id  INT NOT NULL UNIQUE COMMENT 'Quan hệ 1-1 với đăng ký thi',
  tinh_trang      ENUM('co_mat','vang_thi','bi_dinh_chi_thi')
                  NOT NULL DEFAULT 'co_mat',
  diem_thi        DECIMAL(4,2) NULL COMMENT 'NULL nếu vắng / đình chỉ / huỷ',
  diem_bi_tru     DECIMAL(4,2) NOT NULL DEFAULT 0,
  da_huy_ket_qua  TINYINT(1)   NOT NULL DEFAULT 0,
  ngay_cap_nhat   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
                  ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_kq_tinh_trang (tinh_trang),
  CONSTRAINT fk_kq_dkt FOREIGN KEY (dang_ky_thi_id) REFERENCES dang_ky_thi(id),
  CONSTRAINT ck_kq_diem CHECK (diem_thi IS NULL OR diem_thi BETWEEN 0 AND 10),
  CONSTRAINT ck_kq_diem_tru CHECK (diem_bi_tru >= 0),
  CONSTRAINT ck_kq_logic CHECK (tinh_trang = 'co_mat' OR diem_thi IS NULL)
) ENGINE=InnoDB COMMENT='Chỉ tính điểm khi co_mat và da_huy_ket_qua = 0';

CREATE TABLE vi_pham (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  dang_ky_thi_id  INT NOT NULL COMMENT 'Xác định SV + ca thi vi phạm',
  giam_thi_id     INT NOT NULL COMMENT 'Giám thị lập biên bản',
  hinh_thuc       VARCHAR(200) NOT NULL,
  muc_xu_ly       ENUM('khien_trach','tru_diem','dinh_chi_thi','huy_ket_qua') NOT NULL,
  diem_tru        DECIMAL(4,2) NULL,
  thoi_diem       TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  mo_ta           TEXT,
  INDEX idx_vp_dkt (dang_ky_thi_id),
  INDEX idx_vp_gt (giam_thi_id),
  INDEX idx_vp_muc (muc_xu_ly),
  CONSTRAINT fk_vp_dkt FOREIGN KEY (dang_ky_thi_id) REFERENCES dang_ky_thi(id),
  CONSTRAINT fk_vp_gt  FOREIGN KEY (giam_thi_id)    REFERENCES giam_thi(id),
  CONSTRAINT ck_vp_diem_tru CHECK (muc_xu_ly <> 'tru_diem' OR diem_tru > 0)
) ENGINE=InnoDB COMMENT='Biên bản vi phạm quy chế thi';

-- ---------------------------------------------------------------------
-- 4. CẤU HÌNH THÙ LAO
-- ---------------------------------------------------------------------

CREATE TABLE cau_hinh_thu_lao (
  id                 INT AUTO_INCREMENT PRIMARY KEY,
  ky_thi_id          INT NOT NULL,
  don_gia_ca_thi     DECIMAL(12,0) NOT NULL DEFAULT 150000 COMMENT 'VNĐ / ca / giám thị',
  he_so_tien_si      DECIMAL(4,2)  NOT NULL DEFAULT 0.20,
  he_so_pho_giao_su  DECIMAL(4,2)  NOT NULL DEFAULT 0.20,
  he_so_giao_su      DECIMAL(4,2)  NOT NULL DEFAULT 0.20,
  he_so_giam_thi_1   DECIMAL(4,2)  NOT NULL DEFAULT 0 COMMENT 'Hệ số thêm cho giám thị chính',
  hieu_luc_tu        DATE NOT NULL,
  CONSTRAINT fk_thulao_kythi FOREIGN KEY (ky_thi_id) REFERENCES ky_thi(id)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 5. TRIGGER CÀI RÀNG BUỘC NGHIỆP VỤ
-- ---------------------------------------------------------------------

DELIMITER $$

-- 5.1 Sĩ số ca thi không vượt sức chứa; mã đề phải thuộc đúng ca thi;
--     sinh viên không thi hai ca trùng giờ trong cùng kỳ thi
CREATE TRIGGER trg_dkt_before_insert
BEFORE INSERT ON dang_ky_thi
FOR EACH ROW
BEGIN
  DECLARE v_suc_chua INT;
  DECLARE v_si_so INT;
  DECLARE v_de_dung INT;
  DECLARE v_trung INT;

  SELECT p.suc_chua INTO v_suc_chua
  FROM ca_thi c JOIN phong_thi p ON p.id = c.phong_thi_id
  WHERE c.id = NEW.ca_thi_id;

  SELECT COUNT(*) INTO v_si_so FROM dang_ky_thi WHERE ca_thi_id = NEW.ca_thi_id;
  IF v_si_so >= v_suc_chua THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Ca thi đã đủ sức chứa phòng thi';
  END IF;

  SELECT COUNT(*) INTO v_de_dung FROM de_thi
  WHERE id = NEW.de_thi_id AND ca_thi_id = NEW.ca_thi_id;
  IF v_de_dung = 0 THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Mã đề không thuộc ca thi của sinh viên';
  END IF;

  SELECT COUNT(*) INTO v_trung
  FROM dang_ky_thi d
  JOIN ca_thi c ON c.id = d.ca_thi_id
  JOIN ca_thi n ON n.id = NEW.ca_thi_id
  WHERE d.sinh_vien_id = NEW.sinh_vien_id
    AND c.ngay_thi = n.ngay_thi
    AND c.gio_bat_dau < n.gio_ket_thuc
    AND n.gio_bat_dau < c.gio_ket_thuc;
  IF v_trung > 0 THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Sinh viên đã có ca thi khác trùng giờ';
  END IF;
END$$

-- 5.2 Giảng viên không coi hai ca thi trùng giờ
CREATE TRIGGER trg_giam_thi_before_insert
BEFORE INSERT ON giam_thi
FOR EACH ROW
BEGIN
  DECLARE v_trung INT;

  SELECT COUNT(*) INTO v_trung
  FROM giam_thi g
  JOIN ca_thi c ON c.id = g.ca_thi_id
  JOIN ca_thi n ON n.id = NEW.ca_thi_id
  WHERE g.giang_vien_id = NEW.giang_vien_id
    AND c.id <> n.id
    AND c.ngay_thi = n.ngay_thi
    AND c.gio_bat_dau < n.gio_ket_thuc
    AND n.gio_bat_dau < c.gio_ket_thuc;
  IF v_trung > 0 THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Giảng viên đã coi một ca thi khác trùng giờ';
  END IF;
END$$

-- 5.3 Phòng thi không bị xếp hai ca trùng giờ
CREATE TRIGGER trg_ca_thi_before_insert
BEFORE INSERT ON ca_thi
FOR EACH ROW
BEGIN
  DECLARE v_trung INT;
  SELECT COUNT(*) INTO v_trung FROM ca_thi
  WHERE phong_thi_id = NEW.phong_thi_id
    AND ngay_thi = NEW.ngay_thi
    AND gio_bat_dau < NEW.gio_ket_thuc
    AND NEW.gio_bat_dau < gio_ket_thuc;
  IF v_trung > 0 THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Phòng thi đã có ca thi khác trùng giờ';
  END IF;
END$$

CREATE TRIGGER trg_ca_thi_before_update
BEFORE UPDATE ON ca_thi
FOR EACH ROW
BEGIN
  DECLARE v_trung INT;
  SELECT COUNT(*) INTO v_trung FROM ca_thi
  WHERE id <> OLD.id
    AND phong_thi_id = NEW.phong_thi_id
    AND ngay_thi = NEW.ngay_thi
    AND gio_bat_dau < NEW.gio_ket_thuc
    AND NEW.gio_bat_dau < gio_ket_thuc;
  IF v_trung > 0 THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Phòng thi đã có ca thi khác trùng giờ';
  END IF;
END$$

-- 5.4 Giám thị lập biên bản phải thuộc đúng ca thi của sinh viên vi phạm
CREATE TRIGGER trg_vi_pham_before_insert
BEFORE INSERT ON vi_pham
FOR EACH ROW
BEGIN
  DECLARE v_dung INT;
  SELECT COUNT(*) INTO v_dung
  FROM dang_ky_thi d JOIN giam_thi g ON g.ca_thi_id = d.ca_thi_id
  WHERE d.id = NEW.dang_ky_thi_id AND g.id = NEW.giam_thi_id;
  IF v_dung = 0 THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Giám thị không thuộc ca thi của sinh viên vi phạm';
  END IF;
END$$

DELIMITER ;

-- ---------------------------------------------------------------------
-- 6. KIỂM TRA: CA THI CÓ ÍT HƠN 2 GIÁM THỊ (chạy trước khi chốt lịch)
-- ---------------------------------------------------------------------
-- SELECT c.id, c.ma_ca_thi, COUNT(g.id) AS so_giam_thi
-- FROM ca_thi c LEFT JOIN giam_thi g ON g.ca_thi_id = c.id
-- GROUP BY c.id, c.ma_ca_thi
-- HAVING COUNT(g.id) < 2;

