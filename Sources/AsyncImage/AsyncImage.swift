//
//  AsyncImage.swift
//  OtusHW2
//
//  Created by VLADIMIR LEVTSOV on 15.01.2021.
//

import SwiftUI

public struct AsyncImage<Placeholder: View>: View {
    @StateObject private var loader: ImageLoader
    private let placeholder: Placeholder
    private let image: (UIImage) -> Image
    
    public init?(
        url: URL?,
        @ViewBuilder placeholder: () -> Placeholder,
        @ViewBuilder image: @escaping (UIImage) -> Image = Image.init(uiImage:)
    ) {
        guard let url = url else { return nil }
        self.placeholder = placeholder()
        self.image = image
        _loader = StateObject(wrappedValue: ImageLoader(url: url, cache: Environment(\.imageCache).wrappedValue))
    }
    
    public var body: some View {
        content
            .onAppear(perform: loader.load)
    }
    
    private var content: some View {
        Group {
            if loader.image != nil {
                image(loader.image!)
            } else {
                placeholder
            }
        }
    }
}
