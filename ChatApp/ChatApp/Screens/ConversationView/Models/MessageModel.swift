//
//  MessageModel.swift
//  ChatApp
//
//  Created by Dmitrii Zverev on 03.03.2021.
//

import Foundation

protocol MessageCellConfiguration {
    var text: String { get set }
    var isIncoming: Bool { get set }
}


class MessageModel: MessageCellConfiguration {
    var text: String
    var isIncoming: Bool
    
    init(text: String, isIncoming: Bool) {
        self.text = text
        self.isIncoming = isIncoming
    }
    
    static func mockMessages() -> [MessageModel] {
        /*
        return [
            .init(text: "Алексей, ваша программа опять не работает! Достало уже! Я буду жаловаться.",
                  isIncoming: true),
            .init(text: "Добрый день, в чём выражается проблема?",
                  isIncoming: false),
            .init(text: "Не парьте мозги, программа не работает!",
                  isIncoming: true),
            .init(text: "Исправьте! У меня работа стоит!",
                  isIncoming: true),
            .init(text: "Для того чтобы исправить программу, для начала мне нужно узнать, что вы понимаете под проблемой.",
                  isIncoming: false),
            .init(text: "У меня уже очередь в 10 человек!",
                  isIncoming: true),
            .init(text: "Это проблема?",
                  isIncoming: false),
            .init(text: "Проблема!",
                  isIncoming: true),
            .init(text: "Это проблема моей программы?",
                  isIncoming: false),
            .init(text: "Какая разница?",
                  isIncoming: true),
            .init(text: "Вы будете исправлять программу?!",
                  isIncoming: true),
            .init(text: "Буду, но вы можете хотя бы пару раз ответить на поставленные вопросы?",
                  isIncoming: false),
            .init(text: "Я вам оракул, что ли на вопросы отвечать? Я в вашей программе ничего не понимаю",
                  isIncoming: true),
            .init(text: "Скажите только, что именно работает не так",
                  isIncoming: false),
            .init(text: "Ну вы же писали программу!",
                  isIncoming: true),
            .init(text: "УБЕЙ СЕБЯ!",
                  isIncoming: false),
            .init(text: "???",
                  isIncoming: true),
            .init(text: "УБЕЙ СЕБЯ, Я СКАЗАЛ!",
                  isIncoming: false),
            .init(text: "Попрошу не хамить!",
                  isIncoming: true),
            .init(text: "СЛУШАЙ МЕНЯ, ОБЩАТЬСЯ БУДУ ТОЛЬКО С ВАШИМ ДИРЕКТОРОМ, А ТЫ ИДИ В ЛЕС, И ПУСТЬ ТЕБЯ ТАМ ЛЮБЯТ МЕДВЕДИ!!!",
                  isIncoming: false),
            .init(text: "Алексей, это Андрей Сергеевич! Программу только что проверил - всё работает. С твой путевки валяемся падсталом, похоже Лену туда и отправим, снабдив вазелином. ;)",
                  isIncoming: true)
        ]
        */
        
        return [
            .init(text: "Ты тупой идиот. Приходи сегодня на репу.",
                  isIncoming: true),
            .init(text: "Чо?",
                  isIncoming: false),
            .init(text: "Мы сегодня не договаривались",
                  isIncoming: false),
            .init(text: "Да и голова ужасно после вчерашнего болит ",
                  isIncoming: false),
            .init(text: "Будет еще сильнее болеть, когда мы об нее твою басуху разобьем",
                  isIncoming: true),
            .init(text: "что случилось то?",
                  isIncoming: false),
            .init(text: "Ничего не помнишь?",
                  isIncoming: true),
            .init(text: "Ты на барабанах (на каждом) написал маркером \"йа барабанчег\". Да еще так крупно, что теперь все будут думать, что так называется наша группа",
                  isIncoming: true),
            .init(text: "И на гитаре \"йа гитарко\"",
                  isIncoming: true),
            .init(text: "Йа кросавчег)))",
                  isIncoming: false),
            .init(text: "Вот значит почему Витек мне смску прислал \"ты труп\"",
                  isIncoming: false),
            .init(text: "Нет, не по этому",
                  isIncoming: true),
            .init(text: "Мы все утро с анькиного лба \"йа тёлко\" оттирали",
                  isIncoming: true),
            .init(text: "жесть",
                  isIncoming: false),
            .init(text: "Йа идиот",
              isIncoming: false),
        ]
    }
    
    enum MessageType {
        case icoming, outgoing
    }
}
