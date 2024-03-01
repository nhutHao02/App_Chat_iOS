//
//  NewMassageView.swift
//  AppChat
//
//  Created by TranHao on 28/02/2024.
//

import SwiftUI

struct NewMassageView: View {
    let didUserSelected: (User) -> (Void)
    @ObservedObject var viewModel = NewMessageViewModel()
    
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        VStack(){
            // toolbar
            HStack{
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Cancel")
                        .font(.system(size: 18))
                }
                .frame(width: 70)
                Spacer()
                Text("New Message")
                    .font(.system(size: 18))
                Spacer()
                Text("")
                    .frame(width: 70)
                
            }
            .padding(.horizontal, 10)
            
            SearchBarView(text: $viewModel.searchText)
                .padding(.horizontal, 10)
            ScrollView{
                LazyVStack{
                    ForEach(viewModel.searchedUser) { user in
                        Button {
                            didUserSelected(user)
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            HStack(alignment: .center){
                                if let url = user.urlIMG {
                                    if url != "" &&  url != " "{
                                        ImageUserView(nameIMG: url, typeIMG: true, size: 50)
                                    } else {
                                        ImageUserView(nameIMG: "person.fill", typeIMG: false, size: 50)
                                    }
                                }
                                Text(user.fullName)
                                Spacer()
                            }
                            .padding(.horizontal, 5)
                        }
                        .foregroundColor(Color(.label))
                    }
                }
                .padding(.horizontal, 15)
            }
            Spacer()
        }
        
    }
}

struct NewMassageView_Previews: PreviewProvider {
    static var previews: some View {
//        NewMassageView()
        MainMessageView()
    }
}
