# V2 — Codemagic fix

Bu sürüm artık projenin repo kökünde olduğunu varsaymıyor.
Codemagic, `P14TouchBridge.xcodeproj` dosyasını tüm klonlanmış repo içinde otomatik arar.

Ayrıca CI için paylaşılan Xcode scheme eklendi.

En kolay güncelleme:
1. Mevcut GitHub reposunda eski `codemagic.yaml` dosyasını sil veya üzerine yaz.
2. Bu paketteki TÜM dosya/klasörleri repo'ya yükle.
3. Özellikle şu yolun GitHub'da gerçekten bulunduğunu kontrol et:
   `P14TouchBridge.xcodeproj/project.pbxproj`
4. Commit changes.
5. Codemagic'te yeni build başlat.

Build logunda ilk adım `Locate project` olacaktır.
Burada `Found project at: .../P14TouchBridge.xcodeproj` satırını görmelisin.

Eğer yine bulamazsa, `Locate project` adımının tamamını gönder; repo içeriğini doğrudan logdan görebileceğiz.
