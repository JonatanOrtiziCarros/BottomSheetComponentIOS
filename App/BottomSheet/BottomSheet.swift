////
////  BottomSheet.swift
////
////
////  Created by Jonatan Ortiz on 29/12/21.
////

import SwiftUI

public struct BottomSheet<Presenting, Content>: View where Presenting: View, Content: View {
  @State private var offset: CGFloat = 0
  @State private var lastOffset: CGFloat = 0
  @State private var screenHeight: CGFloat = UIScreen.main.bounds.height
  @State private var inicialOffset: CGFloat = UIScreen.main.bounds.height
  @Binding private var position: BottomSheetPosition
  @ViewBuilder private var content: () -> Content
  @GestureState private var gestureOffset: CGFloat = 0
  private let opacityLimit: CGFloat = 0.7
  private let title: String
  private let resizable: Bool
  private let presenting: () -> Presenting
  
  //MARK: - Init
  public init(position: Binding<BottomSheetPosition>,
              title: String,
              resizable: Bool,
              presenting: @escaping  () -> Presenting,
              content: @escaping () -> Content
  ) {
    self.title = title
    self._position = position
    self.resizable = resizable
    self.presenting = presenting
    self.content = content
  }
  
  //MARK: - Body View
  public var body: some View {
    ZStack {
      self.presenting()
      Color.black.ignoresSafeArea()
        .opacity(opacity)
        .highPriorityGesture(
          TapGesture()
            .onEnded({ _ in
              withAnimation {
                position = .hidden
              }
            })
        )
      bottomSheetView
    }
    .onChange(of: position) { _ in
      if position != .hidden {
        animatedOnAppear()
      } else {
        animatedWillDisappear()
      }
    }
  }
  
  //MARK: - BottomSheet View
  var bottomSheetView: some View {
    ZStack {
      Color.white
        .clipShape(CustomCorner(corners: [.topLeft,.topRight], radius: 30))
      VStack{
        if !title.isEmpty {
          HStack{
            Text(title)
//              .font(token.theme.font)
              .foregroundColor(Color.gray)
          }
          .padding(.top, 15)
          Divider()
            .background(Color.white)
        }
        content()
          .padding(.top, title.isEmpty ? 30 : 15)
      }
      .padding(.horizontal)
      .frame(minHeight: screenHeight, maxHeight: .infinity, alignment: .top)
    }
    .offset(y: inicialOffset)
    .offset(y: configureOffSet(inicialOffset: inicialOffset))
    .gesture(DragGesture().updating($gestureOffset, body: { value, out, _ in
      out = value.translation.height
      onChange()
    }).onEnded({ _ in
      withAnimation {
        if resizable {
          handleBottomSheetPosition()
        } else if -offset <= position.rawValue * 0.8 {
          position = .hidden
        }
        offset = -position.rawValue
      }
      lastOffset = offset
    }))
  }
  
  //MARK: - Getters
  var resizableCondition: Bool {
    resizable || -offset <= position.rawValue
  }
  
  var opacity: CGFloat {
    return opacityFactor > opacityLimit ? opacityLimit : opacityFactor
  }
  
  private var opacityFactor: CGFloat {
    if resizableCondition {
      return -offset / screenHeight
    } else {
      return position.rawValue / screenHeight
    }
  }
  
  //MARK: - Functions
  func onChange(){
    if resizableCondition {
      DispatchQueue.main.async {
        self.offset = gestureOffset + lastOffset
      }
    }
  }
  
  func handleBottomSheetPosition() {
    if -offset >= screenHeight * 0.75 {
      position = .top
    } else if -offset >= screenHeight * 0.45 {
      position = .middle
    } else if -offset >= screenHeight * 0.25 {
      position = .bottom
    } else {
      position = .hidden
    }
  }
  
  func configureOffSet(inicialOffset: CGFloat) -> CGFloat {
    if resizableCondition {
      return -offset > 0 ? -offset <= inicialOffset ? offset : -inicialOffset : offset
    } else {
      return -offset > -position.rawValue ? -position.rawValue : offset
    }
  }
  
  func animatedOnAppear() {
    DispatchQueue.main.async {
      withAnimation {
        offset = -position.rawValue
        lastOffset = offset
      }
    }
  }
  
  func animatedWillDisappear() {
    DispatchQueue.main.async {
      withAnimation {
        lastOffset = 0
        offset = 0
        inicialOffset = screenHeight
      }
    }
  }
  
}

//MARK:  - Extension
extension View {
  public func bottomSheet<Content>(
    position: Binding<BottomSheetPosition>,
    title: String,
    resizable: Bool,
    content: @escaping () -> Content
  ) -> some View where Content: View {
    return BottomSheet(
      position: position,
      title: title,
      resizable: resizable,
      presenting: { self },
      content: content
    )
  }
}

//MARK:  - Preview
struct SwiftUIView_Previews: PreviewProvider {
  static var previews: some View {
    BottomSheetSampleView()
  }
}
