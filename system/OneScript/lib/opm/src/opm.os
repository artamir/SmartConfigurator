///////////////////////////////////////////////////////////////////////////
//
// OneScript Package Manager
// Установщик пакетов для OneScript
// Выполняется, как os-приложение в командной строке:
//
// opm install my-package.ospx
//
////////////////////////////////////////////////////////////////////////
//
// CLI-интерфейс для oscript-app
// 
///////////////////////////////////////////////////////////////////////

#Использовать cmdline
#Использовать "."

Перем Лог;

/////////////////////////////////////////////////////////////////////////////////////////

Функция ПолучитьПарсерКоманднойСтроки()
    
    Парсер = Новый ПарсерАргументовКоманднойСтроки();
    
    МенеджерКомандПриложенияOpm.ЗарегистрироватьКоманды(Парсер);
    
    Возврат Парсер;
    
КонецФункции

Функция ПолезнаяРабота()
    ПараметрыЗапуска = РазобратьАргументыКоманднойСтроки();
    Если ПараметрыЗапуска = Неопределено или ПараметрыЗапуска.Количество() = 0 Тогда
        Лог.Ошибка("Некорректные аргументы командной строки");
        МенеджерКомандПриложенияOpm.ПоказатьСправкуПоКомандам();
        Возврат 1;
    КонецЕсли;
	
	НастройкиПриложенияOpm.УстановитьФайлНастроек(ОбъединитьПути(СтартовыйСценарий().Каталог, "opm.cfg"));

    Если ТипЗнч(ПараметрыЗапуска) = Тип("Структура") Тогда
        // это команда
        Команда            = ПараметрыЗапуска.Команда;
        ЗначенияПараметров = ПараметрыЗапуска.ЗначенияПараметров;
    ИначеЕсли ЗначениеЗаполнено(ПараметрыСистемыOpm.ИмяКомандыПоУмолчанию()) Тогда
        // это команда по-умолчанию
        Команда            = ПараметрыСистемыOpm.ИмяКомандыПоУмолчанию();
        ЗначенияПараметров = ПараметрыЗапуска;
    Иначе
        ВызватьИсключение "Некорректно настроено имя команды по-умолчанию.";
    КонецЕсли;
    
    Возврат МенеджерКомандПриложенияOpm.ВыполнитьКоманду(Команда, ЗначенияПараметров);
    
КонецФункции

Функция РазобратьАргументыКоманднойСтроки()
    Парсер = ПолучитьПарсерКоманднойСтроки();
    Возврат Парсер.Разобрать(АргументыКоманднойСтроки);
КонецФункции

/////////////////////////////////////////////////////////////////////////

Лог = Логирование.ПолучитьЛог(ПараметрыСистемыOpm.ИмяЛогаСистемы());
МенеджерКомандПриложенияOpm.РегистраторКоманд(ПараметрыСистемыOpm);

Попытка
    ЗавершитьРаботу(ПолезнаяРабота());
Исключение
    Лог.КритичнаяОшибка(ОписаниеОшибки());
    ЗавершитьРаботу(255);
КонецПопытки;
