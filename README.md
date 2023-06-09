# TestAppMobileUp
Это тестовое приложение, которое показывает работу с VK iOS SDK.

## Framework 
Документация: [iOS SDK](https://vk.com/dev/ios_sdk)
``` swift 
import VKSdkFramework
```

## Installation
Ресурс: [Git(fork) SPM](https://github.com/abesmon/vk-ios-sdk)

## Возможности приложения
- Приложение позволяет пользователю войти в приложение через свой аккаунт vk.com
- Спрашивает разрешенение на использование данных пользователя
- Направляет на альбом с фотографиями компании MobileUp
- Показывает каждую фотографию (и дату) в отдельном окне

## Декомпозиция задания
1. Создание ветки develop ~ 2 мин.
2. Создание ветки feature/ButtonLabelForAuthVC ~ 2 мин.
 - Добавление лейбла ~ 3 мин.
  - Добавление кнопки ~ 4 мин.
3. Cоздание ветки feature/loginWithVK ~ 2 мин.
 - Добавление фреймворка VKSdkFramework. Были трудности с установкой, так как ничего не работает и не поддерживается(cocoaPods, Carthage), нашел форк человека и загрузил через SPM(Swift Package Manager). Поэтому так много времени ушло. ~ 5часа
  - Добавление самой авторизации ~ 2 часа
4. Создание ветки feature/AlbumVC ~ 2 мин.
 - Создание макета отображения вьюшек ~ 1 час.
  - Подключение network service ~ 3 час.
   - Настройка загрузки данных ~ 2 час.
    - Подключение архитектуры Clean Swift (VIP) и настройка ~ 3 час.
    - Refactoring ~ 1 час.
5. Создание ветки feature/photoFullScreen ~ 2 мин.
 - Создание нового контролера для отображения фото и даты ~ 1 час.
  - Настройка получения и загрузки данных ~ 3 час.
   - Добавление кнопки "Сохранить фото" и ее настройка ~ 1 час.
6. Создание ветки feature/DarkTheme ~ 2 мин.
 - Добавление и настройка Тёмной темы для приложения ~ 20 мин.
7. Создание ветки feature/ModalPresent ~ 2 мин.
 - Добавление и настройка модального вида окна авторизации ~ 20 мин.
8. Создание ветки feature/FeedPhotos ~ 2 мин.
 - Добавление ленты фотографий под главным фото, настройка нажатия на фото в ленте ~ 2 час.
9. Создание ветки feature/ZoomPhoto ~ 2 мин.
 - Добавление и настройка увеличения главного фото двумя пальцами ~ 30 мин.
10. Создание ветки feature/SharedMenu ~ 2 мин.
 - Добавление и настройка меню поделиться(сохранить) фотографией(ю) ~ 20 мин.
 - Добавление иконки приложение и настройка визуала LaunchScreen - 15 мин.

<img src="https://sun9-42.userapi.com/impf/c851520/v851520486/666b2/RKkvSsJ_DMw.jpg?size=801x801&quality=96&sign=52f883c8c27171549bf2208ea35dd6b5&type=album" width="400" />
