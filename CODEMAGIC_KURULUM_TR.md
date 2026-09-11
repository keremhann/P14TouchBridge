# P14 Touch Bridge — Codemagic / Windows

Bu paket Mac gerektirmeden Codemagic üzerinde derleme testi yapmak için hazırlanmıştır.

## 1. Repo'ya yükle
Bu klasörün tamamını GitHub/GitLab/Bitbucket reposuna koy.

Repo kökünde şu dosyalar görünmeli:
- `P14TouchBridge.xcodeproj`
- `P14TouchBridge/`
- `codemagic.yaml`

## 2. Codemagic'te proje ekle
1. Codemagic > Add application
2. Repo'yu bağla
3. `codemagic.yaml` ile workflow kullan
4. Workflow: `P14 Touch Bridge`
5. Start new build

## 3. İlk build'in amacı
Bu workflow önce CODE SIGNING kapalı şekilde proje derleniyor mu onu doğrular ve
`P14TouchBridge-unsigned.ipa` üretir.

ÖNEMLİ: Unsigned IPA doğrudan normal iPhone'a kurulamaz.
Bu ilk aşama yalnızca kaynak kodunun Codemagic'te hatasız derlenmesini doğrulamak içindir.

## 4. Sonraki adım
Build yeşil olursa ikinci pakette Codemagic code-signing'i açacağız ve cihazına kurulabilir
signed IPA üreteceğiz.

Bunun için Codemagic tarafında kullandığın mevcut Apple Developer / provisioning yöntemini
koruyabiliriz. Daha önce başka iPhone uygulamasını hangi signing yöntemiyle üretiyorsan
aynı yönteme bağlarız.

## 5. Test uygulaması ne gösterecek?
Uygulama P14 bağlıyken:
- GCMouse bağlı/yok
- Delta X/Y
- sol tık
- scroll
- Hover X/Y
- Touch X/Y
- event sayacı

Bize lazım olan ekran görüntüsü:
P14 bağlı + AssistiveTouch açıkken ekrandaki değerler.
