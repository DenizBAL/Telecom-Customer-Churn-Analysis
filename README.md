# 📊 Telekom Müşteri Kaybı (Churn) Analizi & BI Dashboard

Bu proje, telekomünikasyon sektöründeki müşteri davranışlarını, hizmet kullanım alışkanlıklarını ve coğrafi kayıp (churn) risklerini analiz etmek amacıyla geliştirilmiş uçtan uca bir Business Intelligence (BI) çözümüdür. 

Projede veri temizleme aşamasından başlayıp **MSSQL** üzerinde **Star Schema** mimarisi kurulmuş, **Power BI** ve **PowerPoint şablonları (UI/UX)** kullanılarak karanlık tema (`#0F172A`) konseptinde 3 sayfadan oluşan portföy hazır bir dashboard tasarlanmıştır.

---

## 🖼️ Dashboard Görselleri

### 1. Yönetici Özeti (Executive Overview)
Genel müşteri sayısı, churn oranı, kaybedilen toplam gelir (Lost Revenue) ve zaman içindeki churn trendlerinin analiz edildiği ana ekran.

![Executive Overview](assets/exe.png)

---

### 2. Müşteri Davranışı ve Kullanım Analizi (Customer Behavioral Analysis)
Ayrılan ve devam eden müşterilerin ortalama arama süresi, internet kullanımı (GB) ve SMS alışkanlıklarının karşılaştırıldığı detaylı ekran.

![Customer Behavior](assets/custom.png)

---

### 3. Coğrafi ve Demografik Analiz (Geographic & Demographic Analysis)
En yüksek churn oranına sahip eyaletlerin harita üzerinde gösterimi, yaş ve bağımlı sayısı dağılımları ile en riskli şehirlerin analiz edildiği bölüm.

![Geographic Analysis](assets/geo.png)

---

## 🛠️ Teknik Mimari ve Teknolojiler

* **Veri Tabanı & Veri Temizleme:** MSSQL Server (Silver Layer temizleme işlemleri, `ABS()` dönüşümleri, surrogate key oluşturma)
* **Veri Modelleme:** Strict Star Schema Mimari Tasarımı (1 Fact, 4 Dimension Tablosu)
* **İş Zekası Araçları:** Power BI Desktop
* **Analitik Metrikler:** İleri düzey DAX (Dinamik Top-N, Tarih Hiyerarşileri, Özel Formatlamalar)
* **Görsel Tasarım (UI/UX):** PowerPoint tabanlı Canvas Arka Plan Şablonları, Koyu Tema (`Navy #0F172A`, `Accent Red #EF4444`)

---

## 📐 Veri Modeli (Star Schema)

Projede rapor performansını optimize etmek ve esnek filtreleme sağlamak amacıyla yıldız mimari uygulanmıştır:

* **`fact_churn`**: Tüm işlem verileri, arama süreleri, veri kullanımı, SMS sayıları ve churn bayrağı (`IsChurn`).
* **`dim_customer`**: Müşteri demografik bilgileri (Yaş, Cinsiyet, Bağımlı Sayısı, Maaş).
* **`dim_location`**: Konumsal veriler (Eyalet, Şehir, Posta Kodu).
* **`dim_partner`**: Müşterinin hizmet aldığı telekom operatörü bilgileri.
* **`dim_date`**: Zaman serisi ve trend analizleri için oluşturulan takvim tablosu.

---

## 💡 Öne Çıkan Analitik Bulgular

1. **Gelir Kaybı Riski:** Churn olan müşterilerin toplam ciro üzerindeki etkisi $20M+ seviyesindedir.
2. **Kullanım Anomalileri:** Düşük veri ve arama kullanımına sahip müşterilerde ayrılma eğilimi daha yüksek seyretmektedir.
3. **Bölgesel Odak:** Jharkhand ve yüksek nüfuslu metropollerde churn oranı ortalamanın üzerindedir.

---

## 🚀 Projeyi Yerel Ortamda Çalıştırma

1. Repoyu bilgisayarınıza klonlayın:
   ```bash
   git clone [https://github.com/KULLANICI_ADINIZ/Telecom-Customer-Churn-Analysis.git](https://github.com/KULLANICI_ADINIZ/Telecom-Customer-Churn-Analysis.git)
