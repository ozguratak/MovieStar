//
//  String Extensions.swift
//  MovieStar
//
//  Created by obss on 4.07.2022.
//

import Foundation
import UIKit

extension String{
    
    var urlEncoded: String? {
        let allowedCharacterSet = CharacterSet.alphanumerics.union(CharacterSet(charactersIn: "~-_."))
        return self.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet)
    }
     func toCurrencyFormat() -> String {
        if let intValue = Int(self){
           let numberFormatter = NumberFormatter()
           numberFormatter.locale = Locale(identifier: "en_US")
           numberFormatter.numberStyle = NumberFormatter.Style.currency
           return numberFormatter.string(from: NSNumber(value: intValue)) ?? ""
      }
    return ""
  }
    func localized() -> String {
        return NSLocalizedString(self, tableName: "Localizable", bundle: .main, value: self, comment: self)
    }
    
   
    
    func withBoldText(text: String, font: UIFont? = nil) -> NSAttributedString {
      let _font = font ?? UIFont.systemFont(ofSize: 14, weight: .regular)
      let fullString = NSMutableAttributedString(string: self, attributes: [NSAttributedString.Key.font: _font])
      let boldFontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: _font.pointSize)]
      let range = (self as NSString).range(of: text)
      fullString.addAttributes(boldFontAttribute, range: range)
      return fullString
    }
}


