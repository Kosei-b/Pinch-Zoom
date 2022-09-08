//
//  ContentView.swift
//  Pinch&Zoom
//
//  Created by Kosei Ban on 2022-09-05.
//

import SwiftUI

struct ContentView: View {
    //MARK: Proparty
    
    @State private var isAnimating: Bool = false
    @State private var imageScale: CGFloat = 1
    @State private var imageOffset: CGSize = .zero
    @State private var isDrawerOpen: Bool = false
    
    let hapticFeedback = UINotificationFeedbackGenerator()
    let pages: [Page] = pagesDate
    @State private var pageIndex: Int = 1
    
    //MARK: Function
    
    func resetImageState() {
        return withAnimation(.spring()) {
            imageScale = 1
            imageOffset = .zero
        }
    }
    
    func currentPage() -> String {
        return pages[pageIndex - 1].imageName
    }
    //MARK: Content
    
    var body: some View {
        
        NavigationView{
            ZStack{
                Color.clear
                //MARK: Page-Image
                Image(currentPage())
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(15)
                    .padding()
                    .shadow(color: .black.opacity(0.2), radius: 12, x: 2, y: 2)
                    .opacity(isAnimating ? 1 : 0)
                    .scaleEffect(imageScale)
                    .offset(x: imageOffset.width, y: imageOffset.height)
                
                //MARK: 1 TapGesture
                    .onTapGesture(count: 2, perform: {
                        if imageScale == 1 {
                            withAnimation(.spring()){
                                imageScale = 2.5
                            }
                        } else {
                            resetImageState()
                        }
                    })
                //MARK: 2 DragGesture
                    .gesture(
                        DragGesture()
                            .onChanged({ value in
                                withAnimation(.linear(duration: 1)) {
                                    imageOffset = value.translation
                                }
                            })//: Changed
                            .onEnded({ _ in
                                if imageScale <= 1 {
                                    resetImageState()
                                }
                            })//: Ended
                    )//: Gesture
                //MARK: Magunification
                    .gesture(
                        MagnificationGesture()
                            .onChanged({ value in
                                withAnimation(.linear(duration: 1)){
                                    if imageScale >= 1 && imageScale <= 8 {
                                        imageScale = value
                                    } else if imageScale > 8 {
                                        imageScale = 8
                                    } else if imageScale < 1 {
                                        imageScale = 1
                                    }
                                }
                            })//: Changed
                        
                            .onEnded({ _ in
                                if imageScale > 8 {
                                    imageScale = 8
                                    
                                } else if imageScale < 1 {
                                    resetImageState()
                                }
                            })
                    )
            }//: ZStack
            .navigationTitle("Pinch & Zoom")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                withAnimation(.linear(duration: 1)){
                    isAnimating = true
                }
            }
            //MARK: Info Panel
            .overlay(
                InfoPanelView(scale: imageScale, offset: imageOffset)
                    .padding(.horizontal)
                    .padding(.top, 30)
                    .opacity(isAnimating ? 1 : 0)
                ,alignment: .top
            )
            //MARK: Control Panel
            .overlay(
                Group{
                    HStack{
                        // Scale down
                        Button {
                            withAnimation(.spring()){
                                
                                if imageScale > 1{
                                    imageScale -= 1
                                    if imageScale <= 1 {
                                        resetImageState()
                                    }
                                }
                            }
                        } label: {
                            ControlImageView(icon: "minus.magnifyingglass")
                        }
                        
                        // Reset
                        Button {
                            hapticFeedback.notificationOccurred(.warning)
                            resetImageState()
                            
                        } label: {
                            ControlImageView(icon: "arrow.up.left.and.down.right.magnifyingglass")
                        }
                        
                        // Scale up
                        
                        Button {
                            withAnimation(.spring()){
                                if imageScale < 8 {
                                    imageScale += 1
                                    
                                    if imageScale >= 8 {
                                        imageScale = 8
                                    }
                                }
                            }
                        } label: {
                            ControlImageView(icon: "plus.magnifyingglass")
                        }
                    }//: HStack
                    .padding(EdgeInsets(top: 12, leading: 20, bottom: 12, trailing: 20))
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
                    .opacity( isAnimating ? 1 : 0)
                    
                }// Group
                    .padding(.bottom, 30)
                ,alignment: .bottom
            )
            //MARK: Drawer
            .overlay(
                HStack(spacing: 12){
                    //MARK: Drawer handle
                    Image(systemName: isDrawerOpen ?       "chevron.compact.right" : "chevron.compact.left")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 40)
                        .padding(8)
                        .foregroundStyle(.secondary)
                        .onTapGesture(perform: {
                            withAnimation(.easeOut(duration: 0.5)){
                                isDrawerOpen.toggle()
                            }
                        })
                    
                    //MARK: Thumbnails
                    
                    ScrollView(.horizontal){
                        HStack{
                            ForEach(pages) { item in
                                Image(item.thumnailName)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width:80, height: 100)
                                    .cornerRadius(10)
                                    .shadow(radius: 4)
                                    .opacity(isDrawerOpen ? 1 : 0)
                                    .animation(.easeOut(duration: 0.5), value: isDrawerOpen)
                                    .onTapGesture {
                                        isAnimating = true
                                        pageIndex = item.id
                                    }
                            }
                        }
                    }
                    
                    Spacer()
                }//: Drawer
                    .padding(EdgeInsets(top: 16, leading: 8, bottom: 16, trailing: 8))
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
                    .opacity(isAnimating ? 1 : 0)
                    .frame(width: 240)
                    .offset(x: isDrawerOpen ? 20 : 180)
                    .padding(.top , UIScreen.main.bounds.height / 12)
                ,alignment: .topTrailing
            )//: Drawer overray
            
        }//: NavigationView
        .navigationViewStyle(.stack)
    }
}

//MARK: PreView

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .previewDevice("iPhone 13")
                .preferredColorScheme(.dark)
            
        }
    }
}
