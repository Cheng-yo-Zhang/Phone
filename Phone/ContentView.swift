//
//  ContentView.swift
//  Phone
//
//  Created by Louis Chang on 2024/12/11.
//

import SwiftUI
import SwiftData
import TipKit
import PermissionsKit
import ContactsPermission

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Contact.name) private var contacts: [Contact]
    @State private var showingAddContact = false
    @State private var searchText = ""
    @State private var showingMaxContactsAlert = false
    // @State private var isAuthorized = false
    private let maxContacts = 10
    
    var filteredContacts: [Contact] {
        if searchText.isEmpty {
            return contacts
        }
        return contacts.filter { contact in
            contact.name.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var body: some View {
//        VStack {
//            Text("通訊錄權限狀態: \(isAuthorized ? "已允許" : "未允許")")
//                .padding()
//            
//            Button("請求通訊錄權限") {
//                requestContactsPermission()
//            }
//            .padding()
//        }
//        .onAppear {
//            checkPermission()
//        }
        NavigationSplitView {
            List {
                ForEach(filteredContacts) { contact in
                    NavigationLink {
                        ContactDetailView(contact: contact)
                    } label: {
                        Text(contact.name)
                    }
                }
                .onDelete(perform: deleteContacts)
            }
            .navigationTitle("聯絡人")
            .searchable(text: $searchText, prompt: "搜尋聯絡人")
            .overlay {
                if contacts.isEmpty {
                    ContentUnavailableView(
                        label: {
                            Label("沒有聯絡人", systemImage: "person.crop.circle.badge.exclamationmark")
                        },
                        description: {
                            Text("點擊右上角的按鈕來新增聯絡人")
                        }
                    )
                } else if !searchText.isEmpty && filteredContacts.isEmpty {
                    ContentUnavailableView.search(text: searchText)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: {
                        if contacts.count >= maxContacts {
                            showMaxContactsAlert()
                        } else {
                            showingAddContact.toggle()
                        }
                    }) {
                        Label("新增聯絡人", systemImage: "person.badge.plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddContact) {
                AddContactView()
            }
            .alert("無法新增聯絡人", isPresented: $showingMaxContactsAlert) {
                Button("確定", role: .cancel) { }
            } message: {
                Text("您已達到最大聯絡人數量限制\(maxContacts)個。請刪除一些聯絡人後再試。")
            }
        } detail: {
            Text("選擇聯絡人")
        }
    }
    
    private func showMaxContactsAlert() {
        showingMaxContactsAlert = true
    }
    
    private func deleteContacts(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(contacts[index])
            }
        }
    }
    
//    private func checkPermission() {
//        isAuthorized = Permission.contacts.authorized
//    }
//    
//    private func requestContactsPermission() {
//        Permission.contacts.request {
//            if Permission.contacts.authorized {
//                HomeView()
//            }
//        }
//    }
}

struct ContactDetailView: View {
    @Environment(\.modelContext) private var modelContext
    let contact: Contact
    @State private var showingEditSheet = false
    
    var body: some View {
        List {
            Section("聯絡資訊") {
                LabeledContent("姓名", value: contact.name)
                LabeledContent("電話", value: contact.phoneNumber)
                LabeledContent("Email", value: contact.email)
                LabeledContent("備註", value: contact.notes)
            }
        }
        .navigationTitle(contact.name)
        .toolbar {
            Button("編輯") {
                showingEditSheet.toggle()
            }
        }
        .sheet(isPresented: $showingEditSheet) {
            EditContactView(contact: contact)
        }
    }
}

struct EditContactView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    let contact: Contact
    
    @State private var name: String
    @State private var phoneNumber: String
    @State private var email: String
    @State private var notes: String
    
    init(contact: Contact) {
        self.contact = contact
        _name = State(initialValue: contact.name)
        _phoneNumber = State(initialValue: contact.phoneNumber)
        _email = State(initialValue: contact.email)
        _notes = State(initialValue: contact.notes)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section ("聯絡資訊"){
                    TextField("姓名", text: $name)
                    TextField("電話", text: $phoneNumber)
                    TextField("Email", text: $email)
                }
                
                Section ("備註"){
                    TextField("備註", text: $notes, axis: .vertical)
                        .lineLimit(5...10)
                }
            }
            .navigationTitle("編輯聯絡人")
            .navigationBarItems(
                leading: Button("取消") { dismiss() },
                trailing: Button("儲存") {
                    contact.name = name
                    contact.phoneNumber = phoneNumber
                    contact.email = email
                    contact.notes = notes
                    dismiss()
                }
                .disabled(name.isEmpty)
            )
        }
    }
}

struct AddContactView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var name = ""
    @State private var phoneNumber = ""
    @State private var email = ""
    @State private var notes = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section ("聯絡資訊"){
                    TextField("姓名", text: $name)
                    TextField("電話", text: $phoneNumber)
                    TextField("Email", text: $email)
                }
                
                Section ("備註"){
                    TextField("備註", text: $notes, axis: .vertical)
                        .lineLimit(5...10)
                }
            }
            .navigationTitle("新增聯絡人")
            .navigationBarItems(
                leading: Button("取消") { dismiss() },
                trailing: Button("儲存") {
                    let contact = Contact(
                        name: name,
                        phoneNumber: phoneNumber,
                        email: email,
                        notes: notes
                    )
                    modelContext.insert(contact)
                    dismiss()
                }
                .disabled(name.isEmpty)
            )
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Contact.self, inMemory: true)
}
