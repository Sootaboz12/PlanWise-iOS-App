//
//  HomeView.swift
//  PlanWise
//
//  Created by user278444 on 11/8/25.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \NoteItem.createdAt, order: .reverse) private var notes: [NoteItem]
    @EnvironmentObject var userManager: UserManager
    @State private var showCreateNote = false
    @State private var newNoteTitle = ""
    @State private var imageSearchQuery = ""
    @State private var scrollOffset: CGFloat = 0
    @State private var isSearchingImages = false
    @State private var fetchedImages: [PixabayImage] = []
    @State private var showImagePicker = false
    @State private var showInvalidSearchAlert = false
    @State private var selectedImageURL: String?
    @State private var showPhotoLibrary = false
    @State private var navigateToNewNote: NoteItem?
    @State private var plusButtonScale: CGFloat = 1.0
    @State private var plusButtonRotation: Double = 0.0
    @State private var showWelcomeMessage = false
    @State private var welcomeOpacity: Double = 0
    @State private var welcomeScale: CGFloat = 0.5
    
    private let pixabayService = PixabayService()
    
    // Check if welcome should be shown
    private var shouldShowWelcome: Bool {
        !UserDefaults.standard.bool(forKey: "hasShownWelcomeAnimation")
    }
    
    var showNavigationTitle: Bool {
        scrollOffset < -20
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.appBackground
                    .ignoresSafeArea()
                
                ScrollView {
                    GeometryReader { geometry in
                        Color.clear
                            .preference(key: ScrollOffsetPreferenceKey.self, value: geometry.frame(in: .named("scroll")).minY)
                    }
                    .frame(height: 0)
                    
                    VStack(alignment: .leading, spacing: 0) {
                        // Welcome Title at the top
                        HStack {
                            Spacer()
                            Text("Welcome")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                        .padding(.bottom, 20)
                        
                        LazyVStack(spacing: 16) {
                            if notes.isEmpty {
                                Text("No notes yet\nTap + to create your first note")
                                    .foregroundColor(.white.opacity(0.6))
                                    .font(.headline)
                                    .multilineTextAlignment(.center)
                                    .padding(.top, 50)
                            } else {
                                ForEach(Array(notes.enumerated()), id: \.element.id) { index, note in
                                    NavigationLink(destination: NoteDetailView(note: note)) {
                                        NoteCardView(note: note)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    .onTapGesture {
                                        userManager.openNote(note.id)
                                    }
                                    .transition(.asymmetric(
                                        insertion: .opacity.combined(with: .move(edge: .trailing)),
                                        removal: .opacity.combined(with: .move(edge: .leading))
                                    ))
                                    .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(Double(index) * 0.1), value: notes.count)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 16)
                        
                        // Hidden NavigationLink for programmatic navigation
                        NavigationLink(
                            destination: navigateToNewNote.map { NoteDetailView(note: $0) },
                            isActive: Binding(
                                get: { navigateToNewNote != nil },
                                set: { if !$0 { navigateToNewNote = nil } }
                            )
                        ) {
                            EmptyView()
                        }
                        .hidden()
                    }
                }
                .coordinateSpace(name: "scroll")
                .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                    scrollOffset = value
                }
                .navigationTitle(showNavigationTitle ? "My Notes" : "")
                .navigationBarTitleDisplayMode(.inline)
                .toolbarColorScheme(.dark, for: .navigationBar)
                .toolbarBackground(Color.appBackground, for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                plusButtonScale = 0.8
                                plusButtonRotation += 90
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                    plusButtonScale = 1.0
                                }
                            }
                            
                            showCreateNote = true
                        }) {
                            Image(systemName: "plus")
                                .foregroundColor(.white)
                                .font(.title2)
                                .scaleEffect(plusButtonScale)
                                .rotationEffect(.degrees(plusButtonRotation))
                        }
                    }
                }
                .alert("Create New Note", isPresented: $showCreateNote) {
                    TextField("Note Title", text: $newNoteTitle)
                    TextField("Image Search (e.g. mountains)", text: $imageSearchQuery)
                    Button("Cancel", role: .cancel) {
                        resetNoteCreation()
                    }
                    Button("Photo Library") {
                        showPhotoLibrary = true
                    }
                    Button("Search Images") {
                        searchForImages()
                    }
                } message: {
                    Text("Enter a title and search term for an image")
                }
                .alert("Invalid Search", isPresented: $showInvalidSearchAlert) {
                    Button("OK", role: .cancel) { }
                } message: {
                    Text("No images found for your search term. Please try a different search.")
                }
                .sheet(isPresented: $showImagePicker) {
                    ImagePickerView(images: fetchedImages) { imageURL in
                        selectedImageURL = imageURL
                        createNote()
                    }
                }
                .sheet(isPresented: $showPhotoLibrary) {
                    PhotoLibraryPicker { image in
                        handlePhotoLibrarySelection(image)
                    }
                }
                
                if isSearchingImages {
                    ZStack {
                        Color.black.opacity(0.4)
                            .ignoresSafeArea()
                        
                        VStack(spacing: 20) {
                            ProgressView()
                                .scaleEffect(1.5)
                                .tint(.white)
                            
                            Text("Searching for images...")
                                .foregroundColor(.white)
                                .font(.headline)
                        }
                        .padding(40)
                        .background(Color.appBackground)
                        .cornerRadius(20)
                    }
                }
                
                // Welcome Message Overlay
                if showWelcomeMessage {
                    ZStack {
                        Color.black.opacity(0.8)
                            .ignoresSafeArea()
                            .opacity(welcomeOpacity)
                        
                        VStack(spacing: 20) {
                            Text("Welcome \(userManager.userName),")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text("time to PlanWise!")
                                .font(.system(size: 28, weight: .semibold))
                                .foregroundColor(.appPurple)
                        }
                        .scaleEffect(welcomeScale)
                        .opacity(welcomeOpacity)
                    }
                    .onAppear {
                        // Mark that welcome has been shown
                        UserDefaults.standard.set(true, forKey: "hasShownWelcomeAnimation")
                        
                        withAnimation(.easeIn(duration: 0.5)) {
                            welcomeOpacity = 1.0
                        }
                        
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.2)) {
                            welcomeScale = 1.0
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                            withAnimation(.easeOut(duration: 0.5)) {
                                welcomeOpacity = 0.0
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                showWelcomeMessage = false
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            // Check if we should show welcome animation on first launch
            if shouldShowWelcome {
                showWelcomeMessage = true
            }
        }
    }
    
    func searchForImages() {
        guard !newNoteTitle.trimmingCharacters(in: .whitespaces).isEmpty else {
            resetNoteCreation()
            return
        }
        
        // Determine which search query to use
        let searchQuery: String
        let shouldShowPicker: Bool
        
        if imageSearchQuery.trimmingCharacters(in: .whitespaces).isEmpty {
            // Use note title as search query and auto-select first image
            searchQuery = newNoteTitle
            shouldShowPicker = false
        } else {
            // User provided search query, show picker
            searchQuery = imageSearchQuery
            shouldShowPicker = true
        }
        
        isSearchingImages = true
        
        Task {
            do {
                let images = try await pixabayService.searchImages(query: searchQuery, perPage: 6)
                
                await MainActor.run {
                    isSearchingImages = false
                    
                    if shouldShowPicker {
                        // User provided search query - show picker
                        if images.count >= 6 {
                            fetchedImages = Array(images.prefix(6))
                            showImagePicker = true
                        } else if !images.isEmpty {
                            // Less than 6 but some results
                            fetchedImages = images
                            showImagePicker = true
                        } else {
                            // No results
                            showInvalidSearchAlert = true
                            resetNoteCreation()
                        }
                    } else {
                        // Auto-select first image from title search
                        if let firstImage = images.first {
                            selectedImageURL = firstImage.webformatURL
                            createNote()
                        } else {
                            // No results from title, try random image
                            searchForRandomImage()
                        }
                    }
                }
            } catch {
                await MainActor.run {
                    isSearchingImages = false
                    
                    if shouldShowPicker {
                        showInvalidSearchAlert = true
                        resetNoteCreation()
                    } else {
                        // Failed to get image from title, try random
                        searchForRandomImage()
                    }
                }
            }
        }
    }
    
    func searchForRandomImage() {
        Task {
            do {
                // Search for a generic term to get random images
                let randomTerms = ["nature", "abstract", "landscape", "city", "ocean", "forest", "sky", "mountain"]
                let randomTerm = randomTerms.randomElement() ?? "nature"
                
                let images = try await pixabayService.searchImages(query: randomTerm, perPage: 20)
                
                await MainActor.run {
                    isSearchingImages = false
                    
                    if let randomImage = images.randomElement() {
                        selectedImageURL = randomImage.webformatURL
                    }
                    createNote()
                }
            } catch {
                await MainActor.run {
                    isSearchingImages = false
                    // Create note without image if random search also fails
                    createNote()
                }
            }
        }
    }
    
    func createNote() {
        guard !newNoteTitle.trimmingCharacters(in: .whitespaces).isEmpty else {
            resetNoteCreation()
            return
        }
        
        let newNote = NoteItem(title: newNoteTitle, imageURL: selectedImageURL)
        modelContext.insert(newNote)
        
        do {
            try modelContext.save()
            userManager.openNote(newNote.id)
            
            // Navigate to the new note detail view
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                navigateToNewNote = newNote
            }
        } catch {
            print("Error saving note: \(error)")
        }
        
        resetNoteCreation()
    }
    
    func resetNoteCreation() {
        newNoteTitle = ""
        imageSearchQuery = ""
        selectedImageURL = nil
        fetchedImages = []
    }
    
    func handlePhotoLibrarySelection(_ image: UIImage) {
        guard !newNoteTitle.trimmingCharacters(in: .whitespaces).isEmpty else {
            resetNoteCreation()
            return
        }
        
        // Create a temporary note to get its ID
        let tempId = UUID()
        
        // Save the image locally
        if let localPath = ImageStorageManager.shared.saveImage(image, withId: tempId) {
            selectedImageURL = localPath
            createNoteWithId(tempId)
        } else {
            createNote()
        }
    }
    
    func createNoteWithId(_ id: UUID) {
        guard !newNoteTitle.trimmingCharacters(in: .whitespaces).isEmpty else {
            resetNoteCreation()
            return
        }
        
        let newNote = NoteItem(title: newNoteTitle, imageURL: selectedImageURL)
        newNote.id = id // Use the same ID we used to save the image
        modelContext.insert(newNote)
        
        do {
            try modelContext.save()
            userManager.openNote(newNote.id)
            
            // Navigate to the new note detail view
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                navigateToNewNote = newNote
            }
        } catch {
            print("Error saving note: \(error)")
        }
        
        resetNoteCreation()
    }
}

// MARK: - Scroll Offset Preference Key
struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
