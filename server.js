require("dotenv").config();
const express = require("express");
const mysql = require("mysql2/promise");
const path = require("path");

const app = express();
const PORT = Number(process.env.PORT || 3000);

app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(express.static(path.join(__dirname, "public")));

const pool = mysql.createPool({
  host: process.env.DB_HOST || "localhost",
  port: Number(process.env.DB_PORT || 3306),
  user: process.env.DB_USER || "root",
  password: process.env.DB_PASSWORD || "",
  database: process.env.DB_NAME || "quan_ly_ky_thi",
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0,
  charset: "utf8mb4"
});

app.get("/api/health", async (req, res) => {
  try {
    const [rows] = await pool.query("SELECT 1 AS database_connected");
    res.json({ status: "ok", database: rows[0].database_connected === 1 ? "connected" : "unknown" });
  } catch (error) {
    res.status(500).json({ status: "error", message: "Không kết nối được MySQL. Hãy kiểm tra file .env và dịch vụ MySQL." });
  }
});

app.get("/api/dashboard", async (req, res) => {
  try {
    const [rows] = await pool.query(`
      SELECT 'Sinh viên' AS label, COUNT(*) AS total FROM sinh_vien
      UNION ALL SELECT 'Giảng viên', COUNT(*) FROM giang_vien
      UNION ALL SELECT 'Học phần', COUNT(*) FROM hoc_phan
      UNION ALL SELECT 'Kỳ thi', COUNT(*) FROM ky_thi
      UNION ALL SELECT 'Ca thi', COUNT(*) FROM ca_thi
      UNION ALL SELECT 'Đăng ký thi', COUNT(*) FROM dang_ky_thi
    `);
    res.json(rows);
  } catch (error) {
    res.status(500).json({ message: "Không tải được thống kê.", detail: error.message });
  }
});

app.get("/api/students", async (req, res) => {
  const keyword = `%${String(req.query.q || "").trim()}%`;
  try {
    const [rows] = await pool.execute(`
      SELECT sv.id, sv.ma_sv, sv.ho_ten, sv.ngay_sinh, l.ten_lop, k.ten_khoa
      FROM sinh_vien sv
      JOIN lop l ON l.id = sv.lop_id
      JOIN khoa k ON k.id = sv.khoa_id
      WHERE sv.ma_sv LIKE ? OR sv.ho_ten LIKE ? OR l.ten_lop LIKE ?
      ORDER BY sv.id
      LIMIT 200
    `, [keyword, keyword, keyword]);
    res.json(rows);
  } catch (error) {
    res.status(500).json({ message: "Không tải được danh sách sinh viên.", detail: error.message });
  }
});

app.get("/api/exams", async (req, res) => {
  try {
    const [rows] = await pool.query(`
      SELECT c.id, c.ma_ca_thi, kt.ten_ky_thi, hp.ma_hoc_phan, hp.ten_hoc_phan,
             p.ma_phong, c.ngay_thi, c.gio_bat_dau, c.gio_ket_thuc,
             COUNT(dkt.id) AS so_sinh_vien
      FROM ca_thi c
      JOIN ky_thi kt ON kt.id = c.ky_thi_id
      JOIN hoc_phan hp ON hp.id = c.hoc_phan_id
      JOIN phong_thi p ON p.id = c.phong_thi_id
      LEFT JOIN dang_ky_thi dkt ON dkt.ca_thi_id = c.id
      GROUP BY c.id, c.ma_ca_thi, kt.ten_ky_thi, hp.ma_hoc_phan, hp.ten_hoc_phan,
               p.ma_phong, c.ngay_thi, c.gio_bat_dau, c.gio_ket_thuc
      ORDER BY c.ngay_thi, c.gio_bat_dau
    `);
    res.json(rows);
  } catch (error) {
    res.status(500).json({ message: "Không tải được lịch thi.", detail: error.message });
  }
});

app.get("/api/results", async (req, res) => {
  try {
    const [rows] = await pool.query(`
      SELECT sv.ma_sv, sv.ho_ten, hp.ma_hoc_phan, hp.ten_hoc_phan,
             c.ma_ca_thi, kq.tinh_trang, kq.diem_thi, kq.diem_bi_tru,
             kq.da_huy_ket_qua,
             CASE
               WHEN kq.tinh_trang <> 'co_mat' OR kq.da_huy_ket_qua = 1 OR kq.diem_thi IS NULL THEN NULL
               ELSE GREATEST(kq.diem_thi - kq.diem_bi_tru, 0)
             END AS diem_sau_xu_ly
      FROM ket_qua_thi kq
      JOIN dang_ky_thi dkt ON dkt.id = kq.dang_ky_thi_id
      JOIN sinh_vien sv ON sv.id = dkt.sinh_vien_id
      JOIN hoc_phan hp ON hp.id = dkt.hoc_phan_id
      JOIN ca_thi c ON c.id = dkt.ca_thi_id
      ORDER BY sv.ma_sv, hp.ma_hoc_phan
      LIMIT 500
    `);
    res.json(rows);
  } catch (error) {
    res.status(500).json({ message: "Không tải được kết quả thi.", detail: error.message });
  }
});

app.get("/api/courses", async (req, res) => {
  try {
    const [rows] = await pool.query(`
      SELECT hp.ma_hoc_phan, hp.ten_hoc_phan, hp.so_tin_chi, k.ten_khoa
      FROM hoc_phan hp JOIN khoa k ON k.id = hp.khoa_id
      ORDER BY hp.ma_hoc_phan
    `);
    res.json(rows);
  } catch (error) {
    res.status(500).json({ message: "Không tải được học phần.", detail: error.message });
  }
});

app.get("*", (req, res) => {
  res.sendFile(path.join(__dirname, "public", "index.html"));
});

app.listen(PORT, () => {
  console.log(`Ứng dụng đang chạy tại http://localhost:${PORT}`);
});
