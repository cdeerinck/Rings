//
//  SectionalHeader.swift
//  Rings
//
//  Created by Chuck Deerinck on 6/9/25.
//

import SwiftUI

struct SectionalHeader: View {
    
    @State var label:String
    
    var body: some View {
        HStack {
            Spacer()
            Text(label)
                .font(.system(size: 24, weight: .bold))
                .bold()
                .foregroundColor(Color.white)

            Spacer()
        }
        .padding()
        .background(Color.cyan)
    }
}

#Preview {
    SectionalHeader(label: "Testing")
}
