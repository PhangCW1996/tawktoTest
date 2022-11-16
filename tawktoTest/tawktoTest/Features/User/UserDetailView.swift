//
//  UserDetailView.swift
//  tawktoTest
//
//  Created by Superman on 14/11/2022.
//

import SwiftUI
import Combine

struct UserDetailView: View {
    
    init(user: User?) {
        self.vm.user = user
    }
    
    @ObservedObject var vm: UserDetailVM = {
        return UserDetailVM()
    }()
    
    @Environment(\.presentationMode) var presentationMode
    @State private var viewDidLoad = false
    
    @State private var image: Image?
    
    @State private var noteInput = ""
    
    var callback: ((User) -> ())?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                image?
                    .resizable()
                    .frame(height: 150)
                
                HStack(alignment: .center,spacing:8){
                    Text("Follower: \(vm.user?.followers ?? 0)")
                        .foregroundColor(Color.white)
                        .frame(maxWidth: .infinity)
                    Text("Following: \(vm.user?.following ?? 0)")
                        .foregroundColor(Color.white)
                        .frame(maxWidth: .infinity)
                }
                
                ZStack{
                    VStack(alignment: .leading ,spacing: 8){
                        Text("Name: \(vm.user?.name ?? "")").frame(maxWidth: .infinity, alignment: .leading)
                        Text("Blog: \(vm.user?.blog ?? "")").frame(maxWidth: .infinity, alignment: .leading)
                        Text("Company: \(vm.user?.company ?? "")").frame(maxWidth: .infinity, alignment: .leading)
                        
                    }.padding()
                }.border(.blue).padding(.horizontal,16)
                
                Text("Notes:").frame(maxWidth: .infinity,alignment: .leading).padding(.horizontal)
                ZStack{
                    TextEditor(text: $noteInput).padding(.horizontal,8).frame(minHeight:44)
                    
                }.border(.blue).padding(.horizontal,16)
                
                Button("Save") {
                    if noteInput != vm.user?.note{
                        vm.saveNote(note: noteInput)
                    }
                }.padding(.bottom,16)
            }
            .padding(.horizontal,8)
        }
        .padding(.bottom,16)
        .navigationTitle(vm.user?.login ?? "")
        .onAppear {
            if viewDidLoad == false {
                viewDidLoad = true
                bind()
            }
        }
    }
    
    private func bind(){
        //Update Seen
        vm.updateSeen()
        
        vm.apply(.getUserDetail)
        
        vm.$user
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { model in
                
                noteInput = model?.note ?? ""
                
                ImageLoader.shared.loadImage(urlString: model?.avatarUrl ?? "", completion: {_,img in
                    if let img = img{
                        image = Image(uiImage: img)
                    }
                })
                
            })
            .store(in: &vm.cancellables)
        
        vm.$requiredRefresh
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { refresh in
                if refresh{
                    if let user = vm.user{
                        callback?(user)
                    }
                }
            })
            .store(in: &vm.cancellables)
    }
    
}

struct UserDetailView_Previews: PreviewProvider {
    static var previews: some View {
        UserDetailView(user: nil)
    }
}
