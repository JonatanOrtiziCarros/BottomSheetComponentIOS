//
//  BottomSheetContent.swift
//  BottomSheet
//
//  Created by jonatan on 16/12/21.
//

import SwiftUI

enum BottomSheetContent {
  case listView, buttonsView, buttonsSocialMediaView
}

struct MainView: View {
  @State private var text: String = ""
  @State private var showingAlert = false
  @State private var bottomSheetContent: BottomSheetContent = .listView
  @State private var bottomSheetPosition: BottomSheetPosition = .hidden

  var body: some View {
    GeometryReader { proxy in
      let frame = proxy.frame(in: .global)
      Image("bg")
        .resizable()
        .aspectRatio(contentMode: .fill)
        .frame(width: frame.width, height: frame.height + 90)
        .ignoresSafeArea()
      VStack {
        VStack(spacing: 4){
          Button(action: {
            bottomSheetContent = .buttonsView
            bottomSheetPosition = .bottom
          }, label: {
            Image(systemName: "list.bullet.rectangle")
              .font(.title)
              .frame(width: 65, height: 65)
              .clipShape(Circle())
          })
          Text("Ver opções")
            .foregroundColor(.blue)
        }
      }
      .padding(.top)
      .padding(20)
    }
    .bottomSheet(position: $bottomSheetPosition, title: "Título teste", resizable: true) {
      content
    }
  }

  var listView: AnyView {
    AnyView(
      ZStack {
        ScrollView(.vertical, showsIndicators: false, content: {
          VStack(alignment: .leading, spacing: 15) {
            ForEach(["Opção 1", "Opção 2", "Opção 3", "Opção 4"], id: \.self) { label in
              Button(action: {
                text = label
                withAnimation {
                  bottomSheetPosition = .hidden
                }
              }, label: { Text(label).foregroundColor(.black) })
            }
          }
          .padding(.leading)
          .frame(maxWidth: .infinity, alignment: .leading)
        }
        )}
    )
  }

  var buttonsView: AnyView {
    AnyView(
      ZStack {
        ScrollView(.horizontal, showsIndicators: false, content: {
          HStack(spacing: 15){
            VStack(spacing: 8){
              Button(action: {
                withAnimation {
                  bottomSheetContent = .buttonsSocialMediaView
                }
              }, label: {
                Image(systemName: "arrowshape.turn.up.right.fill")
                  .font(.title)
                  .frame(width: 65, height: 65)
                  .clipShape(Circle())
              })
              Text("Enviar")
                .foregroundColor(.blue)
            }
            VStack(spacing: 8){
              Button(action: {
                showingAlert = true
              }, label: {
                Image(systemName: "trash.fill")
                  .font(.title)
                  .frame(width: 65, height: 65)
                  .clipShape(Circle())
              })
              Text("Excluir")
                .foregroundColor(.blue)
            }

          }
        })
          .padding(.top)
      }
        .alert(isPresented:$showingAlert) {
          Alert(
            title: Text("Excluir"),
            message: Text("Tem certeza que deseja excluir essa publicação?"),
            primaryButton: .destructive(Text("Excluir")) {
              withAnimation {
                bottomSheetPosition = .hidden
              }
            },
            secondaryButton: .cancel(Text("Cancelar"))
          )
        }
    )
  }

  var buttonsSocialMediaView: AnyView {
    AnyView(
      ZStack {
        ScrollView(.horizontal, showsIndicators: false, content: {
          HStack(spacing: 15){
            ForEach(["messenger", "instagram", "whatsapp"], id: \.self) { icon in
              VStack(spacing: 8){
                Button(action: {
                  withAnimation {
                    bottomSheetPosition = .hidden
                  }
                }, label: {
                  Image(icon)
                    .resizable()
                    .font(.title)
                    .frame(width: 65, height: 65)
                    .clipShape(Circle())
                })
              }
            }
          }
        })
          .padding(.top)
      }
        .alert(isPresented:$showingAlert) {
          Alert(
            title: Text("Excluir"),
            message: Text("Tem certeza que deseja excluir essa publicação?"),
            primaryButton: .destructive(Text("Excluir")) {
              withAnimation {
                bottomSheetPosition = .hidden
              }
            },
            secondaryButton: .cancel(Text("Cancelar"))
          )
        }
    )
  }

  var content: AnyView {
    switch bottomSheetContent {
    case .listView:
      return listView
    case .buttonsView:
      return buttonsView
    case .buttonsSocialMediaView:
      return buttonsSocialMediaView
    }
  }

}

struct MainView_Previews: PreviewProvider {
  static var previews: some View {
    MainView()
  }
}

