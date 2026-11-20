import '../models/recipe_model.dart';
import '../models/food_model.dart';

abstract class IRecipeRepository {
  Future<List<RecipeModel>> getSuggestedRecipes({String? activeFilter});
  Future<RecipeModel?> getFeaturedRecipe({String? activeFilter});
  Future<RecipeModel?> getRecipeById(String id);
  Future<void> toggleBookmark(String id);
  Future<List<RecipeModel>> getBookmarkedRecipes();
  Future<List<RecipeModel>> getSuggestionsBasedOnFridge(List<FoodModel> fridgeFoods);
  Future<RecipeModel> generateAiRecipe({List<FoodModel>? fridgeFoods});
}

class RecipeRepository implements IRecipeRepository {
  static final RecipeRepository _instance = RecipeRepository._internal();
  factory RecipeRepository() => _instance;
  RecipeRepository._internal() {
    _recipes = _getInitialRecipes();
  }

  late List<RecipeModel> _recipes;

  List<RecipeModel> _getInitialRecipes() {
    return [
      const RecipeModel(
        id: 'thit_sot_ca_chua',
        title: 'Thịt sốt cà chua',
        description:
            'Món ăn quốc dân đậm đà đưa cơm, thịt nạc dăm mềm ngọt quyện cùng sốt cà chua sánh mịn chua ngọt thanh tao.',
        imageUrl:
            'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=800&q=80',
        cookTimeMinutes: 25,
        difficulty: 'Dễ',
        servings: 2,
        priorityTag: 'Dùng 3 nguyên liệu cận date',
        isFeatured: true,
        tags: ['Tất cả', '< 30 phút', 'Ưu tiên nấu trước'],
        ingredients: [
          RecipeIngredient(
            name: 'Thịt heo nạc dăm',
            amount: '300 g',
            isAvailable: true,
            isExpiringSoon: true,
          ),
          RecipeIngredient(
            name: 'Cà chua chín mọng',
            amount: '3 quả',
            isAvailable: true,
            isExpiringSoon: true,
          ),
          RecipeIngredient(
            name: 'Hành tím & tỏi băm',
            amount: '2 củ',
            isAvailable: true,
            isExpiringSoon: false,
          ),
          RecipeIngredient(
            name: 'Hành hoa thái nhỏ',
            amount: '3 nhánh',
            isAvailable: true,
            isExpiringSoon: true, // 👈 3 món cận date
          ),
          RecipeIngredient(
            name: 'Hành tây',
            amount: '½ củ',
            isAvailable: false, // 👈 Thiếu
            isExpiringSoon: false,
          ),
        ],
        steps: [
          'Thịt heo rửa nước muối loãng, thái miếng vừa ăn, ướp cùng 1 thìa nước mắm, hành tím băm và chút tiêu xay trong 10 phút.',
          'Cà chua rửa sạch, khía vỏ chần nước sôi lột vỏ hoặc băm nhỏ để khi nấu sốt nhanh nhuyễn mịn.',
          'Phi thơm tỏi băm với dầu ăn, trút thịt vào xào săn trên lửa lớn rồi múc riêng ra đĩa.',
          'Dùng chảo đó xào cà chua cho nhuyễn nát thành sốt sánh, trút thịt vào đảo đều, đậy vung om nhỏ lửa 8 phút cho ngấm sốt.',
          'Rắc hành hoa thái nhỏ và hạt tiêu lên trên, tắt bếp và thưởng thức cùng cơm nóng.',
        ],
      ),
      const RecipeModel(
        id: 'trung_xao_ca_chua',
        title: 'Trứng xào cà chua',
        description:
            'Món ăn tuổi thơ nhanh gọn trong 10 phút, giàu dinh dưỡng và lycopene dồi dào, cực kỳ kích thích vị giác.',
        imageUrl:
            'https://images.unsplash.com/photo-1525351484163-7529414344d8?auto=format&fit=crop&w=600&q=80',
        cookTimeMinutes: 10,
        difficulty: 'Rất dễ',
        servings: 2,
        priorityTag: 'Đủ 100% nguyên liệu',
        tags: ['Tất cả', 'Đủ nguyên liệu', 'Sắp hết hạn', 'Nấu nhanh'],
        ingredients: [
          RecipeIngredient(
            name: 'Trứng gà ta',
            amount: '3 quả',
            isAvailable: true,
            isExpiringSoon: true,
          ),
          RecipeIngredient(
            name: 'Cà chua chín đỏ',
            amount: '2 quả',
            isAvailable: true,
            isExpiringSoon: true,
          ),
          RecipeIngredient(
            name: 'Hành hoa thái nhỏ',
            amount: '2 nhánh',
            isAvailable: true,
            isExpiringSoon: false,
          ),
          RecipeIngredient(
            name: 'Nước mắm & hạt tiêu',
            amount: 'vừa đủ',
            isAvailable: true,
            isExpiringSoon: false,
          ),
        ],
        steps: [
          'Đập 3 quả trứng vào bát, thêm 1 thìa nước mắm ngon và tiêu, dùng đũa đánh tan đều cho sủi bọt nhẹ.',
          'Cà chua rửa sạch, bổ múi cau mỏng.',
          'Đun nóng chảo dầu, đổ trứng vào xào đảo nhẹ tay trên lửa vừa đến khi trứng vừa đông sệt thì trút ra đĩa.',
          'Phi thơm đầu hành, xào cà chua cho mềm nát ra nước sốt đỏ, trút trứng vào đảo nhẹ tay 30 giây cho ngấm sốt, rắc hành lá rồi tắt bếp.',
        ],
      ),
      const RecipeModel(
        id: 'canh_cai_nau_thit',
        title: 'Canh cải bẹ xanh thịt băm',
        description:
            'Bát canh thanh mát giải nhiệt mùa hè, ấm nồng vị gừng tươi hòa quyện vị ngọt tự nhiên của thịt nạc.',
        imageUrl:
            'https://images.unsplash.com/photo-1547592180-85f173990554?auto=format&fit=crop&w=600&q=80',
        cookTimeMinutes: 15,
        difficulty: 'Dễ',
        servings: 2,
        priorityTag: 'Dùng 2 nguyên liệu cận hạn',
        tags: ['Tất cả', 'Sắp hết hạn', 'Nấu nhanh'],
        ingredients: [
          RecipeIngredient(
            name: 'Thịt nạc vai băm',
            amount: '150 g',
            isAvailable: true,
            isExpiringSoon: true,
          ),
          RecipeIngredient(
            name: 'Cải bẹ xanh tươi',
            amount: '1 bó',
            isAvailable: true,
            isExpiringSoon: true,
          ),
          RecipeIngredient(
            name: 'Gừng tươi đập dập',
            amount: '1 nhánh nhỏ',
            isAvailable: false, // 👈 Thiếu
            isExpiringSoon: false,
          ),
          RecipeIngredient(
            name: 'Hành khô & gia vị nêm',
            amount: 'vừa đủ',
            isAvailable: true,
            isExpiringSoon: false,
          ),
        ],
        steps: [
          'Cải bẹ xanh nhặt sạch, rửa từng bẹ rồi ngâm nước muối loãng 10 phút, thái khúc vừa ăn 2cm.',
          'Ướp thịt băm với chút hạt nêm và hành khô băm nhỏ trong 5 phút.',
          'Phi thơm hành tím, trút thịt băm vào xào tơi săn lại.',
          'Đổ 600ml nước lọc vào đun sôi bùng, vớt sạch bọt cho nước trong, thả gừng đập dập vào tạo vị ấm.',
          'Thả rau cải vào nấu sôi lại trong 1-2 phút cho vừa chín tới giữ màu xanh giòn ngọt, nêm nếm vừa ăn rồi tắt bếp.',
        ],
      ),
      const RecipeModel(
        id: 'dau_sot_ca_chua',
        title: 'Đậu hũ sốt cà chua nấm hương',
        description:
            'Món chay thanh đạm giàu đạm thực vật, đậu hũ rán vàng béo ngậy ngập trong nước sốt cà chua sánh đỏ quyện hương nấm.',
        imageUrl:
            'https://images.unsplash.com/photo-1546069901-d7037701da52?auto=format&fit=crop&w=600&q=80',
        cookTimeMinutes: 20,
        difficulty: 'Dễ',
        servings: 2,
        priorityTag: 'Ăn chay thanh đạm',
        tags: ['Tất cả', 'Ăn chay', 'Sắp hết hạn'],
        ingredients: [
          RecipeIngredient(
            name: 'Đậu hũ trắng',
            amount: '3 bìa',
            isAvailable: true,
            isExpiringSoon: false,
          ),
          RecipeIngredient(
            name: 'Cà chua chín mọng',
            amount: '3 quả',
            isAvailable: true,
            isExpiringSoon: true,
          ),
          RecipeIngredient(
            name: 'Nấm hương tươi',
            amount: '50 g',
            isAvailable: false, // 👈 Thiếu
            isExpiringSoon: false,
          ),
          RecipeIngredient(
            name: 'Hành boa-rô & nước tương',
            amount: 'vừa đủ',
            isAvailable: true,
            isExpiringSoon: false,
          ),
        ],
        steps: [
          'Đậu hũ cắt miếng vuông quân cờ vừa ăn, rán vàng sơ hai mặt trên chảo dầu nóng.',
          'Nấm ngâm nở rửa sạch, cà chua băm hạt lựu.',
          'Phi thơm hành boa-rô, cho cà chua và nấm vào xào nhuyễn, thêm 3 thìa nước lọc, 1 thìa nước tương và chút hạt nêm chay thành nước sốt sệt.',
          'Thả đậu hũ vào chảo, lắc nhẹ chảo om nhỏ lửa 5 phút cho sốt ngấm sâu vào từng miếng đậu.',
          'Rắc hành boa-rô cắt nhỏ lên trên và bày ra đĩa thưởng thức nóng.',
        ],
      ),
      const RecipeModel(
        id: 'bo_xao_ot_chuong',
        title: 'Bò xào ớt chuông hành tây',
        description:
            'Thăn bò mềm ngọt xào lửa lớn giữ trọn vị ngọt tự nhiên, kết hợp ớt chuông đỏ vàng giòn ngọt giàu vitamin C.',
        imageUrl:
            'https://images.unsplash.com/photo-1512058564366-18510be2db19?auto=format&fit=crop&w=600&q=80',
        cookTimeMinutes: 15,
        difficulty: 'Dễ',
        servings: 2,
        priorityTag: 'Đủ 100% nguyên liệu',
        tags: ['Tất cả', 'Đủ nguyên liệu', 'Sắp hết hạn', 'Nấu nhanh'],
        ingredients: [
          RecipeIngredient(
            name: 'Thịt thăn bò mềm',
            amount: '250 g',
            isAvailable: true,
            isExpiringSoon: true,
          ),
          RecipeIngredient(
            name: 'Ớt chuông đỏ',
            amount: '2 quả',
            isAvailable: true,
            isExpiringSoon: true,
          ),
          RecipeIngredient(
            name: 'Hành tây giòn',
            amount: '1 củ',
            isAvailable: true,
            isExpiringSoon: false,
          ),
          RecipeIngredient(
            name: 'Tỏi băm & dầu hào',
            amount: 'vừa đủ',
            isAvailable: true,
            isExpiringSoon: false,
          ),
        ],
        steps: [
          'Thịt bò thái mỏng ngang thớ, ướp cùng 1 thìa dầu hào, tỏi băm, tiêu và nửa thìa dầu ăn trong 10 phút để thịt mềm mọng.',
          'Ớt chuông bỏ hạt cắt miếng vuông, hành tây bổ múi cau.',
          'Đun chảo thật nóng, phi tỏi thơm rồi trút thịt bò vào đảo nhanh tay trên lửa lớn trong 1 phút đến khi vừa chín tái thì đổ ra đĩa riêng.',
          'Dùng lại chảo xào ớt chuông và hành tây trên lửa lớn 2 phút cho chín giòn, nêm chút dầu hào.',
          'Trút thịt bò trở lại đảo đều 30 giây cho hòa quyện rồi tắt bếp, rắc tiêu đen xay thưởng thức ngay.',
        ],
      ),
      const RecipeModel(
        id: 'mi_xao_trung_rau_cu',
        title: 'Mì xào trứng & rau củ thập cẩm',
        description:
            'Giải pháp bữa tối nhanh gọn trong 10 phút, tận dụng rau củ còn sót trong tủ lạnh kết hợp trứng chiên tơi xốp.',
        imageUrl:
            'https://images.unsplash.com/photo-1612927601601-6638404737ce?auto=format&fit=crop&w=600&q=80',
        cookTimeMinutes: 10,
        difficulty: 'Rất dễ',
        servings: 1,
        priorityTag: 'Nấu nhanh 10 phút',
        tags: ['Tất cả', 'Nấu nhanh', 'Đủ nguyên liệu', 'Sắp hết hạn'],
        ingredients: [
          RecipeIngredient(
            name: 'Mì trứng hoặc mì gói',
            amount: '2 vắt',
            isAvailable: true,
            isExpiringSoon: false,
          ),
          RecipeIngredient(
            name: 'Trứng gà',
            amount: '2 quả',
            isAvailable: true,
            isExpiringSoon: true,
          ),
          RecipeIngredient(
            name: 'Rau cải ngọt non',
            amount: '1 nắm',
            isAvailable: true,
            isExpiringSoon: true,
          ),
          RecipeIngredient(
            name: 'Xì dầu & dầu mè thơm',
            amount: 'vừa đủ',
            isAvailable: true,
            isExpiringSoon: false,
          ),
        ],
        steps: [
          'Mì chần nhanh qua nước sôi 1 phút cho sợi tơi rồi xả ngay nước lạnh, trộn 1 thìa dầu ăn để sợi mì tơi giòn.',
          'Đánh tan trứng, tráng mỏng trên chảo rồi thái sợi dài (hoặc xào tơi xốp mềm).',
          'Phi thơm tỏi, cho rau cải vào đảo nhanh tay trên lửa lớn trong 1 phút.',
          'Đổ mì vào xào cùng, nêm 2 thìa xì dầu, 1 thìa dầu mè, đảo nhanh tay 2 phút cho sợi mì ngấm vị săn giòn.',
          'Cho trứng vào trộn đều rồi trút ra đĩa, rắc chút tiêu xay thưởng thức nóng.',
        ],
      ),
      const RecipeModel(
        id: 'canh_rong_bien_dau_hu',
        title: 'Canh rong biển đậu hũ non',
        description:
            'Món canh thanh lọc cơ thể chuẩn vị Hàn Quốc, rong biển giòn mát kết hợp đậu hũ non mềm béo tan trong miệng.',
        imageUrl:
            'https://images.unsplash.com/photo-1547592180-85f173990554?auto=format&fit=crop&w=600&q=80',
        cookTimeMinutes: 15,
        difficulty: 'Rất dễ',
        servings: 2,
        priorityTag: 'Món chay 15 phút',
        tags: ['Tất cả', 'Nấu nhanh', 'Ăn chay'],
        ingredients: [
          RecipeIngredient(
            name: 'Rong biển khô',
            amount: '20 g',
            isAvailable: false, // 👈 Thiếu
            isExpiringSoon: false,
          ),
          RecipeIngredient(
            name: 'Đậu hũ non',
            amount: '1 hộp',
            isAvailable: true,
            isExpiringSoon: false,
          ),
          RecipeIngredient(
            name: 'Dầu mè thơm & tỏi băm',
            amount: 'vừa đủ',
            isAvailable: true,
            isExpiringSoon: false,
          ),
          RecipeIngredient(
            name: 'Nước tương & hạt nêm chay',
            amount: 'vừa đủ',
            isAvailable: true,
            isExpiringSoon: false,
          ),
        ],
        steps: [
          'Rong biển ngâm nước ấm 10 phút cho nở mềm hoàn toàn, rửa sạch cắt khúc 3cm.',
          'Đậu hũ non cắt miếng vuông nhẹ tay tránh nát.',
          'Cho dầu mè vào nồi, phi thơm tỏi băm rồi trút rong biển vào xào thơm trong 2 phút.',
          'Đổ 700ml nước lọc vào đun sôi, hạ lửa vừa nấu liu riu 5 phút cho rong biển tiết nước ngọt thanh.',
          'Thả nhẹ nhàng đậu hũ non vào, nêm 1 thìa nước tương và chút hạt nêm chay, sôi lại 1 phút là tắt bếp.',
        ],
      ),
      const RecipeModel(
        id: 'rau_muong_xao_toi',
        title: 'Rau muống xào tỏi xanh giòn',
        description:
            'Món xào dân dã đậm chất mâm cơm Việt, ngọn rau muống giòn sần sật quyện vị bùi thơm của tỏi cô đơn phi vàng.',
        imageUrl:
            'https://images.unsplash.com/photo-1540420773420-3366772f4999?auto=format&fit=crop&w=600&q=80',
        cookTimeMinutes: 8,
        difficulty: 'Rất dễ',
        servings: 2,
        priorityTag: 'Nấu nhanh 8 phút',
        tags: ['Tất cả', 'Nấu nhanh', 'Đủ nguyên liệu', 'Ăn chay', 'Sắp hết hạn'],
        ingredients: [
          RecipeIngredient(
            name: 'Rau muống ngọn non',
            amount: '1 bó',
            isAvailable: true,
            isExpiringSoon: true,
          ),
          RecipeIngredient(
            name: 'Tỏi tươi đập dập',
            amount: '2 củ',
            isAvailable: true,
            isExpiringSoon: false,
          ),
          RecipeIngredient(
            name: 'Dầu ăn, nước mắm, dầu hào',
            amount: 'vừa đủ',
            isAvailable: true,
            isExpiringSoon: false,
          ),
        ],
        steps: [
          'Rau muống nhặt ngọn non bỏ lá úa, rửa sạch dưới vòi nước.',
          'Bí quyết xanh giòn: Chần nhanh rau trong nước sôi có muối 30 giây rồi vớt ngâm ngay vào âu nước đá lạnh 3 phút.',
          'Đun nóng chảo dầu, cho 2/3 lượng tỏi đập dập vào phi vàng giòn thơm nức rồi vớt riêng ra bát.',
          'Cho phần tỏi còn lại vào phi thơm, vặn lửa lớn tối đa rồi trút rau muống vào xào nhanh tay trong 1-2 phút.',
          'Nêm 1 thìa dầu hào, 1 thìa nước mắm ngon, đảo đều tắt bếp, trút ra đĩa rải tỏi phi giòn lên trên.',
        ],
      ),
      const RecipeModel(
        id: 'trung_chien_hanh_hoa',
        title: 'Trứng chiên thịt băm hành hoa',
        description:
            'Món ăn siêu tốc cứu cánh mọi bữa cơm gia đình, trứng nở phồng vàng ruộm, thịt băm ngọt mềm thơm nức mũi.',
        imageUrl:
            'https://images.unsplash.com/photo-1525351484163-7529414344d8?auto=format&fit=crop&w=600&q=80',
        cookTimeMinutes: 8,
        difficulty: 'Rất dễ',
        servings: 2,
        priorityTag: 'Siêu tốc 8 phút',
        tags: ['Tất cả', 'Nấu nhanh', 'Đủ nguyên liệu', 'Sắp hết hạn'],
        ingredients: [
          RecipeIngredient(
            name: 'Trứng gà tươi',
            amount: '3 quả',
            isAvailable: true,
            isExpiringSoon: true,
          ),
          RecipeIngredient(
            name: 'Thịt nạc vai băm',
            amount: '100 g',
            isAvailable: true,
            isExpiringSoon: true,
          ),
          RecipeIngredient(
            name: 'Hành hoa thái nhỏ',
            amount: '3 nhánh',
            isAvailable: true,
            isExpiringSoon: false,
          ),
          RecipeIngredient(
            name: 'Nước mắm cốt & tiêu sọ',
            amount: 'vừa đủ',
            isAvailable: true,
            isExpiringSoon: false,
          ),
        ],
        steps: [
          'Thịt băm ướp cùng chút nước mắm cốt và tiêu sọ trong 5 phút cho thấm vị.',
          'Đập 3 quả trứng vào bát thịt, thêm hành hoa cắt nhỏ, dùng đũa đánh đều tay cho thịt tan tơi trong trứng.',
          'Đun nóng chảo với 2 thìa dầu ăn, đổ hỗn hợp trứng thịt vào lắc nhẹ chảo cho trứng dàn đều tròn trịa.',
          'Hạ lửa vừa đậy vung 3 phút để thịt bên trong chín kỹ mà mặt dưới không bị cháy xém.',
          'Khéo léo lật mặt trứng rán thêm 2 phút cho vàng ruộm hai mặt, trút ra thớt cắt miếng tam giác vừa ăn.',
        ],
      ),
      const RecipeModel(
        id: 'canh_bi_do_thit_bam',
        title: 'Canh bí đỏ thịt băm dẻo bùi',
        description:
            'Món canh bổ dưỡng giàu vitamin A, vị ngọt tự nhiên từ thịt băm kết hợp bí đỏ dẻo mềm thơm lừng ngò gai.',
        imageUrl:
            'https://images.unsplash.com/photo-1547592180-85f173990554?auto=format&fit=crop&w=600&q=80',
        cookTimeMinutes: 20,
        difficulty: 'Dễ',
        servings: 3,
        priorityTag: 'Cần mua thêm bí đỏ',
        tags: ['Tất cả'],
        ingredients: [
          RecipeIngredient(
            name: 'Bí đỏ hồ lô',
            amount: '350 g',
            isAvailable: false, // 👈 Thiếu
            isExpiringSoon: false,
          ),
          RecipeIngredient(
            name: 'Thịt nạc dăm băm',
            amount: '150 g',
            isAvailable: true,
            isExpiringSoon: true,
          ),
          RecipeIngredient(
            name: 'Hành lá & ngò gai',
            amount: 'vài nhánh',
            isAvailable: true,
            isExpiringSoon: false,
          ),
          RecipeIngredient(
            name: 'Gia vị hạt nêm, nước mắm',
            amount: 'vừa đủ',
            isAvailable: true,
            isExpiringSoon: false,
          ),
        ],
        steps: [
          'Bí đỏ gọt vỏ bỏ ruột, rửa sạch cắt miếng vuông dày 1.5cm vừa ăn.',
          'Thịt băm ướp với chút hạt nêm và hành khô băm nhỏ.',
          'Phi thơm hành tím với chút dầu ăn, trút thịt băm vào xào săn thơm.',
          'Cho 700ml nước vào đun sôi, vớt bọt, trút bí đỏ vào đậy vung nấu lửa vừa 10-12 phút đến khi bí chín dẻo bùi.',
          'Nêm nước mắm hạt nêm vừa ăn, rắc hành ngò thái nhỏ và tiêu rồi múc ra bát canh nóng hổi.',
        ],
      ),
      const RecipeModel(
        id: 'ga_xao_sa_ot',
        title: 'Gà kho sả ớt đậm đà đưa cơm',
        description:
            'Thịt gà săn chắc thấm đượm gia vị, sả băm phi vàng cay nồng kích thích vị giác, cực kỳ thích hợp cho bữa tối quây quần.',
        imageUrl:
            'https://images.unsplash.com/photo-1604908176997-125f25cc6f3d?auto=format&fit=crop&w=600&q=80',
        cookTimeMinutes: 25,
        difficulty: 'Dễ',
        servings: 2,
        priorityTag: 'Sắp hết hạn',
        tags: ['Tất cả', 'Sắp hết hạn'],
        ingredients: [
          RecipeIngredient(
            name: 'Thịt đùi gà ta',
            amount: '450 g',
            isAvailable: true,
            isExpiringSoon: true,
          ),
          RecipeIngredient(
            name: 'Sả tươi băm nhuyễn',
            amount: '3 cây',
            isAvailable: false, // 👈 Thiếu
            isExpiringSoon: false,
          ),
          RecipeIngredient(
            name: 'Ớt sừng băm nhỏ',
            amount: '2 quả',
            isAvailable: true,
            isExpiringSoon: false,
          ),
          RecipeIngredient(
            name: 'Nước màu dừa & nước mắm',
            amount: 'vừa đủ',
            isAvailable: true,
            isExpiringSoon: false,
          ),
        ],
        steps: [
          'Gà chà xát muối gừng khử mùi, chặt miếng vừa ăn để ráo nước.',
          'Ướp gà với 2 thìa nước mắm ngon, 1 thìa đường, 1 thìa dầu hào, 1 thìa nước màu dừa và một nửa lượng sả ớt băm trong 15 phút.',
          'Đun nóng chảo dầu, cho phần sả tỏi ớt còn lại vào phi thơm lừng ngả vàng giòn.',
          'Trút thịt gà vào xào săn trên lửa lớn trong 5 phút đến khi miếng gà co lại thấm màu cánh gián óng ả.',
          'Thêm 3 thìa nước lọc, hạ nhỏ lửa kho liu riu trong 12-15 phút đến khi nước sốt sánh kẹo bám đều vào từng miếng gà.',
        ],
      ),
      const RecipeModel(
        id: 'salad_uc_ga_sot_me',
        title: 'Salad ức gà áp chảo sốt mè',
        description:
            'Món ăn Eat Clean thanh nhẹ, ức gà mềm ngọt giàu protein kết hợp rau xà lách giòn mát và sốt mè rang béo bùi.',
        imageUrl:
            'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=600&q=80',
        cookTimeMinutes: 12,
        difficulty: 'Rất dễ',
        servings: 1,
        priorityTag: 'Nấu nhanh 12 phút',
        tags: ['Tất cả', 'Nấu nhanh'],
        ingredients: [
          RecipeIngredient(
            name: 'Ức gà phi lê tươi',
            amount: '200 g',
            isAvailable: false, // 👈 Thiếu
            isExpiringSoon: false,
          ),
          RecipeIngredient(
            name: 'Xà lách & cà chua bi',
            amount: '150 g',
            isAvailable: true,
            isExpiringSoon: true,
          ),
          RecipeIngredient(
            name: 'Dưa leo giòn ngọt',
            amount: '1 quả',
            isAvailable: true,
            isExpiringSoon: true,
          ),
          RecipeIngredient(
            name: 'Sốt mè rang Kewpie',
            amount: '3 thìa',
            isAvailable: false, // 👈 Thiếu (thiếu 2 món)
            isExpiringSoon: false,
          ),
        ],
        steps: [
          'Ức gà khía nhẹ mặt thịt, ướp với chút muối tiêu và dầu olive trong 5 phút.',
          'Áp chảo ức gà mỗi mặt 4 phút trên lửa vừa đến khi vàng óng bên ngoài mà bên trong vẫn mọng nước ngọt mềm.',
          'Gắp thịt gà ra thái lát xéo mỏng vừa ăn.',
          'Xà lách ngâm nước đá cho giòn mát, dưa leo thái lát, cà chua bi bổ đôi.',
          'Bày rau củ ra đĩa, đặt ức gà lên trên và rưới sốt mè rang béo ngậy thưởng thức ngay.',
        ],
      ),
      const RecipeModel(
        id: 'suon_xao_chua_ngot',
        title: 'Sườn non xào chua ngọt',
        description:
            'Sườn non óng ả màu cánh gián, thịt mềm róc xương đậm đà vị chua ngọt sánh mịn từ cà chua chín và giấm bỗng.',
        imageUrl:
            'https://images.unsplash.com/photo-1544025162-d76694265947?auto=format&fit=crop&w=600&q=80',
        cookTimeMinutes: 40,
        difficulty: 'Trung bình',
        servings: 3,
        priorityTag: 'Món ngon 40 phút',
        tags: ['Tất cả', '< 1 giờ', 'Ưu tiên nấu trước'],
        ingredients: [
          RecipeIngredient(
            name: 'Sườn heo non',
            amount: '500 g',
            isAvailable: true,
            isExpiringSoon: true, // 👈 2 món cận date
          ),
          RecipeIngredient(
            name: 'Cà chua chín mọng',
            amount: '2 quả',
            isAvailable: true,
            isExpiringSoon: true,
          ),
          RecipeIngredient(
            name: 'Hành khô & tỏi băm',
            amount: '2 củ',
            isAvailable: true,
            isExpiringSoon: false,
          ),
          RecipeIngredient(
            name: 'Ớt chuông đỏ',
            amount: '1 quả',
            isAvailable: false, // 👈 Thiếu
            isExpiringSoon: false,
          ),
        ],
        steps: [
          'Sườn chặt khúc 3cm, chần qua nước sôi rồi ướp hạt nêm, tiêu trong 15 phút.',
          'Rán sườn vàng xém các cạnh trên chảo dầu nóng rồi vớt ra.',
          'Phi thơm tỏi băm, xào cà chua thành sốt sánh, nêm giấm, đường, nước mắm vừa vị chua ngọt.',
          'Trút sườn vào chảo sốt, đậy vung om nhỏ lửa 20 phút cho sườn ngấm mềm và cạn sốt sánh óng.',
        ],
      ),
      const RecipeModel(
        id: 'ca_loc_kho_to',
        title: 'Cá lóc kho tộ miền Tây',
        description:
            'Thịt cá săn chắc ngấm đượm nước màu dừa, tiêu đen cay nồng và ớt sừng thơm lừng ăn cùng cơm nóng.',
        imageUrl:
            'https://images.unsplash.com/photo-1534422298391-e4f8c172dddb?auto=format&fit=crop&w=600&q=80',
        cookTimeMinutes: 45,
        difficulty: 'Dễ',
        servings: 3,
        priorityTag: 'Món kho đậm đà',
        tags: ['Tất cả', '< 1 giờ', 'Đủ nguyên liệu'],
        ingredients: [
          RecipeIngredient(
            name: 'Cá lóc tươi cắt khúc',
            amount: '500 g',
            isAvailable: true,
            isExpiringSoon: false,
          ),
          RecipeIngredient(
            name: 'Hành tím & tỏi đập dập',
            amount: '3 củ',
            isAvailable: true,
            isExpiringSoon: false,
          ),
          RecipeIngredient(
            name: 'Nước mắm ngon & nước màu dừa',
            amount: 'vừa đủ',
            isAvailable: true,
            isExpiringSoon: false,
          ),
          RecipeIngredient(
            name: 'Tiêu sọ & ớt hiểm',
            amount: 'vừa đủ',
            isAvailable: true,
            isExpiringSoon: false,
          ),
        ],
        steps: [
          'Cá rửa sạch muối gừng khử tanh, ướp nước mắm, đường, nước màu dừa, tiêu trong 20 phút.',
          'Xếp thịt cá vào tộ đất, rải hành tỏi đập dập và ớt lên trên.',
          'Đun sôi bùng lửa lớn 5 phút cho cá săn lại, châm thêm nửa bát nước sôi rồi hạ lửa liu riu kho trong 35 phút.',
          'Khi nước sốt cạn sánh kẹo bám quanh khúc cá thì rắc hành lá và tiêu xay rồi tắt bếp.',
        ],
      ),
      const RecipeModel(
        id: 'thit_kho_trung_cut',
        title: 'Thịt ba chỉ kho trứng cút nước dừa',
        description:
            'Từng miếng thịt ba chỉ mềm tan rục béo ngậy quyện cùng trứng cút bùi bùi và nước dừa ngọt dịu tự nhiên.',
        imageUrl:
            'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=600&q=80',
        cookTimeMinutes: 50,
        difficulty: 'Trung bình',
        servings: 4,
        priorityTag: 'Kho kỹ 50 phút',
        tags: ['Tất cả', '< 1 giờ'],
        ingredients: [
          RecipeIngredient(
            name: 'Thịt ba chỉ rút sườn',
            amount: '400 g',
            isAvailable: true,
            isExpiringSoon: false,
          ),
          RecipeIngredient(
            name: 'Trứng cút luộc bóc vỏ',
            amount: '12 quả',
            isAvailable: true,
            isExpiringSoon: false,
          ),
          RecipeIngredient(
            name: 'Nước dừa xiêm tươi',
            amount: '1 quả',
            isAvailable: false, // 👈 Thiếu
            isExpiringSoon: false,
          ),
          RecipeIngredient(
            name: 'Hành tím băm & nước mắm',
            amount: 'vừa đủ',
            isAvailable: true,
            isExpiringSoon: false,
          ),
        ],
        steps: [
          'Thịt ba chỉ thái miếng vuông quân cờ to, ướp hành tím băm, nước mắm, chút đường trong 20 phút.',
          'Đảo thịt trên chảo cho săn lại và chảy bớt mỡ thừa.',
          'Trút thịt vào nồi, đổ ngập nước dừa xiêm đun sôi bùng, vớt bọt rồi hạ nhỏ lửa om 30 phút.',
          'Thả trứng cút vào kho cùng thêm 15 phút đến khi thịt mềm rục, nước kho ngả màu cánh gián óng ả.',
        ],
      ),
      const RecipeModel(
        id: 'canh_suon_ham_cu_qua',
        title: 'Canh sườn non hầm khoai tây cà rốt',
        description:
            'Bát canh sườn hầm thơm phức, nước dùng ngọt đậm đà từ xương, khoai tây dẻo bùi và cà rốt thanh ngọt mềm tan.',
        imageUrl:
            'https://images.unsplash.com/photo-1547592180-85f173990554?auto=format&fit=crop&w=600&q=80',
        cookTimeMinutes: 65,
        difficulty: 'Dễ',
        servings: 3,
        priorityTag: 'Hầm bổ dưỡng 65 phút',
        tags: ['Tất cả', 'Từ 1h - 2h'],
        ingredients: [
          RecipeIngredient(
            name: 'Sườn heo non chặt khúc',
            amount: '400 g',
            isAvailable: true,
            isExpiringSoon: false,
          ),
          RecipeIngredient(
            name: 'Khoai tây & cà rốt',
            amount: '3 củ',
            isAvailable: true,
            isExpiringSoon: false,
          ),
          RecipeIngredient(
            name: 'Hành hoa & ngò rí',
            amount: '2 nhánh',
            isAvailable: true,
            isExpiringSoon: false,
          ),
          RecipeIngredient(
            name: 'Bắp ngọt cắt khúc',
            amount: '1 bắp',
            isAvailable: false, // 👈 Thiếu
            isExpiringSoon: false,
          ),
        ],
        steps: [
          'Sườn chần nước sôi rửa sạch, cho vào nồi cùng 1.2 lít nước hầm nhỏ lửa trong 45 phút cho xương ra nước ngọt.',
          'Khoai tây, cà rốt gọt vỏ cắt miếng vừa ăn ngâm nước.',
          'Cho củ quả vào nồi sườn hầm tiếp 15-20 phút đến khi khoai và cà rốt bở mềm.',
          'Nêm gia vị vừa ăn, múc ra bát rắc hành ngò thái nhỏ thưởng thức nóng.',
        ],
      ),
      const RecipeModel(
        id: 'canh_ga_ham_sen',
        title: 'Canh gà hầm hạt sen táo đỏ',
        description:
            'Món canh bồi bổ thanh nhiệt, thịt gà ta ngọt mềm ninh kỹ cùng hạt sen bùi ngậy và táo đỏ ngọt thanh thơm dịu.',
        imageUrl:
            'https://images.unsplash.com/photo-1547592180-85f173990554?auto=format&fit=crop&w=600&q=80',
        cookTimeMinutes: 70,
        difficulty: 'Dễ',
        servings: 4,
        priorityTag: 'Món hầm 70 phút',
        tags: ['Tất cả', 'Từ 1h - 2h', 'Đủ nguyên liệu'],
        ingredients: [
          RecipeIngredient(
            name: 'Gà ta làm sạch',
            amount: '½ con (700g)',
            isAvailable: true,
            isExpiringSoon: false,
          ),
          RecipeIngredient(
            name: 'Hạt sen tươi bỏ tâm',
            amount: '100 g',
            isAvailable: true,
            isExpiringSoon: false,
          ),
          RecipeIngredient(
            name: 'Táo đỏ & kỷ tử',
            amount: '50 g',
            isAvailable: true,
            isExpiringSoon: false,
          ),
          RecipeIngredient(
            name: 'Gừng tươi & nấm hương',
            amount: 'vừa đủ',
            isAvailable: true,
            isExpiringSoon: false,
          ),
        ],
        steps: [
          'Gà chặt miếng to hoặc để nguyên góc tư, chần qua nước sôi có gừng đập dập.',
          'Cho gà, hạt sen, táo đỏ và vài lát gừng vào nồi với 1.5 lít nước đun sôi.',
          'Hạ lửa nhỏ liu riu đậy kín nắp hầm trong 50-60 phút cho thịt gà mềm rục và hạt sen bở tơi.',
          'Thêm nấm hương và kỷ tử nấu thêm 10 phút, nêm chút muối hạt thanh tao rồi múc ra tô.',
        ],
      ),
      const RecipeModel(
        id: 'bo_kho_nuoc_dua',
        title: 'Bò kho nước dừa tiêu xanh',
        description:
            'Nạm bò hầm mềm rục ngấm trọn hương vị sả gừng và tiêu xanh cay nồng, chấm bánh mì hay ăn cùng hủ tiếu đều tuyệt đỉnh.',
        imageUrl:
            'https://images.unsplash.com/photo-1544025162-d76694265947?auto=format&fit=crop&w=600&q=80',
        cookTimeMinutes: 75,
        difficulty: 'Trung bình',
        servings: 4,
        priorityTag: 'Hầm đậm vị 75 phút',
        tags: ['Tất cả', 'Từ 1h - 2h', 'Ưu tiên nấu trước'],
        ingredients: [
          RecipeIngredient(
            name: 'Nạm bò nhiều gân giòn',
            amount: '600 g',
            isAvailable: true,
            isExpiringSoon: true, // 👈 2 món cận date
          ),
          RecipeIngredient(
            name: 'Cà rốt tươi',
            amount: '2 củ',
            isAvailable: true,
            isExpiringSoon: true,
          ),
          RecipeIngredient(
            name: 'Sả cây & tiêu xanh',
            amount: '4 nhánh',
            isAvailable: true,
            isExpiringSoon: false,
          ),
          RecipeIngredient(
            name: 'Nước dừa xiêm & gia vị bò kho',
            amount: 'vừa đủ',
            isAvailable: true,
            isExpiringSoon: false,
          ),
        ],
        steps: [
          'Nạm bò cắt khối vuông 3cm, ướp cùng gói sốt bò kho, tỏi sả băm, 1 thìa nước mắm trong 30 phút.',
          'Xào săn thịt bò trên lửa lớn cho ngấm màu đẹp mắt.',
          'Đổ 1 quả nước dừa tươi và nước lọc xăm xắp mặt thịt, đập dập sả cây thả vào nồi hầm nhỏ lửa trong 50 phút.',
          'Cho cà rốt cắt khúc và tiêu xanh vào hầm tiếp 20 phút cho cà rốt mềm ngọt, nước sốt sánh sệt vừa vặn.',
        ],
      ),
    ];
  }

  @override
  Future<List<RecipeModel>> getSuggestedRecipes({String? activeFilter}) async {
    await Future.delayed(const Duration(milliseconds: 60));
    var list = List<RecipeModel>.from(_recipes);

    // Lọc theo chip ngang
    if (activeFilter != null && activeFilter != 'Tất cả') {
      if (activeFilter == 'Ưu tiên nấu trước') {
        // Chỉ lấy những món sử dụng nguyên liệu sắp hết hạn
        list = list.where((r) => r.expiringIngredientsCount > 0).toList();
        // Ưu tiên hiển thị món dùng nhiều nguyên liệu cận date nhất lên đầu (giảm dần)
        list.sort((a, b) => b.expiringIngredientsCount.compareTo(a.expiringIngredientsCount));
      } else if (activeFilter == 'Đủ nguyên liệu') {
        list = list.where((r) => r.hasAllIngredients).toList();
      } else if (activeFilter == '< 15 phút' || activeFilter == 'Nấu nhanh <15' || activeFilter == '< 15p') {
        list = list.where((r) => r.cookTimeMinutes < 15).toList();
        list.sort((a, b) => a.cookTimeMinutes.compareTo(b.cookTimeMinutes));
      } else if (activeFilter == '< 30 phút' || activeFilter == '<30' || activeFilter == '< 30p') {
        list = list.where((r) => r.cookTimeMinutes <= 30 && r.cookTimeMinutes >= 15).toList();
        list.sort((a, b) => a.cookTimeMinutes.compareTo(b.cookTimeMinutes));
      } else if (activeFilter == '< 1 giờ' || activeFilter == '< 1h' || activeFilter == '< 60 phút') {
        list = list.where((r) => r.cookTimeMinutes > 30 && r.cookTimeMinutes <= 60).toList();
        list.sort((a, b) => a.cookTimeMinutes.compareTo(b.cookTimeMinutes));
      } else if (activeFilter == 'Từ 1h - 2h' || activeFilter == 'từ 1h đến 2h' || activeFilter == '1h - 2h') {
        list = list.where((r) => r.cookTimeMinutes > 60 && r.cookTimeMinutes <= 120).toList();
        list.sort((a, b) => a.cookTimeMinutes.compareTo(b.cookTimeMinutes));
      } else {
        list = list.where((r) => r.tags.contains(activeFilter)).toList();
      }
    }

    return list;
  }

  @override
  Future<RecipeModel?> getFeaturedRecipe({String? activeFilter}) async {
    await Future.delayed(const Duration(milliseconds: 40));
    var pool = List<RecipeModel>.from(_recipes);

    if (activeFilter != null && activeFilter != 'Tất cả') {
      if (activeFilter == 'Ưu tiên nấu trước') {
        final matching = pool.where((r) => r.expiringIngredientsCount > 0).toList();
        if (matching.isNotEmpty) {
          matching.sort((a, b) => b.expiringIngredientsCount.compareTo(a.expiringIngredientsCount));
          return matching.first;
        }
      } else if (activeFilter == 'Đủ nguyên liệu') {
        final matching = pool.where((r) => r.hasAllIngredients).toList();
        if (matching.isNotEmpty) return matching.first;
      } else if (activeFilter == '< 15 phút' || activeFilter == 'Nấu nhanh <15' || activeFilter == '< 15p') {
        final matching = pool.where((r) => r.cookTimeMinutes < 15).toList();
        if (matching.isNotEmpty) {
          matching.sort((a, b) => a.cookTimeMinutes.compareTo(b.cookTimeMinutes));
          return matching.first;
        }
      } else if (activeFilter == '< 30 phút' || activeFilter == '<30' || activeFilter == '< 30p') {
        final matching = pool.where((r) => r.cookTimeMinutes <= 30 && r.cookTimeMinutes >= 15).toList();
        if (matching.isNotEmpty) return matching.first;
      } else if (activeFilter == '< 1 giờ' || activeFilter == '< 1h' || activeFilter == '< 60 phút') {
        final matching = pool.where((r) => r.cookTimeMinutes > 30 && r.cookTimeMinutes <= 60).toList();
        if (matching.isNotEmpty) return matching.first;
      } else if (activeFilter == 'Từ 1h - 2h' || activeFilter == 'từ 1h đến 2h' || activeFilter == '1h - 2h') {
        final matching = pool.where((r) => r.cookTimeMinutes > 60 && r.cookTimeMinutes <= 120).toList();
        if (matching.isNotEmpty) return matching.first;
      } else {
        final matching = pool.where((r) => r.tags.contains(activeFilter)).toList();
        if (matching.isNotEmpty) return matching.first;
      }
    }

    return pool.firstWhere((r) => r.isFeatured, orElse: () => pool.first);
  }

  @override
  Future<RecipeModel?> getRecipeById(String id) async {
    await Future.delayed(const Duration(milliseconds: 40));
    try {
      return _recipes.firstWhere((r) => r.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> toggleBookmark(String id) async {
    final index = _recipes.indexWhere((r) => r.id == id);
    if (index != -1) {
      final item = _recipes[index];
      _recipes[index] = item.copyWith(isBookmarked: !item.isBookmarked);
    }
  }

  @override
  Future<List<RecipeModel>> getBookmarkedRecipes() async {
    await Future.delayed(const Duration(milliseconds: 40));
    return _recipes.where((r) => r.isBookmarked).toList();
  }

  @override
  Future<List<RecipeModel>> getSuggestionsBasedOnFridge(
      List<FoodModel> fridgeFoods) async {
    final availableNames =
        fridgeFoods.map((f) => f.name.toLowerCase()).toSet();

    return _recipes.where((recipe) {
      return recipe.ingredients.any((ing) =>
          availableNames.any((fName) => ing.name.toLowerCase().contains(fName)));
    }).toList();
  }

  @override
  Future<RecipeModel> generateAiRecipe({List<FoodModel>? fridgeFoods}) async {
    await Future.delayed(const Duration(milliseconds: 1400));

    return const RecipeModel(
      id: 'ai_generated_dish',
      title: 'Canh trứng đậu cà thanh nhiệt',
      description:
          '✨ Công thức độc quyền do AI Gemini sáng tạo: Kết hợp trứng gà và cà chua cận hạn với đậu phụ mềm, tạo nên món canh thanh mát chuẩn vị cơm nhà.',
      imageUrl:
          'https://images.unsplash.com/photo-1547592180-85f173990554?auto=format&fit=crop&w=800&q=80',
      cookTimeMinutes: 12,
      difficulty: 'Rất dễ',
      servings: 2,
      priorityTag: '✨ Sinh bởi AI Gemini',
      isFeatured: false,
      tags: ['Tất cả', 'Nấu nhanh', 'Đủ nguyên liệu', 'Sắp hết hạn'],
      ingredients: [
        RecipeIngredient(
          name: 'Trứng gà (tủ lạnh có sẵn)',
          amount: '2 quả',
          isAvailable: true,
          isExpiringSoon: true,
        ),
        RecipeIngredient(
          name: 'Cà chua chín mềm',
          amount: '2 quả',
          isAvailable: true,
          isExpiringSoon: true,
        ),
        RecipeIngredient(
          name: 'Đậu phụ non mềm',
          amount: '1 hộp',
          isAvailable: true,
          isExpiringSoon: false,
        ),
        RecipeIngredient(
          name: 'Hành hoa, hạt tiêu, gia vị',
          amount: 'vừa đủ',
          isAvailable: true,
          isExpiringSoon: false,
        ),
      ],
      steps: [
        'AI Gợi ý: Cà chua thái múi cau mỏng, xào chín với 1 thìa dầu ăn cho tiết ra màu đỏ óng ả tự nhiên.',
        'Đổ 500ml nước lọc vào đun sôi bùng, nhẹ nhàng thả đậu phụ cắt miếng vuông vào.',
        'Đánh tan 2 quả trứng gà, hạ lửa nhỏ rồi từ từ rót trứng vào khuấy nhẹ một chiều tạo vân mây bồng bềnh đẹp mắt.',
        'Nêm nước mắm cốt và hạt nêm vừa ăn, rắc hành lá cắt nhỏ và chút tiêu xay rồi tắt bếp ngay để trứng giữ độ mềm mịn.',
      ],
    );
  }
}
