# Smart Store - متجر ذكي 🛍️

تطبيق تجارة إلكترونية (E-commerce) عصري ومتكامل مبني باستخدام إطار عمل **Flutter**. يتميز التطبيق بواجهة مستخدم جذابة وحديثة مع دعم كامل للغة العربية (RTL)، بالإضافة إلى ميزات متقدمة مثل إدارة سلة التسوق والمفضلة والمزامنة اللحظية للبيانات.

##  الميزات الرئيسية

- **واجهة مستخدم عصرية (Modern UI/UX):** تصميم جذاب يعتمد على ألوان متدرجة حيوية (Vibrant Gradients) وظلال ناعمة (Soft Shadows) باستخدام خط `Cairo`.
- **المصادقة (Authentication):** نظام تسجيل دخول وإنشاء حساب متكامل باستخدام **Firebase Authentication**.
- **إدارة السلة (Cart Management):** إضافة وحذف وتعديل كميات المنتجات في السلة مع حساب الإجمالي وتكاليف الشحن ديناميكياً.
- **المنتجات المفضلة (Favorites):** حفظ المنتجات المفضلة للعودة إليها لاحقاً.
- **جلب البيانات (API Integration):** عرض المنتجات باستخدام **FakeStore API**.
- **المزامنة اللحظية والحفظ المحلي:** مزامنة سلة التسوق والمفضلة مع **Firebase Firestore** لضمان توفرها على مختلف الأجهزة، مع التخزين المحلي `SharedPreferences` للعمل دون إنترنت مؤقتاً.
- **تصفح الأقسام (Categories):** تصنيف المنتجات بشكل ذكي وتلوين كل قسم ديناميكياً.

## 🛠️ التقنيات المستخدمة

- **إطار العمل:** Flutter / Dart
- **إدارة الحالة (State Management):** Provider
- **قواعد البيانات والمصادقة:** Firebase (Firestore, Auth)
- **جلب البيانات:** `http` لـ RESTful APIs
- **التخزين المحلي:** `shared_preferences`
- **الخطوط:** `google_fonts` (Cairo)
- **التوجيه (Routing):** Bottom Navigation Bar مخصص.

##  هيكلية المشروع (Project Structure)

```
lib/
│
├── models/             # النماذج والهياكل البيانية (Product, CartItem, Category)
├── providers/          # مزودات الحالة (ProductProvider) لإدارة حالة التطبيق
├── screens/            # شاشات التطبيق
│   ├── login_screen.dart
│   ├── register_screen.dart
│   ├── main_navigation_screen.dart
│   ├── home_screen.dart
│   ├── cart_screen.dart
│   ├── favorites_screen.dart
│   ├── product_details_screen.dart
│   ├── categories_screen.dart
│   └── category_products_screen.dart
│
├── widgets/            # المكونات القابلة لإعادة الاستخدام (ProductCard, PageHeader, SectionHeader)
├── utils/              # الدوال المساعدة (ThemeUtils) لتوليد الألوان والتدرجات
└── main.dart           # نقطة البداية وإعداد الثيم العام
```

##  كيفية تشغيل المشروع

1. **نسخ المستودع (Clone):**
   ```bash
   git clone <repo-url>
   cd smart_store
   ```

2. **جلب الحزم (Fetch Packages):**
   ```bash
   flutter pub get
   ```

3. **إعداد Firebase:**
   - تأكد من أن مشروع Firebase مربوط بشكل صحيح من خلال ملفات `google-services.json` لنظام Android و `GoogleService-Info.plist` لنظام iOS.
   - قم بتفعيل خدمات **Authentication** (البريد الإلكتروني وكلمة المرور) و **Firestore Database** في لوحة تحكم Firebase.

4. **تشغيل التطبيق:**
   ```bash
   flutter run
   ```

## 🎨 واجهة المستخدم (UI Theme)

يعتمد التطبيق على نظام ألوان محدد ليعطي طابعاً احترافياً:
- **اللون الأساسي (Primary):** `Color(0xFF6C63FF)`
- **اللون الثانوي (Secondary):** `Color(0xFF8B5CF6)`
- **لون الخلفية (Background):** `Color(0xFFF0F2F8)`
- الخط الأساسي: **Cairo**

## 📝 ملاحظات للمطورين
- يتم إدارة جميع العمليات الشرائية والمفضلة داخل `ProductProvider`.
- الألوان المخصصة للأقسام يتم توليدها ديناميكياً في ملف `utils/theme_utils.dart`.
- يمكنك تغيير API المنتجات بالتعديل على مسارات الجلب في `ProductProvider`.
