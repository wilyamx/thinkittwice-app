//
//  NewsView.swift
//  DailyTraining-SwiftUI
//
//  Created by William Rena on 6/6/23.
//

import SwiftUI

struct NewsView: View {
    var cat: Cat
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            WSRWebImage(url: cat.imageUrl())
                .frame(width: UIScreen.main.bounds.width - 40, height: 200)
                .overlay(alignment: .topLeading) {
                    VStack(alignment: .leading) {
                        Text("Market News")
                            .fontWeight(.bold)
                            .padding([.top, .leading])
                            .foregroundColor(.white)
                            .textCase(.uppercase)

                        Spacer()

                        Text(cat.altNames)
                            .lineLimit(4)
                            .padding([.leading, .trailing, .bottom])
                    }
                }
                .foregroundColor(Color.white)
                .background(Color.secondary.opacity(0.5))
                .clipped()
                .cornerRadius(15)
                .padding(.top)
                    
            // Footer View
            footerView
        }
    }
    
    @ViewBuilder
    private var footerView: some View {
        HStack {
            HStack(spacing: 20) {
                HStack(spacing: 0) {
                    Image(systemName: "heart")
                    Text(String("12"))
                        .fontWeight(.bold)
                }
                
                HStack(spacing: 0) {
                    Image(systemName: "bubble.left")
                    Text(String("223"))
                        .fontWeight(.bold)
                }
            }
            
            Spacer()
            
            Text(String("JAN 1ST"))
                .foregroundColor(Color.gray)
        }
        .padding(.bottom)
    }
}

struct NewsView_Previews: PreviewProvider {
    /**
        https://www.mongodb.com/docs/realm/sdk/swift/swiftui/swiftui-previews/
     */
    static var previews: some View {
        List {
            let realm = MockRealms.previewRealm
            let cats = realm.objects(Cat.self)
            let rowSpacing: CGFloat = 10.0
            
            if let cat = cats.first {
                Group {
                    NewsView(cat: cat)
                }
                .listRowSeparator(.hidden)
                .listRowBackground(
                    RoundedRectangle(cornerRadius: 15)
                        .padding(EdgeInsets(top: rowSpacing,
                                            leading: rowSpacing,
                                            bottom: rowSpacing,
                                            trailing: rowSpacing))
                        .background(.clear)
                        .foregroundColor(.white)
                )
            }
        }
        .listStyle(.plain)
        .background(ColorNames.listBackgroundColor.colorValue)
        .buttonStyle(.borderless)
        .previewDisplayName("en")
        .environment(\.locale, .init(identifier: "en"))
        
        List {
            let realm = MockRealms.previewRealm
            let cats = realm.objects(Cat.self)
            let rowSpacing: CGFloat = 10.0
            
            if let cat = cats.first {
                Group {
                    NewsView(cat: cat)
                }
                .listRowSeparator(.hidden)
                .listRowBackground(
                    RoundedRectangle(cornerRadius: 15)
                        .padding(EdgeInsets(top: rowSpacing,
                                            leading: rowSpacing,
                                            bottom: rowSpacing,
                                            trailing: rowSpacing))
                        .background(.clear)
                        .foregroundColor(.white)
                )
            }
        }
        .listStyle(.plain)
        .background(ColorNames.listBackgroundColor.colorValue)
        .buttonStyle(.borderless)
        .previewDisplayName("fr")
        .environment(\.locale, .init(identifier: "fr"))
        
        List {
            let realm = MockRealms.previewRealm
            let cats = realm.objects(Cat.self)
            let rowSpacing: CGFloat = 10.0
            
            if let cat = cats.first {
                Group {
                    NewsView(cat: cat)
                }
                .listRowSeparator(.hidden)
                .listRowBackground(
                    RoundedRectangle(cornerRadius: 15)
                        .padding(EdgeInsets(top: rowSpacing,
                                            leading: rowSpacing,
                                            bottom: rowSpacing,
                                            trailing: rowSpacing))
                        .background(.clear)
                        .foregroundColor(.white)
                )
            }
        }
        .listStyle(.plain)
        .background(ColorNames.listBackgroundColor.colorValue)
        .buttonStyle(.borderless)
        .previewDisplayName("ar")
        .environment(\.locale, .init(identifier: "ar"))
    }
}
