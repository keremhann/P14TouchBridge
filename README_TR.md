# P14 Touch Bridge — Test 1

Amaç: iPhone'a bağlı P14 dokunmatik monitörün iOS tarafından nasıl görüldüğünü ölçmek.

Bu ilk sürüm:
- P14 / mouse benzeri aygıtın `GCMouse` olarak görülüp görülmediğini gösterir.
- X/Y delta hareketlerini canlı gösterir.
- Sol tık durumunu gösterir.
- Uygulama içindeki pointer konumunu (hover) gösterir.
- Pointer uygulama alanındayken iOS izin verirse pointer görünümünü gizlemeyi dener.
- Ekrana gerçek iPhone dokunuşu gelirse touch koordinatlarını ayrıca kaydeder.

Bu sürüm sistem geneline dokunma enjekte etmez. Önce P14'ün bize hangi tip veriyi verdiğini kesinleştirmek için teşhis sürümüdür.

## Kurulum
1. Mac'te Xcode'u aç.
2. `P14TouchBridge.xcodeproj` dosyasını aç.
3. TARGETS > P14TouchBridge > Signing & Capabilities bölümünde kendi Apple hesabındaki Team'i seç.
4. iPhone 16 Pro Max'i Mac'e bağla.
5. Üstten hedef cihaz olarak iPhone'u seç.
6. Run (▶) tuşuna bas.
7. Uygulama açıldıktan sonra iPhone'u P14'e bağla.
8. AssistiveTouch açıkken P14 üzerinde sol üst, sağ üst, sağ alt, sol alt ve orta noktalara dokun ve sürükle.

Ekrandaki `GCMouse`, `Delta X/Y`, `Hover X/Y` ve `Touch X/Y` değerlerinin ekran görüntüsünü gönder.
