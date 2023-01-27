//
//  DashBoardView.swift
//  eADetector
//
//  Created by Allen Davis-Swing on 1/27/23.
//

import SwiftUI

struct DashBoardView: View {
    
    let user: User
    
    var body: some View {
        VStack {
            Text("Hello, \(user.email)")
            Spacer()
        }
    }
}

//struct DashBoardView_Previews: PreviewProvider {
//    static var previews: some View {
//        DashBoardView()
//    }
//}
