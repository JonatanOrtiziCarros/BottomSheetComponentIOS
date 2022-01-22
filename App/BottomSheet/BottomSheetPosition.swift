//
//  BottomSheetPosition.swift
//  BottomSheet
//
//  Created by Jonatan Ortiz on 10/01/22.
//

import SwiftUI

public enum BottomSheetPosition: CGFloat {
  case top
  case middle
  case bottom
  case hidden
  
  public var rawValue: CGFloat {
    let screenHeight = UIScreen.main.bounds.height
    
    switch self {
    case .top:
      return screenHeight * 0.95
    case .middle:
      return screenHeight * 0.6
    case .bottom:
      return screenHeight * 0.3
    case .hidden:
      return 0
    }
  }
}
