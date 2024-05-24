//
//  AvatarEventUser.swift
//  BoJogar
//
//  Created by found on 23/05/24.
//

import Foundation
import SwiftUI

struct AvatarEventUser: View {
    var imageURL: String

    var body: some View {
        ImageURL(url: URL(string: imageURL)!)
            .aspectRatio(1, contentMode: .fit)
            .containerRelativeFrame(.horizontal, count: 16, span: 3, spacing: 0,alignment: .topLeading)
            .background(.redSecondary) // Add background color to each item
            .cornerRadius(.infinity)
    }
}
