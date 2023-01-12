//
//  Languages.swift
//  MovieStar
//
//  Created by obss on 12.01.2023.
//

import Foundation

struct Languages {
    static let en = "English".localized()
    static let es = "Spanish".localized()
    static let fr = "French".localized()
    static let de = "German".localized()
    static let it = "Italian".localized()
    static let pt = "Portuguese".localized()
    static let zh = "Chinese".localized()
    static let ja = "Japanese".localized()
    static let ar = "Arabic".localized()
    static let ru = "Russian".localized()
    static let tr = "Turkish".localized()
    static let hi = "Hindi".localized()
    static let bn = "Bengali".localized()
}

func getLanguage(code: String) -> String {
    switch code {
    case "en":
        return Languages.en
    case "es":
        return Languages.es
    case "fr":
        return Languages.fr
    case "de":
        return Languages.de
    case "it":
        return Languages.it
    case "pt":
        return Languages.pt
    case "zh":
        return Languages.zh
    case "ja":
        return Languages.ja
    case "ar":
        return Languages.ar
    case "ru":
        return Languages.ru
    case "tr":
        return Languages.tr
    case "hi":
        return Languages.hi
    case "bn":
        return Languages.bn
    default:
        return "Code not found"
    }
}



