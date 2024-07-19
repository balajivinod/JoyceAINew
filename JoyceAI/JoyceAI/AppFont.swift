//
//  AppFont.swift
//  JoyceAI
//
//  Created by C119142 on 5/25/24.
//

import Foundation
import SwiftUI

public enum CommonFonts: String, CaseIterable {
  case montserratRegular = "Montserrat-Regular"
  case montserratMedium = "Montserrat-Medium"
  case montserratBold = "Montserrat-Bold"

  /// Invoke this before attempting to use any custom fonts in the app.
  public static func registerFonts() {
      let fontPaths = Bundle.paths(forResourcesOfType: "ttf", inDirectory: "nil")
    for path in fontPaths {
      let url = URL(filePath: path)
      guard
        let fontData = try? Data(contentsOf: url),
        let dataProvider = CGDataProvider(data: fontData as CFData),
        let font = CGFont(dataProvider)
        else {
        // TODO: Should change this to something other than to crash the app
        fatalError("Could not load font \(url.absoluteString) in bundle")
      }

      var errorRef: Unmanaged<CFError>?
      if !CTFontManagerRegisterGraphicsFont(font, &errorRef) {
        // Do not error out here so fonts can be used in previews
//        NCPLogger.logConsole(message: "Could not register font at \(url.absoluteString), error \(errorRef.debugDescription)")
          print("error \(errorRef.debugDescription)")
      }
    }
  }

//  public static func registerCustomFonts() {
//    for font in CommonFonts.allCases {
//      guard let url = Bundle.url(forResource: font.rawValue, withExtension: "ttf") else {
//        return
//      }
//
//      CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
//    }
//  }
}
public struct AppFont: ViewModifier {
  public init(appFont: AppFont, weight: Weight, fontSize: CGFloat, relativeTo: Font.TextStyle) {
    self.appFont = appFont
    self.weight = weight
    self.fontSize = fontSize
    self.relativeTo = relativeTo
  }

  public enum AppFont: String {
    case montserrat = "Montserrat"
    case poppins = "Poppins"
  }

  public enum Weight: String {
    case regular = "Regular"
    case medium = "Medium"
    case semiBold = "SemiBold"
    case bold = "Bold"
  }

  let appFont: AppFont
  let weight: Weight
  let fontSize: CGFloat
  let relativeTo: Font.TextStyle

  public func body(content: Content) -> some View {
    content
      .font(.custom("\(appFont.rawValue)-\(weight.rawValue)", size: fontSize, relativeTo: relativeTo))
  }

  public func font() -> Font {
    Font.custom("\(appFont.rawValue)-\(weight.rawValue)", size: fontSize, relativeTo: relativeTo)
  }
}

extension View {
  public func appFont(_ font: AppFont.AppFont, weight: AppFont.Weight, size: CGFloat, relativeTo: Font.TextStyle) -> some View {
    modifier(AppFont(appFont: font, weight: weight, fontSize: size, relativeTo: relativeTo))
  }
}
