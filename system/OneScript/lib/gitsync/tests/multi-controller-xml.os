﻿#Использовать logos
#Использовать tempfiles
#Использовать asserts
#Использовать ".."

Перем юТест;
Перем Лог;

Перем мНастройки;
Перем мПараметрыВызоваПакетногоСинхронизатора;

Функция ПолучитьСписокТестов(Тесты) Экспорт
	юТест = Тесты;
	
	Список = Новый Массив;
	Список.Добавить("Тест_ДолженПрочитатьФайлНастроек");
	Список.Добавить("Тест_ДолженПроверитьЧтоВызванОбработчикСинхронизации");
	
	Инициализация();
	
	Возврат Список;
	
КонецФункции

Процедура Инициализация()
	
	ПодключитьСценарий(ОбъединитьПути(ТекущийСценарий().Каталог, "../src/xml-config.os"), "ЧтениеКонфига");
	
	Лог = Логирование.ПолучитьЛог("oscript.app.gitsync");
	Лог.УстановитьУровень(УровниЛога.Отладка);
	
КонецПроцедуры

//////////////////////////////////////////////////////////////////////
// Юнит-тесты

Функция ПрочитатьТестовыеНастройки()
	ФайлНастроек = КаталогFixtures() + "/config.xml";
	ЧтениеКонфига = Новый ЧтениеКонфига();
	мНастройки = ЧтениеКонфига.ПрочитатьНастройкиИзФайла(ФайлНастроек);
	Возврат мНастройки;
КонецФункции

Функция КаталогFixtures()
	Возврат ОбъединитьПути(ТекущийСценарий().Каталог, "fixtures");
КонецФункции

Процедура Тест_ДолженПрочитатьФайлНастроек() Экспорт
	
	ПрочитатьТестовыеНастройки();
	
	// глобальные настройки
	Утверждения.ПроверитьРавенство("server.com", мНастройки.ДоменПочтыДляGit);
	Утверждения.ПроверитьРавенство("1cv8.exe"  , мНастройки.ПутьКПлатформе83);
	Утверждения.ПроверитьРавенство("git"       , мНастройки.ПутьGit);
	
	// репозитарии
	Утверждения.ПроверитьРавенство(2, мНастройки.Репозитарии.Количество());
	
	Утверждения.ПроверитьРавенство("test", мНастройки.Репозитарии[0].Имя);
	Утверждения.ПроверитьРавенство("путь1", мНастройки.Репозитарии[0].КаталогВыгрузки);
	Утверждения.ПроверитьРавенство("адрес1", мНастройки.Репозитарии[0].GitURL);
	Утверждения.ПроверитьРавенство("каталог1", мНастройки.Репозитарии[0].КаталогХранилища1С);
	Утверждения.ПроверитьРавенство(мНастройки.ПутьGit, мНастройки.Репозитарии[0].ПутьGit);
	Утверждения.ПроверитьРавенство(мНастройки.ПутьКПлатформе83, мНастройки.Репозитарии[0].ПутьКПлатформе83);
	Утверждения.ПроверитьРавенство(мНастройки.ДоменПочтыДляGit, мНастройки.Репозитарии[0].ДоменПочтыДляGit);
	
	Утверждения.ПроверитьРавенство("test2", мНастройки.Репозитарии[1].Имя);
	Утверждения.ПроверитьРавенство("путь2", мНастройки.Репозитарии[1].КаталогВыгрузки);
	Утверждения.ПроверитьРавенство("адрес2", мНастройки.Репозитарии[1].GitURL);
	Утверждения.ПроверитьРавенство("каталог2", мНастройки.Репозитарии[1].КаталогХранилища1С);
	Утверждения.ПроверитьРавенство(мНастройки.ПутьGit, мНастройки.Репозитарии[1].ПутьGit);
	Утверждения.ПроверитьРавенство(мНастройки.ПутьКПлатформе83, мНастройки.Репозитарии[1].ПутьКПлатформе83);
	Утверждения.ПроверитьРавенство("gmail.com", мНастройки.Репозитарии[1].ДоменПочтыДляGit);
	
КонецПроцедуры

Процедура Тест_ДолженПроверитьЧтоВызванОбработчикСинхронизации() Экспорт
	ФайлХранилища = ОбъединитьПути(КаталогFixtures(), "ТестовыйФайлХранилища1С.1CD");
	КаталогРепо = ВременныеФайлы.СоздатьКаталог();
	КопироватьФайл(ФайлХранилища, ОбъединитьПути(КаталогРепо, "1cv8ddb.1CD"));
	КаталогИсходников = ОбъединитьПути(КаталогРепо, "src");
	СоздатьКаталог(КаталогИсходников);
	
	РезультатИнициализацииГитЧисло = ИнициализироватьТестовоеХранилищеГит(КаталогРепо);
	Утверждения.ПроверитьРавенство(0, РезультатИнициализацииГитЧисло, "Инициализация git-хранилища в каталоге: "+КаталогРепо);
	
	Распаковщик = Новый МенеджерСинхронизации;
	
	СоздатьФайлАвторовГит_ДляТестов(КаталогИсходников);
	Утверждения.ПроверитьИстину(Новый Файл(ОбъединитьПути(КаталогИсходников, Распаковщик.ИмяФайлаАвторов())).Существует());
	Распаковщик.ЗаписатьФайлВерсийГит(КаталогИсходников,0);
	Утверждения.ПроверитьИстину(Новый Файл(ОбъединитьПути(КаталогИсходников, Распаковщик.ИмяФайлаВерсииХранилища())).Существует());
	
	Настройки = ПрочитатьТестовыеНастройки();
	Настройки.Репозитарии.Удалить(1);
	Настройки.Репозитарии[0].КаталогВыгрузки = КаталогИсходников;
	Настройки.Репозитарии[0].КаталогХранилища1С = КаталогРепо;
	Настройки.Репозитарии[0].ПутьGit = "git";
	
	мПараметрыВызоваПакетногоСинхронизатора = Неопределено;
	ПакетныйСинхронизатор = Новый ПакетнаяСинхронизация;
	ПакетныйСинхронизатор.СинхронизироватьХранилища(Настройки, ЭтотОбъект);
	
	Утверждения.ПроверитьНеравенство(Неопределено, мПараметрыВызоваПакетногоСинхронизатора);
	Утверждения.ПроверитьРавенство("test", мПараметрыВызоваПакетногоСинхронизатора.Имя);
	
КонецПроцедуры

Функция ТребуетсяСинхронизироватьХранилище(Знач Репо) Экспорт
	Возврат Истина;
КонецФункции

Процедура ПриНеобходимостиСинхронизации(Знач Репо) Экспорт
	мПараметрыВызоваПакетногоСинхронизатора = Репо;
КонецПроцедуры

Функция ИнициализироватьТестовоеХранилищеГит(Знач КаталогРепозитория, Знач КакЧистое = Ложь)

	КодВозврата = Неопределено;
	ЗапуститьПриложение("git init" + ?(КакЧистое, " --bare", ""), КаталогРепозитория, Истина, КодВозврата);
	
	Возврат КодВозврата;
	
КонецФункции

Процедура СоздатьФайлАвторовГит_ДляТестов(Знач Каталог)

	ФайлАвторов = Новый ЗаписьТекста;
	ФайлАвторов.Открыть(ОбъединитьПути(Каталог, "AUTHORS"), "utf-8");
	ФайлАвторов.ЗаписатьСтроку("Администратор=Администратор <admin@localhost>");
	ФайлАвторов.ЗаписатьСтроку("Отладка=Отладка <debug@localhost>");
	ФайлАвторов.Закрыть();

КонецПроцедуры