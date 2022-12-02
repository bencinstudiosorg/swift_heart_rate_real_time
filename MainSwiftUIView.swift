//
//  MainSwiftUIView.swift
//  YDY
//
//  Created by David Spurlock on 11/17/22.
//  Copyright © 2022 GST.PID. All rights reserved.
//

import SwiftUI

@available(iOS 13.0, *)
struct MainSwiftUIView: View {
    var body: some View {
        Button(action: {
            Unity.shared.show()
        }){
            Text("")
        }
    }
}

@available(iOS 13.0.0, *)
struct MainSwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        MainSwiftUIView()
    }
}
