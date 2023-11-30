//
//  SearchView.swift
//  PuraProject
//
//  Created by Jake Gray on 11/30/23.
//

import SwiftUI
import Combine

struct SearchView: View {
    @State var searchTerm: String = ""
    @State var dataState: DataState = .empty
    @State var selectedScope: SearchScope = .dictionary
    
    var body: some View {
        NavigationStack {
            list
        }
    }
    
    // MARK: - List
    
    var list: some View {
        List {
            switch dataState {
            case .empty, .noResults:
                emptyState
            case .searching:
                ProgressView()
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                    .listRowSeparator(.hidden)
            case .word(let word):
                definitionsList(word)
            }
        }
        .listStyle(.plain)
        .searchable(text: $searchTerm, prompt: Text("Search using SwiftUI"))
        /// Didnt have enough time to fully implement
//        .searchScopes($selectedScope, scopes: {
//            ForEach(SearchScope.allCases, id: \.rawValue) { scope in
//                Text(scope.displayName)
//            }
//        })
        .submitLabel(.search)
        .onSubmit(of: .search) {
            search()
        }
        .onChange(of: searchTerm, { oldValue, newValue in
            if newValue.isEmpty {
                dataState = .empty
            }
        })
        .navigationTitle("SwiftUI Search")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: - Definitions List
    
    func definitionsList(_ word: Word) -> some View {
        Section {
            ForEach(Array(word.definitions.enumerated()), id: \.element) { index, def in
                VStack(alignment: .leading, spacing: 4, content: {
                    Text("Definition \(index + 1)")
                        .font(.system(size: 14))
                        .foregroundStyle(Color(uiColor: UIColor.systemGray))
                    Text(def)
                        .font(.system(size: 16))
                        .lineLimit(0)
                        .fixedSize(horizontal: false, vertical: true)
                })
                .listRowSeparator(.hidden)
            }
        } header: {
            Text("Word: \(word.text.capitalized)")
                .font(.system(size: 24, weight: .semibold))
                .listRowSeparator(.hidden)
                .foregroundStyle(.black)
        }
    }
    
    // MARK: - Empty State
    
    var emptyState: some View {
        var imageName: String {
            if case DataState.noResults = dataState {
                return "noResult"
            } else {
                return "dictionarySearch"
            }
        }
        
        var text: String {
            if case DataState.noResults = dataState {
                return NSLocalizedString("No results found for that word! Try another!", comment: "Empty search results message")
            } else {
                return NSLocalizedString("Explore definitions with ease!\n\n Just type your word into the search bar and let the app do the rest.", comment: "Empty search state message")
            }
        }
        
        return VStack {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: UIScreen.main.bounds.width / 2)
            Text(text)
                .font(.system(size: 24, weight: .medium))
                .multilineTextAlignment(.center)
                .foregroundStyle(Color(UIColor.systemGray))
        }
        .frame(maxWidth: .infinity)
        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
        .listRowSeparator(.hidden)
        .padding(.horizontal, 32)
        .padding(.top, 8)
    }
    
    // MARK: - Methods
    
    func search() {
        guard !searchTerm.isEmpty else {
            dataState = .empty
            return
        }
        dataState = .searching
        API.fetchWord(query: searchTerm, isThesaurus: false) { response in
            DispatchQueue.main.async {
                switch response {
                case .success(let wordResponse):
                    self.dataState = .word(wordResponse.word)
                    
                case .failure(let error):
                    self.dataState = .noResults
                    print("NETWORK ERROR: ", error.localizedDescription)
                }
            }
        }
    }
}

#Preview {
    SearchView()
}
