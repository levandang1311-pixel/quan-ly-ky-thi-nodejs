-- =====================================================================
-- DỮ LIỆU MẪU - HỆ THỐNG QUẢN LÝ KỲ THI KẾT THÚC HỌC PHẦN (MySQL 8)
-- Chạy SAU khi đã chạy script tạo bảng quan_ly_ky_thi_mysql.sql
-- Thứ tự chèn tuân thủ khoá ngoại và đã được kiểm tra với các trigger
-- =====================================================================

SET NAMES utf8mb4;
USE quan_ly_ky_thi;

-- ---------------------------------------------------------------------
-- 1. KHOA (4 bản ghi)
-- ---------------------------------------------------------------------
INSERT INTO khoa (id, ma_khoa, ten_khoa) VALUES
(1, 'CNTT', 'Khoa Công nghệ thông tin'),
(2, 'KT',   'Khoa Kinh tế'),
(3, 'NN',   'Khoa Ngoại ngữ'),
(4, 'KHCB', 'Khoa Khoa học cơ bản');

-- ---------------------------------------------------------------------
-- 2. LỚP (5 bản ghi)
-- ---------------------------------------------------------------------
INSERT INTO lop (id, ma_lop, ten_lop, khoa_id) VALUES
(1, 'CNTT01', 'Công nghệ thông tin 01', 1),
(2, 'CNTT02', 'Công nghệ thông tin 02', 1),
(3, 'KT01',   'Kinh tế 01',             2),
(4, 'KT02',   'Kinh tế 02',             2),
(5, 'NN01',   'Ngôn ngữ Anh 01',        3);

-- ---------------------------------------------------------------------
-- 3. SINH VIÊN (15 bản ghi)
-- ---------------------------------------------------------------------
INSERT INTO sinh_vien (id, cmt, ma_sv, ho_ten, ngay_sinh, lop_id, khoa_id) VALUES
(1,  '001205012301', 'SV2023001', 'Nguyễn Văn An',    '2005-03-12', 1, 1),
(2,  '001205012302', 'SV2023002', 'Trần Thị Bình',    '2005-07-25', 1, 1),
(3,  '001204012303', 'SV2023003', 'Lê Hoàng Cường',   '2004-11-02', 1, 1),
(4,  '001205012304', 'SV2023004', 'Phạm Minh Đức',    '2005-01-18', 1, 1),
(5,  '001205012305', 'SV2023005', 'Hoàng Thị Em',     '2005-09-30', 1, 1),
(6,  '001205012306', 'SV2023006', 'Vũ Quốc Phong',    '2005-05-14', 2, 1),
(7,  '001205012307', 'SV2023007', 'Đặng Thu Giang',   '2005-02-27', 2, 1),
(8,  '001204012308', 'SV2023008', 'Bùi Anh Hào',      '2004-12-09', 2, 1),
(9,  '001205012309', 'SV2023009', 'Ngô Thị Hương',    '2005-06-21', 3, 2),
(10, '001205012310', 'SV2023010', 'Dương Văn Khánh',  '2005-08-08', 3, 2),
(11, '001204012311', 'SV2023011', 'Lý Thị Lan',       '2004-10-15', 3, 2),
(12, '001205012312', 'SV2023012', 'Đỗ Minh Long',     '2005-04-03', 4, 2),
(13, '001205012313', 'SV2023013', 'Phan Thị Mai',     '2005-10-19', 4, 2),
(14, '001205012314', 'SV2023014', 'Trịnh Văn Nam',    '2005-12-01', 5, 3),
(15, '001205012315', 'SV2023015', 'Hồ Thị Oanh',      '2005-03-29', 5, 3);

-- ---------------------------------------------------------------------
-- 4. GIẢNG VIÊN (8 bản ghi, đủ các học vị)
-- ---------------------------------------------------------------------
INSERT INTO giang_vien (id, cmt, ma_gv, ho_ten, ngay_sinh, hoc_vi, khoa_id, tham_nien) VALUES
(1, '001180000001', 'GV001', 'Nguyễn Đình Hải',  '1980-04-10', 'tien_si',     1, 18),
(2, '001188000002', 'GV002', 'Trần Thu Hà',      '1988-09-22', 'thac_si',     1, 10),
(3, '001175000003', 'GV003', 'Lê Văn Minh',      '1975-01-05', 'pho_giao_su', 1, 25),
(4, '001190000004', 'GV004', 'Phạm Thị Ngọc',    '1990-06-17', 'thac_si',     2, 8),
(5, '001182000005', 'GV005', 'Hoàng Quang Huy',  '1982-11-30', 'tien_si',     2, 16),
(6, '001192000006', 'GV006', 'Vũ Thị Lan Anh',   '1992-02-14', 'thac_si',     3, 6),
(7, '001195000007', 'GV007', 'Đặng Quốc Việt',   '1995-08-08', 'cu_nhan',     4, 3),
(8, '001170000008', 'GV008', 'Bùi Văn Thắng',    '1970-12-25', 'giao_su',     4, 30);

-- ---------------------------------------------------------------------
-- 5. HỌC PHẦN (8 bản ghi)
-- ---------------------------------------------------------------------
INSERT INTO hoc_phan (id, ma_hoc_phan, ten_hoc_phan, so_tin_chi, khoa_id) VALUES
(1, 'INT2204', 'Cơ sở dữ liệu',                3, 1),
(2, 'INT2202', 'Lập trình hướng đối tượng',    3, 1),
(3, 'MAT1101', 'Giải tích 1',                  3, 4),
(4, 'ECO1101', 'Kinh tế vi mô',                3, 2),
(5, 'ENG1102', 'Tiếng Anh 2',                  2, 3),
(6, 'MAT1102', 'Xác suất thống kê',            3, 4),
(7, 'INT3301', 'Mạng máy tính',                3, 1),
(8, 'ACC1101', 'Nguyên lý kế toán',            3, 2);

-- ---------------------------------------------------------------------
-- 6. PHÒNG THI (5 bản ghi)
-- ---------------------------------------------------------------------
INSERT INTO phong_thi (id, ma_phong, toa_nha, suc_chua) VALUES
(1, 'A101', 'Nhà A', 40),
(2, 'A102', 'Nhà A', 40),
(3, 'B201', 'Nhà B', 30),
(4, 'B202', 'Nhà B', 30),
(5, 'C301', 'Nhà C', 60);

-- ---------------------------------------------------------------------
-- 7. KỲ THI (2 bản ghi)
-- ---------------------------------------------------------------------
INSERT INTO ky_thi (id, ten_ky_thi, hoc_ky, nam_hoc, ngay_bat_dau, ngay_ket_thuc) VALUES
(1, 'Thi kết thúc học phần HK1 năm học 2025-2026', 'HK1', '2025-2026', '2026-01-05', '2026-01-16'),
(2, 'Thi kết thúc học phần HK2 năm học 2025-2026', 'HK2', '2025-2026', '2026-06-01', '2026-06-12');

-- ---------------------------------------------------------------------
-- 8. CA THI (10 bản ghi: 6 ca kỳ 1, 4 ca kỳ 2)
-- Cột: id, ma_ca_thi, ky_thi_id, hoc_phan_id, phong_thi_id, ngay, giờ BĐ, giờ KT
-- ---------------------------------------------------------------------
INSERT INTO ca_thi (id, ma_ca_thi, ky_thi_id, hoc_phan_id, phong_thi_id, ngay_thi, gio_bat_dau, gio_ket_thuc) VALUES
(1,  'CT001', 1, 1, 1, '2026-01-05', '07:30:00', '09:30:00'),  -- CSDL, A101
(2,  'CT002', 1, 1, 2, '2026-01-05', '07:30:00', '09:30:00'),  -- CSDL, A102 (ca thứ 2 cùng học phần)
(3,  'CT003', 1, 3, 1, '2026-01-05', '13:30:00', '15:30:00'),  -- Giải tích 1
(4,  'CT004', 1, 4, 3, '2026-01-06', '07:30:00', '09:30:00'),  -- Kinh tế vi mô
(5,  'CT005', 1, 5, 4, '2026-01-06', '09:45:00', '11:45:00'),  -- Tiếng Anh 2
(6,  'CT006', 1, 2, 1, '2026-01-07', '07:30:00', '09:30:00'),  -- LTHĐT
(7,  'CT007', 2, 6, 1, '2026-06-02', '07:30:00', '09:30:00'),  -- XSTK ca sáng
(8,  'CT008', 2, 7, 2, '2026-06-02', '07:30:00', '09:30:00'),  -- Mạng máy tính
(9,  'CT009', 2, 8, 3, '2026-06-03', '13:30:00', '15:30:00'),  -- Nguyên lý kế toán
(10, 'CT010', 2, 6, 1, '2026-06-02', '13:30:00', '15:30:00');  -- XSTK ca chiều

-- ---------------------------------------------------------------------
-- 9. ĐỀ THI (20 bản ghi: mỗi ca có đề A và đề B)
-- id = 2*ca-1 là đề A, id = 2*ca là đề B
-- ---------------------------------------------------------------------
INSERT INTO de_thi (id, ca_thi_id, ma_de) VALUES
(1,  1,  'A'), (2,  1,  'B'),
(3,  2,  'A'), (4,  2,  'B'),
(5,  3,  'A'), (6,  3,  'B'),
(7,  4,  'A'), (8,  4,  'B'),
(9,  5,  'A'), (10, 5,  'B'),
(11, 6,  'A'), (12, 6,  'B'),
(13, 7,  'A'), (14, 7,  'B'),
(15, 8,  'A'), (16, 8,  'B'),
(17, 9,  'A'), (18, 9,  'B'),
(19, 10, 'A'), (20, 10, 'B');

-- ---------------------------------------------------------------------
-- 10. GIÁM THỊ (21 bản ghi, mỗi ca >= 2 giám thị, không trùng giờ)
-- Cột: id, ca_thi_id, giang_vien_id, vai_tro
-- ---------------------------------------------------------------------
INSERT INTO giam_thi (id, ca_thi_id, giang_vien_id, vai_tro) VALUES
(1,  1,  1, 'giam_thi_1'),
(2,  1,  2, 'giam_thi_2'),
(3,  2,  3, 'giam_thi_1'),
(4,  2,  4, 'giam_thi_2'),
(5,  3,  5, 'giam_thi_1'),
(6,  3,  7, 'giam_thi_2'),
(7,  3,  1, 'giam_thi_phu'),
(8,  4,  4, 'giam_thi_1'),
(9,  4,  5, 'giam_thi_2'),
(10, 5,  6, 'giam_thi_1'),
(11, 5,  8, 'giam_thi_2'),
(12, 6,  2, 'giam_thi_1'),
(13, 6,  3, 'giam_thi_2'),
(14, 7,  1, 'giam_thi_1'),
(15, 7,  7, 'giam_thi_2'),
(16, 8,  2, 'giam_thi_1'),
(17, 8,  3, 'giam_thi_2'),
(18, 9,  4, 'giam_thi_1'),
(19, 9,  5, 'giam_thi_2'),
(20, 10, 8, 'giam_thi_1'),
(21, 10, 6, 'giam_thi_2');

-- ---------------------------------------------------------------------
-- 11. ĐĂNG KÝ THI (52 bản ghi)
-- Cột: id, sinh_vien_id, ky_thi_id, hoc_phan_id, ca_thi_id, so_bao_danh, de_thi_id
-- ---------------------------------------------------------------------
INSERT INTO dang_ky_thi (id, sinh_vien_id, ky_thi_id, hoc_phan_id, ca_thi_id, so_bao_danh, de_thi_id) VALUES
-- Ca 1: CSDL, A101
(1,  1,  1, 1, 1, 'CT001-01', 1),
(2,  2,  1, 1, 1, 'CT001-02', 2),
(3,  3,  1, 1, 1, 'CT001-03', 1),
(4,  4,  1, 1, 1, 'CT001-04', 2),
(5,  5,  1, 1, 1, 'CT001-05', 1),
-- Ca 2: CSDL, A102
(6,  6,  1, 1, 2, 'CT002-01', 3),
(7,  7,  1, 1, 2, 'CT002-02', 4),
(8,  8,  1, 1, 2, 'CT002-03', 3),
-- Ca 3: Giải tích 1, A101 chiều
(9,  1,  1, 3, 3, 'CT003-01', 5),
(10, 2,  1, 3, 3, 'CT003-02', 6),
(11, 3,  1, 3, 3, 'CT003-03', 5),
(12, 4,  1, 3, 3, 'CT003-04', 6),
(13, 5,  1, 3, 3, 'CT003-05', 5),
(14, 6,  1, 3, 3, 'CT003-06', 6),
(15, 7,  1, 3, 3, 'CT003-07', 5),
(16, 8,  1, 3, 3, 'CT003-08', 6),
-- Ca 4: Kinh tế vi mô, B201
(17, 9,  1, 4, 4, 'CT004-01', 7),
(18, 10, 1, 4, 4, 'CT004-02', 8),
(19, 11, 1, 4, 4, 'CT004-03', 7),
(20, 12, 1, 4, 4, 'CT004-04', 8),
(21, 13, 1, 4, 4, 'CT004-05', 7),
-- Ca 5: Tiếng Anh 2, B202
(22, 1,  1, 5, 5, 'CT005-01', 9),
(23, 2,  1, 5, 5, 'CT005-02', 10),
(24, 9,  1, 5, 5, 'CT005-03', 9),
(25, 10, 1, 5, 5, 'CT005-04', 10),
(26, 14, 1, 5, 5, 'CT005-05', 9),
(27, 15, 1, 5, 5, 'CT005-06', 10),
-- Ca 6: LTHĐT, A101
(28, 1,  1, 2, 6, 'CT006-01', 11),
(29, 2,  1, 2, 6, 'CT006-02', 12),
(30, 3,  1, 2, 6, 'CT006-03', 11),
(31, 6,  1, 2, 6, 'CT006-04', 12),
(32, 7,  1, 2, 6, 'CT006-05', 11),
(33, 8,  1, 2, 6, 'CT006-06', 12),
-- Ca 7: XSTK sáng, A101 (kỳ 2)
(34, 1,  2, 6, 7, 'CT007-01', 13),
(35, 2,  2, 6, 7, 'CT007-02', 14),
(36, 3,  2, 6, 7, 'CT007-03', 13),
(37, 9,  2, 6, 7, 'CT007-04', 14),
(38, 10, 2, 6, 7, 'CT007-05', 13),
-- Ca 8: Mạng máy tính, A102
(39, 4,  2, 7, 8, 'CT008-01', 15),
(40, 5,  2, 7, 8, 'CT008-02', 16),
(41, 6,  2, 7, 8, 'CT008-03', 15),
(42, 7,  2, 7, 8, 'CT008-04', 16),
-- Ca 9: Nguyên lý kế toán, B201
(43, 9,  2, 8, 9, 'CT009-01', 17),
(44, 10, 2, 8, 9, 'CT009-02', 18),
(45, 11, 2, 8, 9, 'CT009-03', 17),
(46, 12, 2, 8, 9, 'CT009-04', 18),
(47, 13, 2, 8, 9, 'CT009-05', 17),
-- Ca 10: XSTK chiều, A101
(48, 11, 2, 6, 10, 'CT010-01', 19),
(49, 12, 2, 6, 10, 'CT010-02', 20),
(50, 13, 2, 6, 10, 'CT010-03', 19),
(51, 14, 2, 6, 10, 'CT010-04', 20),
(52, 15, 2, 6, 10, 'CT010-05', 19);

-- ---------------------------------------------------------------------
-- 12. KẾT QUẢ THI (52 bản ghi, 1-1 với đăng ký thi)
-- Cột: dang_ky_thi_id, tinh_trang, diem_thi, diem_bi_tru, da_huy_ket_qua
-- Vắng: 5, 13, 25, 33, 47, 52 | Đình chỉ: 15, 38 | Bị huỷ kết quả: 26
-- ---------------------------------------------------------------------
INSERT INTO ket_qua_thi (dang_ky_thi_id, tinh_trang, diem_thi, diem_bi_tru, da_huy_ket_qua) VALUES
(1,  'co_mat',         8.00, 0.00, 0),
(2,  'co_mat',         7.50, 0.00, 0),
(3,  'co_mat',         6.00, 0.00, 0),
(4,  'co_mat',         6.50, 0.00, 0),
(5,  'vang_thi',       NULL, 0.00, 0),
(6,  'co_mat',         9.00, 0.00, 0),
(7,  'co_mat',         7.00, 1.00, 0),
(8,  'co_mat',         5.50, 0.00, 0),
(9,  'co_mat',         7.00, 0.00, 0),
(10, 'co_mat',         8.50, 0.00, 0),
(11, 'co_mat',         6.50, 0.00, 0),
(12, 'co_mat',         4.50, 0.00, 0),
(13, 'vang_thi',       NULL, 0.00, 0),
(14, 'co_mat',         7.50, 0.00, 0),
(15, 'bi_dinh_chi_thi', NULL, 0.00, 0),
(16, 'co_mat',         8.00, 0.00, 0),
(17, 'co_mat',         6.50, 0.00, 0),
(18, 'co_mat',         7.00, 0.00, 0),
(19, 'co_mat',         8.00, 0.00, 0),
(20, 'co_mat',         6.00, 1.50, 0),
(21, 'co_mat',         5.00, 0.00, 0),
(22, 'co_mat',         9.00, 0.00, 0),
(23, 'co_mat',         8.00, 0.00, 0),
(24, 'co_mat',         7.50, 0.00, 0),
(25, 'vang_thi',       NULL, 0.00, 0),
(26, 'co_mat',         5.50, 0.00, 1),
(27, 'co_mat',         6.50, 0.00, 0),
(28, 'co_mat',         7.00, 0.00, 0),
(29, 'co_mat',         8.50, 0.00, 0),
(30, 'co_mat',         6.00, 0.00, 0),
(31, 'co_mat',         7.50, 0.00, 0),
(32, 'co_mat',         5.00, 0.00, 0),
(33, 'vang_thi',       NULL, 0.00, 0),
(34, 'co_mat',         8.50, 0.00, 0),
(35, 'co_mat',         7.00, 0.00, 0),
(36, 'co_mat',         6.00, 0.00, 0),
(37, 'co_mat',         7.50, 0.00, 0),
(38, 'bi_dinh_chi_thi', NULL, 0.00, 0),
(39, 'co_mat',         6.50, 0.00, 0),
(40, 'co_mat',         8.00, 0.00, 0),
(41, 'co_mat',         7.50, 0.00, 0),
(42, 'co_mat',         9.00, 0.00, 0),
(43, 'co_mat',         7.00, 0.00, 0),
(44, 'co_mat',         6.50, 0.00, 0),
(45, 'co_mat',         8.00, 0.00, 0),
(46, 'co_mat',         5.50, 0.00, 0),
(47, 'vang_thi',       NULL, 0.00, 0),
(48, 'co_mat',         7.00, 0.00, 0),
(49, 'co_mat',         6.00, 0.00, 0),
(50, 'co_mat',         8.50, 0.00, 0),
(51, 'co_mat',         7.50, 0.00, 0),
(52, 'vang_thi',       NULL, 0.00, 0);

-- ---------------------------------------------------------------------
-- 13. VI PHẠM (7 bản ghi; giám thị lập biên bản thuộc đúng ca thi)
-- Cột: id, dang_ky_thi_id, giam_thi_id, hinh_thuc, muc_xu_ly, diem_tru, mo_ta
-- ---------------------------------------------------------------------
INSERT INTO vi_pham (id, dang_ky_thi_id, giam_thi_id, hinh_thuc, muc_xu_ly, diem_tru, mo_ta) VALUES
(1, 4,  1,  'Mang tài liệu vào phòng thi',      'khien_trach', NULL, 'Mang một tờ ghi chú nhưng chưa sử dụng'),
(2, 7,  3,  'Trao đổi bài với thí sinh bên cạnh', 'tru_diem',    1.00, 'Bị nhắc nhở hai lần, trừ 1 điểm'),
(3, 15, 5,  'Sử dụng thiết bị điện tử',          'dinh_chi_thi', NULL, 'Dùng điện thoại tra cứu trong giờ thi'),
(4, 20, 8,  'Trao đổi bài với thí sinh bên cạnh', 'tru_diem',    1.50, 'Trao đổi bài nhiều lần'),
(5, 26, 10, 'Mang tài liệu vào phòng thi',       'huy_ket_qua',  NULL, 'Chép tài liệu trực tiếp vào bài làm'),
(6, 41, 16, 'Mang tài liệu vào phòng thi',       'khien_trach',  NULL, 'Để tài liệu dưới gầm bàn'),
(7, 38, 14, 'Sử dụng thiết bị điện tử',          'dinh_chi_thi', NULL, 'Dùng đồng hồ thông minh nhận tin nhắn');

-- ---------------------------------------------------------------------
-- 14. CẤU HÌNH THÙ LAO (2 bản ghi)
-- Thù lao 1 ca = don_gia * (1 + hệ số học vị Tiến sỹ trở lên + hệ số giám thị 1)
-- ---------------------------------------------------------------------
INSERT INTO cau_hinh_thu_lao
  (id, ky_thi_id, don_gia_ca_thi, he_so_tien_si, he_so_pho_giao_su, he_so_giao_su, he_so_giam_thi_1, hieu_luc_tu) VALUES
(1, 1, 150000, 0.20, 0.20, 0.20, 0.10, '2026-01-01'),
(2, 2, 150000, 0.20, 0.20, 0.20, 0.10, '2026-06-01');

-- ---------------------------------------------------------------------
-- 15. KIỂM TRA SỐ BẢN GHI SAU KHI CHÈN
-- ---------------------------------------------------------------------
SELECT 'khoa' AS bang, COUNT(*) AS so_ban_ghi FROM khoa
UNION ALL SELECT 'lop', COUNT(*) FROM lop
UNION ALL SELECT 'sinh_vien', COUNT(*) FROM sinh_vien
UNION ALL SELECT 'giang_vien', COUNT(*) FROM giang_vien
UNION ALL SELECT 'hoc_phan', COUNT(*) FROM hoc_phan
UNION ALL SELECT 'phong_thi', COUNT(*) FROM phong_thi
UNION ALL SELECT 'ky_thi', COUNT(*) FROM ky_thi
UNION ALL SELECT 'ca_thi', COUNT(*) FROM ca_thi
UNION ALL SELECT 'de_thi', COUNT(*) FROM de_thi
UNION ALL SELECT 'giam_thi', COUNT(*) FROM giam_thi
UNION ALL SELECT 'dang_ky_thi', COUNT(*) FROM dang_ky_thi
UNION ALL SELECT 'ket_qua_thi', COUNT(*) FROM ket_qua_thi
UNION ALL SELECT 'vi_pham', COUNT(*) FROM vi_pham
UNION ALL SELECT 'cau_hinh_thu_lao', COUNT(*) FROM cau_hinh_thu_lao;

-- ---------------------------------------------------------------------
-- 16. THỬ CÁC TRIGGER (bỏ comment từng câu để xem báo lỗi như mong đợi)
-- ---------------------------------------------------------------------
-- (a) Giảng viên 1 đã coi CT001 (05/01 07:30-09:30), thêm vào CT002 cùng giờ -> lỗi trùng giờ
-- INSERT INTO giam_thi (ca_thi_id, giang_vien_id, vai_tro) VALUES (2, 1, 'giam_thi_phu');

-- (b) Sinh viên 1 đã thi CT001, xếp thêm vào CT002 cùng giờ -> lỗi trùng giờ
-- INSERT INTO dang_ky_thi (sinh_vien_id, ky_thi_id, hoc_phan_id, ca_thi_id, so_bao_danh, de_thi_id)
-- VALUES (1, 1, 1, 2, 'CT002-99', 3);

-- (c) Xếp ca thi vào phòng A101 trùng giờ với CT001 -> lỗi phòng trùng giờ
-- INSERT INTO ca_thi (ma_ca_thi, ky_thi_id, hoc_phan_id, phong_thi_id, ngay_thi, gio_bat_dau, gio_ket_thuc)
-- VALUES ('CT099', 1, 2, 1, '2026-01-05', '08:00:00', '10:00:00');
