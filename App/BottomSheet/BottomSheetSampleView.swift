//
//  BottomSheetSampleView.swift
//  BottomSheet
//
//  Created by Jonatan Ortiz on 10/01/22.
//

import SwiftUI

struct BottomSheetSampleView: View {
  @State var bottomSheetPosition: BottomSheetPosition = .hidden
  @State private var showingAlert = false

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
            bottomSheetPosition = .hidden
            bottomSheetPosition = .top
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
      .padding(.top)
      .padding(20)
    }
    .bottomSheet(position: $bottomSheetPosition, title: "Título teste", resizable: true) {
      Text("HEY")
    }
  }
  
  var buttonsView: AnyView {
    AnyView(
      ZStack {
        ScrollView(.horizontal, showsIndicators: false, content: {
          HStack(spacing: 15){
            VStack(spacing: 8){
              Button(action: {
                withAnimation {
                  bottomSheetPosition = .hidden
                }
              }, label: {
                Image(systemName: "arrowshape.turn.up.right.fill")
                  .font(.title)
                  .frame(width: 65, height: 65)
                  .clipShape(Circle())
              })
              Text("Enviar")
                .foregroundColor(.white)
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
                .foregroundColor(.white)
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
}

struct ToqueBottomSheetSampleView_Previews: PreviewProvider {
  static var previews: some View {
    BottomSheetSampleView()
  }
}
