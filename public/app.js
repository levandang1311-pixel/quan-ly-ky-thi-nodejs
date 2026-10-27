const views = {
  students: {
    title: "Danh sách sinh viên",
    description: "Tìm theo mã sinh viên, họ tên hoặc lớp.",
    endpoint: "/api/students",
    columns: [["ma_sv","Mã sinh viên"],["ho_ten","Họ tên"],["ngay_sinh","Ngày sinh"],["ten_lop","Lớp"],["ten_khoa","Khoa"]],
    search: true
  },
  exams: {
    title: "Lịch thi",
    description: "Danh sách ca thi, phòng thi và số lượng sinh viên đã đăng ký.",
    endpoint: "/api/exams",
    columns: [["ma_ca_thi","Mã ca"],["ten_ky_thi","Kỳ thi"],["ma_hoc_phan","Mã học phần"],["ten_hoc_phan","Học phần"],["ma_phong","Phòng"],["ngay_thi","Ngày thi"],["gio_bat_dau","Bắt đầu"],["gio_ket_thuc","Kết thúc"],["so_sinh_vien","Số SV"]]
  },
  results: {
    title: "Kết quả thi",
    description: "Điểm sau xử lý được tính theo điểm thi trừ điểm bị trừ; kết quả hủy hoặc vắng thi không hiển thị điểm.",
    endpoint: "/api/results",
    columns: [["ma_sv","Mã SV"],["ho_ten","Họ tên"],["ma_hoc_phan","Mã học phần"],["ten_hoc_phan","Học phần"],["ma_ca_thi","Ca thi"],["tinh_trang","Tình trạng"],["diem_thi","Điểm gốc"],["diem_bi_tru","Điểm trừ"],["diem_sau_xu_ly","Điểm sau xử lý"],["da_huy_ket_qua","Đã hủy"]]
  },
  courses: {
    title: "Danh sách học phần",
    description: "Mã học phần, tên học phần, số tín chỉ và khoa quản lý.",
    endpoint: "/api/courses",
    columns: [["ma_hoc_phan","Mã học phần"],["ten_hoc_phan","Tên học phần"],["so_tin_chi","Tín chỉ"],["ten_khoa","Khoa quản lý"]]
  }
};

let currentView = "students";
let currentRows = [];
const $ = (selector) => document.querySelector(selector);

function safe(value) {
  if (value === null || value === undefined || value === "") return "—";
  return String(value).replaceAll("&","&amp;").replaceAll("<","&lt;").replaceAll(">","&gt;").replaceAll('"',"&quot;").replaceAll("'","&#039;");
}
function pretty(key, value) {
  if (key === "ngay_sinh" || key === "ngay_thi") {
    const d = new Date(value);
    if (!Number.isNaN(d.getTime())) return d.toLocaleDateString("vi-VN", {timeZone:"UTC"});
  }
  if (["gio_bat_dau","gio_ket_thuc"].includes(key) && value) return String(value).slice(0,5);
  if (key === "tinh_trang") return ({co_mat:"Có mặt",vang_thi:"Vắng thi",bi_dinh_chi_thi:"Bị đình chỉ"})[value] || value;
  if (key === "da_huy_ket_qua") return Number(value) === 1 ? "Có" : "Không";
  if (["diem_thi","diem_bi_tru","diem_sau_xu_ly"].includes(key) && value !== null && value !== undefined) return Number(value).toFixed(2);
  return safe(value);
}
async function loadHealth() {
  try {
    const response = await fetch("/api/health");
    const data = await response.json();
    $("#dbStatus").textContent = data.database === "connected" ? "● MySQL đã kết nối" : "● Chưa kết nối MySQL";
    $("#dbStatus").style.background = data.database === "connected" ? "#dcfce7" : "#fee2e2";
    $("#dbStatus").style.color = data.database === "connected" ? "#166534" : "#991b1b";
  } catch {
    $("#dbStatus").textContent = "Không kiểm tra được máy chủ";
  }
}
async function loadStats() {
  try {
    const response = await fetch("/api/dashboard");
    const rows = await response.json();
    if (!response.ok) throw new Error(rows.message || "Lỗi tải thống kê");
    $("#stats").innerHTML = rows.map(row => `<div class="stat"><span>${safe(row.label)}</span><strong>${safe(row.total)}</strong></div>`).join("");
  } catch {
    $("#stats").innerHTML = `<div class="stat"><span>Trạng thái</span><strong>—</strong></div>`;
  }
}
function renderTable() {
  const config = views[currentView];
  const query = $("#search").value.trim().toLocaleLowerCase("vi");
  const rows = currentView === "students" && query
    ? currentRows.filter(row => [row.ma_sv,row.ho_ten,row.ten_lop].some(v => String(v || "").toLocaleLowerCase("vi").includes(query)))
    : currentRows;
  $("#tableHead").innerHTML = `<tr>${config.columns.map(([,label]) => `<th>${safe(label)}</th>`).join("")}</tr>`;
  if (!rows.length) {
    $("#tableBody").innerHTML = `<tr><td class="empty" colspan="${config.columns.length}">Không có dữ liệu để hiển thị.</td></tr>`;
    return;
  }
  $("#tableBody").innerHTML = rows.map(row => `<tr>${config.columns.map(([key]) => `<td>${pretty(key,row[key])}</td>`).join("")}</tr>`).join("");
}
async function loadView(view) {
  currentView = view;
  const config = views[view];
  $("#viewTitle").textContent = config.title;
  $("#viewDescription").textContent = config.description;
  $("#search").hidden = !config.search;
  $("#search").value = "";
  document.querySelectorAll(".tab").forEach(button => button.classList.toggle("active", button.dataset.view === view));
  $("#message").hidden = true;
  $("#tableBody").innerHTML = `<tr><td>Đang tải dữ liệu…</td></tr>`;
  try {
    const response = await fetch(config.endpoint);
    const data = await response.json();
    if (!response.ok) throw new Error(data.message || "Có lỗi xảy ra");
    currentRows = data;
    renderTable();
  } catch (error) {
    currentRows = [];
    $("#tableHead").innerHTML = "";
    $("#tableBody").innerHTML = "";
    $("#message").textContent = `${error.message}. Hãy kiểm tra MySQL và file .env.`;
    $("#message").hidden = false;
  }
}
document.querySelectorAll(".tab").forEach(button => button.addEventListener("click", () => loadView(button.dataset.view)));
$("#search").addEventListener("input", renderTable);
loadHealth();
loadStats();
loadView("students");
