//
//  BrandLockup.swift
//  SAT Sprint
//
//  Created by Izbassar Orynbassar on 18.01.2026.
//

import SwiftUI

struct BrandLockup: View {
    let assetName: String
    let height: CGFloat

    init(assetName: String = "brand_lockup", height: CGFloat = 26) {
        self.assetName = assetName
        self.height = height
    }

    var body: some View {
        Image(assetName)
            .resizable()
            .scaledToFit()
            .frame(height: height)
            .accessibilityLabel("Sprint")
    }
}
