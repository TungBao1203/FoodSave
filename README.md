# FoodSave - Module Thành Viên 3: Món Ăn & Quản Lý Gia Đình

Dự án ứng dụng quản trị thực phẩm và gợi ý nấu ăn thông minh chống lãng phí **FoodSave**.  
Toàn bộ phân hệ của **Thành viên 3** được triển khai hoàn chỉnh bằng **Flutter + Dart** theo chuẩn kiến trúc **MVVM (Model - View - ViewModel)**.

---

## 📱 4 Màn hình phụ trách bởi Thành viên 3

### 1. Màn hình 07 – AI Gợi ý món ăn (`lib/features/suggestions/`)
- **Header**: Logo chiếc lá FoodSave (`AppLeafLogo`), tiêu đề "Gợi ý món ăn", nút Bookmark xem nhanh công thức đã lưu trong BottomSheet.
- **Thanh bộ lọc ngang thông minh**: 
  - Đầy đủ 7 chip: `Tất cả`, `Ưu tiên nấu trước`, `Đủ nguyên liệu`, `< 15 phút`, `< 30 phút`, `< 1 giờ`, `Từ 1h - 2h`.
  - Giữ cố định tọa độ cuộn (`PageStorageKey` + cập nhật in-place), không bị giật hay văng về đầu trang khi bấm chọn chip ở xa.
- **Thuật toán "Ưu tiên nấu trước" (Food Rescue)**:
  - Lọc các món sử dụng nguyên liệu cận date (`expiringIngredientsCount > 0`).
  - Tự động sắp xếp giảm dần theo số nguyên liệu cận date giải cứu được (món cứu 3 nguyên liệu đứng trước món cứu 2 và 1 nguyên liệu).
- **Thẻ Món nổi bật (Hero Card)**: 
  - Thiết kế tràn viền tinh giản, không bị chữ hay huy hiệu ngữ cảnh che khuất ảnh.
  - Đáy thẻ làm nổi bật tên món ăn, thời gian nấu và tình trạng nguyên liệu (`Đủ X nguyên liệu` / `Thiếu X vị`).
- **Banner AI tinh gọn (~45px)**: Thiết kế 1 dòng hiện đại kèm nút `[Tạo ngay]` (đã tối ưu padding không bị mất chân chữ tiếng Việt).
- **Khối "Thêm lựa chọn phù hợp"**:
  - Nút `[Làm mới]` xoay vòng các món ăn (round-robin) không trùng lặp các món đang hiển thị.
  - Thẻ món ăn (`RecipeTileCard`) tối giản: Tên món, thời gian nấu `⏱️ 15 phút`, huy hiệu trạng thái `✓ Đủ nguyên liệu` (xanh) hoặc `🛒 Thiếu X nguyên liệu` (cam).
- **Kho món ăn thực tế**: Hơn 18 món ăn Việt Nam phong phú, chia đều từ món nấu siêu tốc đến các món kho và hầm dinh dưỡng.

---

### 2. Màn hình 08 – Chi tiết công thức (`lib/features/recipe_detail/`)
- **Ảnh món ăn sạch sẽ**: Đã xóa bỏ các huy hiệu và chữ đè lên ảnh, giữ trọn vẹn vẻ tự nhiên, hấp dẫn thị giác.
- **Hàng thông số tinh gọn**: Đã bỏ độ khó, chỉ tập trung vào `⏱️ Thời gian nấu` và `👥 Khẩu phần`.
- **Danh sách nguyên liệu tương tác**:
  - Cho phép người dùng tick/untick kiểm kê khi chuẩn bị nấu.
  - Phân loại trực quan: Nguyên liệu có sẵn (viền xanh tích xanh `✓`), nguyên liệu thiếu (viền cam `🛒 Cần mua`).
- **Hướng dẫn nấu ăn từng bước**: Các bước nấu ăn đánh số thứ tự 1, 2, 3... chi tiết, rõ ràng.
- **Hành động**: Nút "Thêm vào kế hoạch tuần" và nút "Bắt đầu nấu".
- **Khả năng tương thích**: Nhận cả công thức có sẵn trong kho lẫn công thức do AI sinh ra tức thì.

---

### 3. Màn hình 09 – Quản lý gia đình (`lib/features/family/`)
- **Thẻ Hạn ngạch & Thành viên thu gọn (`FamilyGroupCard`)**:
  - Thiết kế thu gọn (Compact & Expandable): Thể hiện nhóm "Nhà mình" đã đạt giới hạn `2/2 người` (gói Miễn phí) kèm các avatar mini. Nhấn vào để mở rộng/thu gọn danh sách chi tiết các thành viên.
  - **Đổi tên nhóm trực tiếp tại Màn 9**: Nút bút chì `[ ✏️ ]` màu xanh ngay cạnh tên nhóm, mở Pop-up đổi tên nhóm nhanh với các gợi ý 1 chạm (`Nhà mình`, `Gia đình nhỏ`, `Tổ ấm thân yêu`, `Bếp ấm`, `Căn bếp vui vẻ`).
- **Danh sách thành viên chi tiết**: Phân định rõ Chủ hộ (Owner) và Thành viên, hỗ trợ xóa thành viên và bảo vệ an toàn cho chủ nhóm.
- **2 Phương thức mời thành viên tinh gọn (`InviteMethodCard`)**:
  - Quét mã QR định danh gia đình (`Icons.qr_code_2_rounded`).
  - Mời trực tiếp qua Số điện thoại (tự động cập nhật thành viên mới vào danh sách khi còn hạn ngạch).
- **BottomSheet Cài đặt chuẩn phân cấp (`FamilySettingsSheet`)**:
  - Mở lên gồm đúng 3 mục tinh gọn: `Thông tin cá nhân`, `Thông tin gia đình`, `Rời nhóm`.
  - **Thông tin cá nhân**: Giao diện sang trọng, không avatar rườm rà; hỗ trợ chỉnh sửa Tên, SĐT, Email với 1 nút bấm duy nhất; tự động đồng bộ tên và chữ cái đại diện ra ngoài danh sách thành viên tức thì.
  - **Thông tin gia đình**: Cung cấp thông tin nhóm và 2 công tắc cài đặt thông báo (thực phẩm mới & cảnh báo cận hạn).
- **Banner Nâng cấp Premium**: Mở khóa không giới hạn thành viên, dẫn trực tiếp sang Màn hình 10.

---

### 4. Màn hình 10 – FoodSave Premium (`lib/features/premium/`)
- **Thẻ Gói Gia đình (Family Plan)**: Thiết kế thẻ pastel tinh giản (`Color(0xFFF3F9F5)`), biểu tượng vương miện hoàng gia vàng kim, thể hiện rõ đặc quyền không giới hạn thành viên và bảo vệ môi trường.
- **Bộ chọn gói xếp dọc trực quan (`PlanSelectorWidget`)**:
  - Gói 1 Năm (Khuyên dùng): `348.000đ / năm` (~ `29.000đ / tháng`), nổi bật với ribbon giảm giá 50% `TIẾT KIỆM 50%`.
  - Gói 1 Tháng: `59.000đ / tháng`.
- **Cam kết quyền lợi & An toàn**: Icon khiên bảo vệ trên AppBar mở BottomSheet với 4 cam kết bảo mật & chính sách hoàn tiền minh bạch (Bảo mật thanh toán, Dùng thử miễn phí, Hoàn tiền 100%, Hỗ trợ 24/7).
- **Bảng so sánh quyền lợi (FREE vs PREMIUM)**: Đối chiếu chi tiết 5 tính năng vượt trội của bản trả phí.
- **Nút hành động CTA & Điều khoản**: Xác nhận dùng thử, tự động kích hoạt gói Premium và đồng bộ trạng thái về Màn 9 ngay khi quay lại.

---

## 🏗️ Cấu trúc thư mục theo chuẩn MVVM

```
lib/
│
├── main.dart                                    # Điểm khởi chạy ứng dụng
│
├── core/
│   ├── theme/
│   │   ├── app_colors.dart                      # Bảng màu chuẩn thiết kế FoodSave
│   │   └── app_theme.dart                       # Cấu hình ThemeData Material 3
│   ├── constants/
│   │   └── app_constants.dart                   # Hằng số ứng dụng
│   └── routes/
│       └── app_routes.dart                      # Định tuyến điều hướng cả 4 màn hình
│
├── data/
│   ├── models/
│   │   ├── food_model.dart                      # Model thực phẩm tủ lạnh
│   │   ├── recipe_model.dart                    # Model công thức & nguyên liệu
│   │   └── family_member_model.dart             # Model nhóm và thành viên gia đình
│   │
│   └── repositories/
│       ├── recipe_repository.dart               # Cung cấp & gợi ý công thức theo tủ lạnh
│       └── family_repository.dart               # Quản lý thành viên & định mức gia đình
│
├── features/
│   ├── suggestions/                             # Màn hình 07: AI gợi ý món ăn
│   │   ├── views/suggestions_screen.dart
│   │   ├── viewmodels/suggestions_viewmodel.dart
│   │   └── widgets/
│   │       ├── ai_priority_banner.dart
│   │       ├── filter_chips_bar.dart
│   │       ├── featured_recipe_card.dart
│   │       └── recipe_tile_card.dart
│   │
│   ├── recipe_detail/                           # Màn hình 08: Chi tiết công thức
│   │   ├── views/recipe_detail_screen.dart
│   │   ├── viewmodels/recipe_detail_viewmodel.dart
│   │   └── widgets/
│   │       ├── recipe_stats_row.dart
│   │       ├── ingredient_item_widget.dart
│   │       └── cooking_step_widget.dart
│   │
│   ├── family/                                  # Màn hình 09: Quản lý gia đình
│   │   ├── views/family_screen.dart
│   │   ├── viewmodels/family_viewmodel.dart
│   │   └── widgets/
│   │       ├── family_group_card.dart
│   │       ├── family_settings_sheet.dart
│   │       ├── member_list_tile.dart
│   │       ├── invite_method_card.dart
│   │       └── upgrade_family_banner.dart
│   │
│   └── premium/                                 # Màn hình 10: FoodSave Premium
│       ├── views/premium_screen.dart
│       ├── viewmodels/premium_viewmodel.dart
│       └── widgets/
│           ├── plan_selector_widget.dart
│           └── feature_comparison_table.dart
│
└── shared/
    └── widgets/
        ├── app_bottom_nav_bar.dart              # Thanh điều hướng mẫu
        └── app_leaf_logo.dart                   # Logo lá xanh FoodSave
```
