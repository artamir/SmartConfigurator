// #Использовать logging

Перем Обмен;
// Перем _Лог;

Функция РассчитатьПеремещениеВправо(Данные)
	
	ПозицияСлова = 0;
	
	ДлинаСтр = СтрДлина(Данные);
	Для А = 1 По ДлинаСтр Цикл
		Смв = Сред(Данные, А,1);
		Если Смв = ВРег(Смв) Тогда
			ПозицияСлова = А;
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
	ПозицияСлова = ПозицияСлова - 1;
	
	Возврат ПозицияСлова;
	
КонецФункции

Функция РассчитатьПеремещениеВлево(Данные)
	
	ПозицияСлова = 0;
	
	А = СтрДлина(Данные);
	Пока А > 0 Цикл
		Смв = Сред(Данные, А,1);
		Если Смв = ВРег(Смв) Тогда
			ПозицияСлова = А;
			Прервать;
		КонецЕсли;
		А = А - 1;
	КонецЦикла;
	ПозицияСлова = СтрДлина(Данные) - ПозицияСлова + 1;
	
	Возврат ПозицияСлова;
	
КонецФункции


///////////////////////////////////////////////////////////////////////////////
// Экспортируемые методы для менеджера скриптов
//
Процедура ПереместитьсяВлево() Экспорт
	Результат = РассчитатьПеремещениеВлево(Обмен.ПолучитьТекстИзБуфераОбмена());
	МСПослатьКлавиши = Новый МСПослатьКлавиши;
	Для А = 0 по Результат-1 Цикл
		МСПослатьКлавиши.ПослатьКлавиши("{LEFT}");
	КонецЦикла;
КонецПроцедуры

Процедура ПереместитьсяВправо() Экспорт
	Результат = РассчитатьПеремещениеВправо(Обмен.ПолучитьТекстИзБуфераОбмена());
	МСПослатьКлавиши = Новый МСПослатьКлавиши;
	Для А = 0 по Результат-1 Цикл
		МСПослатьКлавиши.ПослатьКлавиши("{RIGHT}");
	КонецЦикла;
КонецПроцедуры
//
// Экспортируемые методы для менеджера скриптов
///////////////////////////////////////////////////////////////////////////////

// _Лог = Новый ЛогированиеВФайл("tmp/log.log");

Процедура ПриСозданииОбъекта()
	
	Обмен = ЗагрузитьСценарий("core/Обмен.os");

	Парамеры = АргументыКоманднойСтроки;
	Если Парамеры.Количество() = 1 Тогда
		ПараметрОбработки = АргументыКоманднойСтроки[0];
		
		Если НРег(ПараметрОбработки) = "prev" Тогда
			ПереместитьсяВлево();
		ИначеЕсли НРег(ПараметрОбработки) = "next" Тогда
			ПереместитьсяВправо();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры
