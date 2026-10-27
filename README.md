# Hệ thống quản lý kỳ thi kết thúc học phần

Ứng dụng bài tập lớn Cơ sở dữ liệu, xây dựng bằng **Node.js + Express + MySQL**. Dùng hai tệp SQL gốc `database.sql` và `seed.sql` để tạo cơ sở dữ liệu và dữ liệu mẫu.

## Chức năng

- Trang tổng quan: thống kê số sinh viên, giảng viên, học phần, kỳ thi, ca thi và đăng ký thi.
- Danh sách sinh viên: tìm theo mã sinh viên, họ tên hoặc lớp.
- Lịch thi: xem kỳ thi, học phần, phòng, thời gian và số sinh viên đăng ký.
- Kết quả thi: xem tình trạng, điểm thi, điểm trừ và điểm sau xử lý.
- Danh sách học phần.
- API kiểm tra kết nối MySQL tại `/api/health`.

## Công nghệ

- Node.js
- Express
- MySQL 8.0.16+
- mysql2/promise
- HTML, CSS, JavaScript thuần

## 1. Cài đặt yêu cầu

Cài Node.js bản LTS và MySQL 8.0.16 trở lên. Có thể dùng MySQL Workbench để chạy SQL.

## 2. Tạo cơ sở dữ liệu

Mở MySQL Workbench, chạy toàn bộ `database.sql` trước, sau đó chạy toàn bộ `seed.sql`.

> Lưu ý: `database.sql` có lệnh `DROP DATABASE IF EXISTS quan_ly_ky_thi`, vì vậy chạy lại tệp này sẽ xóa và tạo lại cơ sở dữ liệu cùng toàn bộ dữ liệu cũ.

## 3. Cấu hình kết nối

Tại thư mục dự án, sao chép `.env.example` thành `.env`, rồi điền mật khẩu MySQL của máy bạn:

```env
DB_HOST=localhost
DB_PORT=3306
DB_USER=root
DB_PASSWORD=mat_khau_mysql_cua_ban
DB_NAME=quan_ly_ky_thi
PORT=3000
```

Không tải file `.env` lên GitHub. File này đã được thêm vào `.gitignore`.

## 4. Chạy chương trình

Mở Terminal/CMD tại thư mục dự án và chạy:

```bash
npm install
npm start
```

Mở trình duyệt tại <http://localhost:3000>.

Chạy chế độ tự khởi động lại khi sửa mã:

```bash
npm run dev
```

## 5. API

| Phương thức | Đường dẫn | Mô tả |
|---|---|---|
| GET | `/api/health` | Kiểm tra kết nối MySQL |
| GET | `/api/dashboard` | Thống kê tổng quan |
| GET | `/api/students?q=An` | Tìm kiếm sinh viên |
| GET | `/api/exams` | Danh sách lịch thi |
| GET | `/api/results` | Kết quả thi |
| GET | `/api/courses` | Danh sách học phần |

## 6. Đưa dự án lên GitHub

1. Tạo repository mới trên GitHub, ví dụ `quan-ly-ky-thi-nodejs`.
2. Mở Terminal tại thư mục dự án.
3. Chạy:

```bash
git init
git add .
git commit -m "Initial commit: quan ly ky thi bang Node.js"
git branch -M main
git remote add origin https://github.com/TEN_TAI_KHOAN/quan-ly-ky-thi-nodejs.git
git push -u origin main
```

Thay `TEN_TAI_KHOAN` bằng tên tài khoản GitHub của bạn. Nếu Git báo đã tồn tại remote `origin`, dùng `git remote set-url origin URL_REPOSITORY`.

## Cấu trúc thư mục

```text
quan-ly-ky-thi-nodejs/
├── public/
│   ├── app.js
│   ├── index.html
│   └── style.css
├── .env.example
├── .gitignore
├── database.sql
├── seed.sql
├── package.json
├── README.md
└── server.js
```

## Lưu ý

- Đây là bản demo học tập, chưa có đăng nhập/phân quyền người dùng và chưa có chức năng thêm/sửa/xóa dữ liệu từ giao diện.
- Dữ liệu mẫu trong `seed.sql` được giữ theo tệp SQL bạn cung cấp.
- Không đưa mật khẩu, dữ liệu cá nhân thật hoặc thông tin bí mật vào repository công khai.
