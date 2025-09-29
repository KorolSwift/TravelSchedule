//
//  Constants.swift
//  TravelSchedule
//
//  Created by Ди Di on 28/09/25.
//

import Foundation

enum Constants {
    enum Story {
        static let previewWidth: CGFloat = 92
        static let previewHeight: CGFloat = 140
        static let bottomPadding: CGFloat = 40
        static let progrBarHeight: CGFloat = 6
        static let progrBarRadius: CGFloat = 6
    }
    
    enum Common {
        static let padding16: CGFloat = 16
        static let height60: CGFloat = 60
        static let height38: CGFloat = 38
        static let errorsHeight: CGFloat = 223
        static let width150: CGFloat = 150
        static let swapCircleSize: CGFloat = 36
        static let checkmarkSize: CGFloat = 24
        static let radioButtonSize: CGFloat = 24
        static let cornerRadius10: CGFloat = 10
        static let cornerRadius12: CGFloat = 12
        static let cornerRadius16: CGFloat = 16
        static let cornerRadius20: CGFloat = 20
        static let cornerRadius24: CGFloat = 24
        static let cornerRadius40: CGFloat = 40
        static let cardHeight104: CGFloat = 104
        static let spacing0: CGFloat = 0
        static let spacing4: CGFloat = 4
        static let spacing8: CGFloat = 8
        static let spacing12: CGFloat = 12
        static let spacing16: CGFloat = 16
    }
    
    enum Stories {
        static let secondsPerStory: TimeInterval = 10
        static let tickInterval: TimeInterval = 0.05
    }
    
    enum Errors {
        static let noRoutes = "Вариантов нет"
        static let noCity = "Город не найден"
        static let noStation = "Станция не найдена"
        static let noInternet = "Нет интернетa"
        static let serverError = "Ошибка сервера"
    }
    
    enum Buttons {
        static let find = "Найти"
        static let apply = "Применить"
        static let refineTime = "Уточнить время"
    }
    
    enum Texts {
        static let appUsing = "Приложение использует API «Яндекс.Расписания»"
        static let version = "Версия 1.0 (beta)"
        static let withTransfer = "С пересадкой"
        static let departureTime = "Время отправления"
        static let optionsWithTransfers = "Показывать варианты с пересадками"
        static let userAgreement = "Пользовательское соглашение"
        static let enterQuery = "Введите запрос"
        static let darkMode = "Темная тема"
        static let carrInfo = "Информация о перевозчике"
        static let contactEmail = "E-mail"
        static let contactPhone = "Телефон"
        static let cityChoice = "Выбор города"
        static let stationChoice = "Выбор станции"
        static let fromLabel = "Откуда"
        static let toLabel = "Куда"
    }
}
