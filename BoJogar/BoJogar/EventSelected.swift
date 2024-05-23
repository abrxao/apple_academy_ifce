//
//  EventSelected.swift
//  BoJogar
//
//  Created by found on 21/05/24.
//

import Foundation
import SwiftUI

import SwiftUI

struct EventSelected: View {
    var image: String
    var title: String
    var description: String
    var local: String
    var horario: String
    
    
    var body: some View {
        ScrollView{
            VStack {
                Image(image)
                    .resizable()
                    .frame(maxWidth: .infinity, maxHeight: 241)
                    .accessibilityLabel(Text(""))
                    .accessibilityHidden(true
                    )
                VStack(alignment:.leading) {
                    Text(title)
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.bottom)
                    Text(description)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .padding(.bottom)
                    Spacer()
                    Text("\(Image(systemName: "location.fill")) Local: Quadra Aécio de Borba  ")
                        .padding(.bottom)
                    Text("\(Image(systemName: "alarm.fill")) Data e Horário: 21/05 às 17:30")
                    
                }
                .padding(.horizontal)
            }
        }
    }
}


struct EventSelectedView : View {
    var body: some View {
        EventSelected(
            image: "Crossfit",
            title: "Academia Physical",
            description: "Descrição vitae lacinia sem rhoncus eu. Sed pharetra nisl erat, ut molestie nisi mollis porttitor. Praesent blandit sem sit amet mollis euismod. Duis in interdum massa. Curabitur ipsum diam, porttitor at tincidunt eu, tincidunt quis erat.",
            local: "",
            horario: ""
        )
    }
}

#Preview {
    EventSelectedView()
}


// comand shift k = limpar o cache
// comand b = compila o project
// se o projeto compilar e o preview nao funcionar: chama os mentores
// se o porjeto compilar e o preview funcionar: deu certo
// .font(.title) - modifica se a fonte é para título, corpo, descrição, etc
// .fontWeight(.bold) - modifica se a fonte é bold e o quanto
// Text("\(Image(systemName: "location.fill")) Local: Quadra Aécio de Borba  ") - Estrutura que permite adicionar ícone do sistema seguido por um texto editável de forma mais elegante
