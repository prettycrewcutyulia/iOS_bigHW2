# iOS_bigHW2
Мы постарались расписать как можно подробнее, чтобы проверка была более удобной)

Хорошего дня!)

# Подробно про каждый пункт из ТЗ
## App allows you to register an account
![](/screenshots/регистрация.png)
При этом, если сервер недоступен, то пользователю выведется сообщение об этом:
![](/screenshots/ошибка_при_регистрации.png)
## App allows you to authorize with an existing account
Войти в аккаунт можно также на экране регистрации, только вместо сообщения о созданном аккаунте будет показан главный экран создания комнаты
![](/screenshots/регистрация.png)
## App allows you to log out of the account
На экране создания комнаты можно нажать на стрелочку назад и тем самым разлогиниться
![](/screenshots/logout.png)
## App allows to create a gaming room, which grants admin rights for this room to the creator
Права админа устанавливаются автоматически тому, кто создал комнату

![](/screenshots/создать_комнату.png)

Создание комнаты: можно создать как публичную, так и приватную комнату

![](/screenshots/экран_создания.png)
![](/screenshots/создать_публичную.png)
## App allows admin to delete room
Только у пользователя на главном экране комнаты отображается крестик, при нажатии на который он может удалить комнату

![](/screenshots/удалить_комнату.png)
## Other players can join the gaming room
Пользователь на экране комнат может выбрать существующую, если не хочет создавать свою и присоединиться к ней

![](/screenshots/присоединиться%20в%20публичную.png)
## Other players can leave the gaming room
Пользователь может покинуть комнату, если нажмет на кнопку 

![](/screenshots/выход_из_комнату.png)
## Players can join private rooms using invite code
Если игра приватная, в ячейке с ней отображается иконка замка. И пользователь может войти в нее введя корректный пароля от нее.

![](/screenshots/вход_в_приват.png)
![](/screenshots/ввод_кода_приват.png)
## Players can be removed by the room admin
Просмотр игроков в комнате (доступно только админу)

![](/screenshots/просмотр_игроков.png)
![](/screenshots/удаление_игроков.png)
## Admin can start a game && Admin can pause and then continue the game
Управлять игрой может только админ (только у него отображается кнопка старта/паузы)

![](/screenshots/not_started.png)
![](/screenshots/главный_экран.png)
## Players can put words in clockwise order
Если ход пользователя, то для него станет активно поле, на котором он может выбрать элементы куда хочет поставить буквы

![](/screenshots/выбор.png)

После чего нажать на кнопку Move

Пользователю будет предложено вводить слово побуквенно в формате фишек (Буква, Значение) и нажимать ввод каждый раз
После того, как будет введено достаточное количество букв и будет пройдена валидация, то ход отправится на сервер, где дополнительно провалидируется и в случае успеха установиться на поле. При чем в процессе ввода хода пользователь видит какие буквы он уже ввел)

![](/screenshots/first_chip_move.png)
![](/screenshots/last_chip_move.png)

## Words placed are validated
Перед отправкой запроса на сервер слово валидируется, если валидация не прошла, то запрос не будет отправлен и слово не будет добавлено на поле

![](/screenshots/валидация_хода.png)

## There is scoreboard that is shown to every player that indicates who is closer to victory
При нажатии на звездочку откроется экран с турнирной табоицей игроков

![](/screenshots/star.png)
![](/screenshots/scoreboard.png)

## After game finishes the winner is shown to everyone
Такое сообщение будет показано всем, когда игра будет завершена, при нажатии на Done откроется экран для выбора комнаты

![](/screenshots/wins_message.png)

## The code is written in MVVM or Clean Swift or TCA
Мы выбрали архитектуру MVVM, так что для каждой значимой View есть своя ViewModel

![](/screenshots/mvvm.png)

## unit/integration tests (two or more)
Были написаны unit - тесты

![](/screenshots/unit.png)

## Good code style)))
Это мы стараемся над кодстайлом)

![](/screenshots/кодстайл.png)

P.S. Не судите строго, у нас все таки работа и сессия((

## Empty rooms are deleted

Это происходит автоматически на сервере, так что у нас пользователю не могут быть предложены пустые комнаты)

## Letter tiles left counter is present
Как можно было заметить на экранах выше
![](/screenshots/letter_in_tiles.png)

## Bonus: Any improvement you do to server to make tasks for this group work possible grant you 0.5 points up to 2 points

В процессе мы улучшали свой сервер, что можно найти в ветке server-fixes, где будут коммиты от наших имен)

https://github.com/prettycrewcutyulia/Server_Scrabble/tree/server-fixes

![](/screenshots/доработки.png)


# Важные факты, сделанные нашей командой помимо ТЗ)

Для того, чтобы пользователь всегда имел актуальные данные о статусе игры, количестве карточек в мешке и прочем мы научились пинговать сервер с duration с помощью таймер, а обновлять данные путем подписок на PassthroughSubject. Мы не проходили эти темы в рамках курса, а потому считаем честным получить доп баллы за то, что мы изучили новую тему)))

Пример:

![](/screenshots/Events.png)
![](/screenshots/events_example.png)