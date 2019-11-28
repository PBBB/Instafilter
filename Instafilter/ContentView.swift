//
//  ContentView.swift
//  Instafilter
//
//  Created by Issac Penn on 2019/11/28.
//  Copyright © 2019 Issac Penn. All rights reserved.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct ContentView: View {
    @State private var image: Image?
    @State private var filterIntensity = 0.5
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var currentFilter = CIFilter.sepiaTone()
    let context = CIContext()
    
    var body: some View {
        let intensity = Binding<Double>(
            get: {
                self.filterIntensity
        }) {
            self.filterIntensity = $0
            self.applyProcessing()
        }
        
        return NavigationView {
            VStack {
                ZStack {
                    Rectangle()
                        .fill(Color.secondary)
                    
                    if image != nil {
                        image?
                            .resizable()
                            .scaledToFit()
                    } else {
                        Text("Tap to select a picture")
                            .foregroundColor(.white)
                            .font(.headline)
                    }
                }
                .onTapGesture {
                    self.showingImagePicker = true
                }
                
                HStack {
                    Text("Intensity")
                    Slider(value: intensity)
                }
                .padding(.vertical)
                
                HStack {
                    Button("Save") {
                        
                    }
                }
            }
            .padding([.horizontal, .bottom])
            .navigationBarTitle("Instafilter")
            .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                ImagePicker(image: self.$inputImage)
            }
        }
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        let beginImage = CIImage(image: inputImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        applyProcessing()
    }
    
    func applyProcessing() {
        currentFilter.intensity = Float(filterIntensity)
        
        guard let outputImage = currentFilter.outputImage else { return }
        
        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            let uiImage = UIImage(cgImage: cgimg)
            image = Image(uiImage: uiImage)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
