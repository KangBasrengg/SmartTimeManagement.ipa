# Smart Time Management

iOS SwiftUI MVP berdasarkan `Smart_Time_Management_PRD.md`.

## Fitur MVP

- Dashboard agenda hari ini, meeting berikutnya, statistik produktivitas, smart insight, dan konflik jadwal.
- Daily planner dengan task, waktu mulai/selesai, prioritas, dan reminder preference.
- Calendar view dengan mode Daily, Weekly, Monthly.
- Client management dan meeting scheduler.
- Meeting history field melalui outcome/follow up pada model meeting.
- Notes untuk catatan ide, meeting, dan to-do.
- Local notification scheduler siap dipakai saat persistensi dan permission flow diaktifkan.
- Unit tests untuk conflict detection, productivity tracking, dan fallback smart suggestion.

## Build dan Test

Di Mac dengan Xcode:

```sh
xcodebuild \
  -project SmartTimeManagement.xcodeproj \
  -scheme SmartTimeManagement \
  -destination 'platform=iOS Simulator,name=iPhone 15' \
  test
```

Atau buka `SmartTimeManagement.xcodeproj`, pilih scheme `SmartTimeManagement`, lalu Run/Test dari Xcode.

## Build Gratis via GitHub Actions

Project ini sudah punya workflow di `.github/workflows/build.yml`.

1. Buat repository gratis di GitHub.
2. Push project ini ke branch `main` atau `master`.
3. Buka tab `Actions` di GitHub.
4. Pilih run terbaru `Build iOS App`.
5. Unduh artifact `SmartTimeManagement-unsigned-ipa`.

Workflow akan menjalankan unit test di iOS Simulator GitHub, lalu membuat `SmartTimeManagement.ipa` tanpa signing berbayar. File `.ipa` ini tetap perlu ditandatangani saat install memakai AltStore, Sideloadly, atau tool sideload sejenis dengan Apple ID Anda.

Contoh push pertama dari Windows:

```sh
git init
git add .
git commit -m "Initial Smart Time Management iOS app"
git branch -M main
git remote add origin https://github.com/USERNAME/REPOSITORY.git
git push -u origin main
```

## Catatan Implementasi

MVP ini memakai data lokal sample di `PlannerStore.sample`. Integrasi Supabase, auth, APNs, Firebase Analytics, dan AI provider disiapkan sebagai tahap berikutnya agar fondasi UI/domain bisa dites lebih dulu.
