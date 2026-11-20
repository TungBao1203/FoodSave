
# FoodSave — Firestore Schema

## 1. Collections

### users/{userId}
- displayName: string
- email: string
- photoUrl: string?
- createdAt: timestamp

### families/{familyId}
- name: string
- ownerId: string
- isPremium: boolean
- createdAt: timestamp

### families/{familyId}/members/{userId}
- role: owner | member
- joinedAt: timestamp

### families/{familyId}/foods/{foodId}
- name: string
- category: string
- storageLocation: string (fridge | freezer | pantry)
- quantity: number
- unit: string
- expiryDate: timestamp?
- addedDate: timestamp
- imageUrl: string?
- notes: string?
- addedBy: string

### families/{familyId}/invites/{inviteId}
- createdBy: string
- codeHash: string
- expiresAt: timestamp
- maxUses: number
- usedCount: number

## 2. Business Rules

1. Chỉ thành viên gia đình được xem tủ lạnh.
2. Thành viên có quyền phù hợp được thêm, sửa, xóa thực phẩm.
3. AI không tự động lưu kết quả chưa xác nhận.
4. Hạn sử dụng được tính từ expiryDate.
5. Thực phẩm đã hết hạn vẫn được lưu để người dùng xử lý.
6. Mã mời có thời hạn và giới hạn lượt sử dụng.
7. Các thao tác dùng chung phải có kiểm tra quyền phía backend.

## 3. Integration

Member 1:
- Firebase Authentication
- Home Dashboard
- User Profile

Member 2:
- FoodModel
- FoodRepository
- AI Scanner
- Fridge Management

Member 3:
- Family Membership
- Recipe Suggestions
- Invite Management
- Premium UI

## 4. Notes

- Đây là schema dự kiến, chưa triển khai.
- Firestore Repository sẽ được bổ sung sau.
- Firestore Security Rules phải kiểm tra quyền truy cập.
- Các thay đổi schema cần được cả nhóm review.
