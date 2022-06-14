# MyHabits – приложение треккер ежедневных привычек.

## Состоит из экранов:
- главный экран - отображения всех созданных привычек
- экран создания новой/редактирования существующей привычки
- экран отображения прогресса привычки в ретроспективе
___

### На главном экране отображается.
- Прогресс выполненных привычек на текущий день
- Данные о привычках: 
   - название привычки
   - запланированное время для выполнения
   - счетчик, сколько раз была выполнена привычка
   - индикатор выполнения на текущий день

При отметке выполнения привычки прогресс заполняется пропорционально количеству созданных привычек.

[![01_main](https://github.com/Amarunseka/MyHabit/blob/develop/assets/small/01_main.png)](https://github.com/Amarunseka/MyHabit/blob/develop/assets/01_main.png)
[![02_main](https://github.com/Amarunseka/MyHabit/blob/develop/assets/small/02_main.png)](https://github.com/Amarunseka/MyHabit/blob/develop/assets/02_main.png)

При нажатии на привычку на главном экране осуществляется переход на экран где отображается сколько раз была выполнена привычка с момента установки приложения.

[![03_progressHabbit](https://github.com/Amarunseka/MyHabit/blob/develop/assets/small/03_progressHabbit.png)](https://github.com/Amarunseka/MyHabit/blob/develop/assets/03_progressHabbit.png)


___
### Создания новой привычки.

Создание новой привычки осуществляется с экрана создания/редактирования привычки  который открывает модально при нажатии на плюс в правом верхнем углу главного экрана.

При создании привычки указывается ее название.
Привычка маркируется цветом с помощью color picker’а 
Устанавливание время выполнения привычки.
После сохранения привычка отображается на главном экране.


[![04_newHabbitEmpty](https://github.com/Amarunseka/MyHabit/blob/develop/assets/small/04_newHabbitEmpty.png)](https://github.com/Amarunseka/MyHabit/blob/develop/assets/04_newHabbitEmpty.png)
[![05_colorPickerGrid](https://github.com/Amarunseka/MyHabit/blob/develop/assets/small/05_colorPickerGrid.png)](https://github.com/Amarunseka/MyHabit/blob/develop/assets/05_colorPickerGrid.png)
[![06_newHabbitNameAndCollor](https://github.com/Amarunseka/MyHabit/blob/develop/assets/small/06_newHabbitNameAndCollor.png)](https://github.com/Amarunseka/MyHabit/blob/develop/assets/06_newHabbitNameAndCollor.png)

___
### Редактирование привычки

При нажатии на кнопку править в правом верхнем углу экрана прогресса привычки, модально открывается экран редактирования привычки где можно поменять параметры привычки или удалить ее. При нажатии на кнопку Отменить/Сохранить осуществляется возврат на предыдущий экран. При нажатии удалить, привычка удаляется и осуществляется переход на главный экран.

[![07_editHabbit](https://github.com/Amarunseka/MyHabit/blob/develop/assets/small/07_editHabbit.png)](https://github.com/Amarunseka/MyHabit/blob/develop/assets/07_editHabbit.png)

___
### Для сохранения пользовательских данных используется User Defaults.
### Сторонние фреймворки не используются  

