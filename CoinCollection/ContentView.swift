import SwiftUI

// MARK: - Модель монеты
struct Coin: Identifiable, Codable, Equatable {
    let id: UUID
    var country: String
    var denomination: String
    var year: Int
    var material: String
    var marketPrice: Double
    var imageData: Data?
    var description: String
    var purchasePlace: String
    var condition: String
    var imageName: String?
    var imagePath: String?
    
    init(id: UUID = UUID(),
         country: String,
         denomination: String,
         year: Int,
         material: String,
         marketPrice: Double,
         imageData: Data? = nil,
         imageName: String? = nil,
         imagePath: String? = nil,
         description: String,
         purchasePlace: String,
         condition: String) {
        self.id = id
        self.country = country
        self.denomination = denomination
        self.year = year
        self.material = material
        self.marketPrice = marketPrice
        self.imageData = imageData
        self.imageName = imageName
        self.imagePath = imagePath
        self.description = description
        self.purchasePlace = purchasePlace
        self.condition = condition
    }
}

// MARK: - ViewModel для коллекции и хранения монет
class CoinCollectionViewModel: ObservableObject {
    @Published var catalog: [Coin] = []
    @Published var collection: [Coin] = []
    @Published var wishlist: [Coin] = []
    
    private let collectionKey = "coinCollection"
    private let wishlistKey = "coinWishlist"
    
    init() {
        load()
        if catalog.isEmpty {
            catalog = CoinCollectionViewModel.sampleCatalog() // статический каталог 20 популярных
        }
    }
    
    func addToCollection(_ coin: Coin) {
        if !collection.contains(coin) {
            collection.append(coin)
            save()
        }
    }
    
    func removeFromCollection(_ coin: Coin) {
        collection.removeAll { $0.id == coin.id }
        save()
    }
    
    func addToWishlist(_ coin: Coin) {
        if !wishlist.contains(coin) {
            wishlist.append(coin)
            save()
        }
    }
    
    func removeFromWishlist(_ coin: Coin) {
        wishlist.removeAll { $0.id == coin.id }
        save()
    }
    
    var totalMarketPrice: Double {
        collection.reduce(0) { $0 + $1.marketPrice }
    }
    
    func save() {
        if let encodedCollection = try? JSONEncoder().encode(collection) {
            UserDefaults.standard.set(encodedCollection, forKey: collectionKey)
        }
        if let encodedWishlist = try? JSONEncoder().encode(wishlist) {
            UserDefaults.standard.set(encodedWishlist, forKey: wishlistKey)
        }
    }
    
    func load() {
        if let savedCollection = UserDefaults.standard.data(forKey: collectionKey),
           let decodedCollection = try? JSONDecoder().decode([Coin].self, from: savedCollection) {
            collection = decodedCollection
        }
        if let savedWishlist = UserDefaults.standard.data(forKey: wishlistKey),
           let decodedWishlist = try? JSONDecoder().decode([Coin].self, from: savedWishlist) {
            wishlist = decodedWishlist
        }
    }
    
    static func sampleCatalog() -> [Coin] {
        return [
            Coin(
                country: "France",
                denomination: "10 Euro",
                year: 2014,
                material: "Silver 333",
                marketPrice: 68.5,
                imageName: "france_2014_gallic_rooster",
                description: "The Gallic Rooster is a symbol of France, featured on the 2014 coin issued by the Paris Mint. The coin has a denomination of 10 euros, is made of 333 fine silver, weighs 17 grams, and has a diameter of 31 millimeters",
                purchasePlace: "Paris Mint",
                condition: "UNC"
            ),
            Coin(country: "USA", denomination: "1 Dollar", year: 1921, material: "Silver", marketPrice: 35.0, imageName: "usa_1_dollar", description: "Morgan Dollar", purchasePlace: "eBay", condition: "Good"),
            Coin(country: "Russia", denomination: "5 Kopeks", year: 1899, material: "Copper", marketPrice: 15.0, imageName: "russia_5_kopeks", description: "Nicholas II", purchasePlace: "Antique Store", condition: "Very Good"),
            Coin(country: "Canada", denomination: "2 Dollars", year: 1996, material: "Nickel", marketPrice: 7.5, imageName: "canada_2_dollars", description: "Toonie", purchasePlace: "Coin Show", condition: "Excellent"),
            Coin(country: "UK", denomination: "1 Pound", year: 1983, material: "Nickel-Brass", marketPrice: 12.0, imageName: "uk_1_pound", description: "Queen Elizabeth", purchasePlace: "Collector", condition: "Fine"),
            Coin(country: "Germany", denomination: "50 Pfennig", year: 1950, material: "Cupro-Nickel", marketPrice: 5.0, imageName: "germany_50_pfennig", description: "Post-war", purchasePlace: "Market", condition: "Good"),
            Coin(country: "France", denomination: "5 Francs", year: 1925, material: "Silver", marketPrice: 20.0, imageName: "france_5_francs", description: "Rooster Design", purchasePlace: "Online", condition: "VG"),
            Coin(country: "Italy", denomination: "10 Lire", year: 1954, material: "Aluminum", marketPrice: 3.0, imageName: "italy_10_lire", description: "Post-war", purchasePlace: "Show", condition: "Good"),
            Coin(country: "Japan", denomination: "10 Yen", year: 1964, material: "Bronze", marketPrice: 1.5, imageName: "japan_10_yen", description: "Tokyo Olympics", purchasePlace: "Shop", condition: "Excellent"),
            Coin(country: "Brazil", denomination: "1000 Reis", year: 1900, material: "Copper", marketPrice: 25.0, imageName: "brazil_1000_reis", description: "Old Coin", purchasePlace: "Auction", condition: "Fine"),
            Coin(country: "Australia", denomination: "50 Cents", year: 1966, material: "Cupro-Nickel", marketPrice: 10.0, imageName: "australia_50_cents", description: "Emu Design", purchasePlace: "Collector", condition: "Good"),
            Coin(country: "Mexico", denomination: "5 Pesos", year: 1970, material: "Silver", marketPrice: 18.0, imageName: "mexico_5_pesos", description: "Commemorative", purchasePlace: "eBay", condition: "VG"),
            Coin(country: "India", denomination: "10 Rupees", year: 1991, material: "Nickel-Brass", marketPrice: 7.0, imageName: "india_10_rupees", description: "Economic Reform Coin", purchasePlace: "Market", condition: "Good"),
            Coin(country: "China", denomination: "1 Yuan", year: 1987, material: "Copper", marketPrice: 2.0, imageName: "china_1_yuan", description: "Dragon Design", purchasePlace: "Shop", condition: "Excellent"),
            Coin(country: "South Africa", denomination: "1 Rand", year: 1961, material: "Nickel", marketPrice: 6.0, imageName: "southafrica_1_rand", description: "Springbok", purchasePlace: "Collector", condition: "Good"),
            Coin(country: "Sweden", denomination: "1 Krona", year: 1965, material: "Cupro-Nickel", marketPrice: 4.5, imageName: "sweden_1_krona", description: "King Gustaf", purchasePlace: "Auction", condition: "Fine"),
            Coin(country: "Norway", denomination: "5 Kroner", year: 1948, material: "Silver", marketPrice: 30.0, imageName: "norway_5_kroner", description: "Post-war Design", purchasePlace: "Market", condition: "VG"),
            Coin(country: "Netherlands", denomination: "1 Gulden", year: 1975, material: "Nickel", marketPrice: 7.0, imageName: "netherlands_1_gulden", description: "Wilhelmina", purchasePlace: "Shop", condition: "Good"),
            Coin(country: "Poland", denomination: "10 Zloty", year: 1939, material: "Silver", marketPrice: 22.0, imageName: "poland_10_zloty", description: "Pre-war Coin", purchasePlace: "Collector", condition: "Fine"),
            Coin(country: "Czech Republic", denomination: "5 Korun", year: 2000, material: "NiBrAl", marketPrice: 3.5, imageName: "czech_5_korun", description: "Millennium Coin", purchasePlace: "Online", condition: "Excellent"),
            Coin(country: "Belgium", denomination: "50 Centimes", year: 1960, material: "Copper", marketPrice: 5.0, imageName: "belgium_50_centimes", description: "King Baudouin", purchasePlace: "Show", condition: "Good")
        ]
    }

}

// MARK: - Главный TabView с навигацией по 7 экранам
struct MainTabView: View {
    @StateObject private var viewModel = CoinCollectionViewModel()
    
    var body: some View {
        TabView {
            CatalogView()
                .tabItem {
                    Label("Catalog", systemImage: "book")
                }
            
            CollectionView()
                .tabItem {
                    Label("Collection", systemImage: "tray.full")
                }
            
            WishlistView()
                .tabItem {
                    Label("Wishlist", systemImage: "heart")
                }
            
            StatsView()
                .tabItem {
                    Label("Stats", systemImage: "chart.bar")
                }
            
            AchievementsView()
                .tabItem {
                    Label("Achievements", systemImage: "star")
                }
            
            // Экран деталей и добавление можно вызывать навигационно
            // Например, при клике в списках откроется NavigationLink
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
        .environmentObject(viewModel)
    }
}

// MARK: - Каталог монет список с кнопками добавления
struct CatalogView: View {
    @EnvironmentObject var viewModel: CoinCollectionViewModel
    
    var body: some View {
        NavigationView {
            List(viewModel.catalog) { coin in
                NavigationLink(destination: CoinDetailView(coin: coin)) {
                    HStack(spacing: 15) {
                        if let name = coin.imageName {
                            Image(name)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                                .cornerRadius(40)
                        } else if let path = coin.imagePath,
                                  let uiImage = UIImage(contentsOfFile: path) {
                            Image(uiImage: uiImage)
                                .resizable()
                                
                                .frame(width: 80, height: 80)
                                .cornerRadius(40)
                        } else {
                            Image(systemName: "bitcoinsign.circle")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                                .foregroundColor(.orange.opacity(0.7))
                        }
                        
                        VStack(alignment: .leading, spacing: 6) {
                            Text("\(coin.country) • \(coin.year)")
                                .font(.headline)
                                .foregroundColor(.primary)
                            Text("\(coin.denomination) • $\(coin.marketPrice, specifier: "%.2f")")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Text(coin.material)
                                .font(.footnote)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(12)
                    .background(Color(red: 0.95, green: 0.96, blue: 0.98).opacity(0.7))
                    .cornerRadius(14)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 3)
                    .padding(.vertical, 4)
                    
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Catalog")
            .background(Color(.systemGroupedBackground).edgesIgnoringSafeArea(.all))
        }
    }
}

// MARK: - Строка монеты в списке
struct CoinRowView: View {
    var coin: Coin
    
    var body: some View {
        HStack {
            if let name = coin.imageName {
                Image(name)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
            } else if let path = coin.imagePath,
                      let uiImage = UIImage(contentsOfFile: path) {
                Image(uiImage: uiImage)
                    .resizable()
                    
                    .frame(width: 80, height: 80)
                    .cornerRadius(40)
            } else {
                Image(systemName: "bitcoinsign.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.orange.opacity(0.7))
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Text("\(coin.country) \(coin.year)")
                    .font(.headline)
                    .foregroundColor(.black)
                Text("\(coin.denomination), $\(String(format: "%.2f", coin.marketPrice))")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.leading)
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
}


struct CoinDetailView: View {
    @EnvironmentObject var viewModel: CoinCollectionViewModel
    @State var coin: Coin
    
    var isInCollection: Bool {
        viewModel.collection.contains(coin)
    }
    var isInWishlist: Bool {
        viewModel.wishlist.contains(coin)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                if let name = coin.imageName {
                    Image(name)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .padding(.top)
                } else if let path = coin.imagePath,
                          let uiImage = UIImage(contentsOfFile: path) {
                    Image(uiImage: uiImage)
                        .resizable()
                        
                        .frame(width: 150, height: 150)
                        .cornerRadius(80)
                        .padding(.top)
                } else {
                    Image(systemName: "bitcoinsign.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .foregroundColor(.orange.opacity(0.7))
                        .padding(.top)
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    DetailRow(title: "Country", value: coin.country)
                    DetailRow(title: "Denomination", value: coin.denomination)
                    DetailRow(title: "Year", value: String(coin.year))
                    DetailRow(title: "Material", value: coin.material)
                    DetailRow(title: "Price", value: String(format: "$%.2f", coin.marketPrice))
                    DetailRow(title: "Condition", value: coin.condition)
                    DetailRow(title: "Purchase Place", value: coin.purchasePlace)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Description")
                            .font(.headline)
                            .foregroundColor(.primary)
                        Text(coin.description)
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 8)
                }
                .padding(.horizontal)
                
                HStack(spacing: 16) {
                    Button {
                        if isInCollection {
                            viewModel.removeFromCollection(coin)
                        } else {
                            viewModel.addToCollection(coin)
                        }
                    } label: {
                        Text(isInCollection ? "Remove from Collection" : "Add to Collection")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity, minHeight: 50)
                            .background(isInCollection ? Color.red.gradient : Color.blue.gradient)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .shadow(color: (isInCollection ? Color.red : Color.blue).opacity(0.5), radius: 5, x: 0, y: 3)
                    }
                    
                    Button {
                        if isInWishlist {
                            viewModel.removeFromWishlist(coin)
                        } else {
                            viewModel.addToWishlist(coin)
                        }
                    } label: {
                        Text(isInWishlist ? "Remove from Wishlist" : "Add to Wishlist")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity, minHeight: 50)
                            .background(isInWishlist ? Color.red.gradient : Color.green.gradient)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .shadow(color: (isInWishlist ? Color.red : Color.green).opacity(0.5), radius: 5, x: 0, y: 3)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 30)
            }
            .background(Color(red: 0.96, green: 0.97, blue: 0.99))
            .cornerRadius(20)
            .padding()
        }
        .navigationTitle("Coin Details")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(red: 0.85, green: 0.87, blue: 0.93).edgesIgnoringSafeArea(.all))
    }
}

struct DetailRow: View {
    var title: String
    var value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
            Spacer()
            Text(value)
                .foregroundColor(.secondary)
                .font(.subheadline)
                .multilineTextAlignment(.trailing)
        }
        .padding(.vertical, 6)
        .background(Color.white.opacity(0.4))
        .cornerRadius(8)
        .padding(.horizontal, 4)
    }
}

struct AddCoinView: View {
    @EnvironmentObject var viewModel: CoinCollectionViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var country = ""
    @State private var denomination = ""
    @State private var yearText = ""
    @State private var material = ""
    @State private var marketPriceText = ""
    @State private var description = ""
    @State private var purchasePlace = ""
    @State private var condition = ""
    @State private var imageName: String? = nil   // Для выбора из ассетов, опционально
    @State private var imagePath: String? = nil   // Выбранное фото из галереи
    @State private var showPhotoPicker = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Coin Details")) {
                    TextField("Country", text: $country)
                    TextField("Denomination", text: $denomination)
                    TextField("Year", text: $yearText).keyboardType(.numberPad)
                    TextField("Material", text: $material)
                    TextField("Market Price", text: $marketPriceText).keyboardType(.decimalPad)
                    TextField("Condition", text: $condition)
                    TextField("Purchase Place", text: $purchasePlace)
                    TextEditor(text: $description).frame(height: 100)
                }
                
                Section(header: Text("Image")) {
                    Button("Select Photo from Gallery") {
                        showPhotoPicker = true
                    }
                    if let imagePath = imagePath,
                       let uiImage = UIImage(contentsOfFile: imagePath) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 150)
                            .cornerRadius(12)
                    }
                }
            }
            .navigationTitle("Add New Coin")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveCoin()
                    }.disabled(!formIsValid())
                }
            }
            .sheet(isPresented: $showPhotoPicker) {
                PhotoPicker(imagePath: $imagePath)
            }
        }
    }
    
    func formIsValid() -> Bool {
        guard !country.isEmpty, !denomination.isEmpty,
              let year = Int(yearText), year > 0,
              !material.isEmpty,
              let price = Double(marketPriceText), price >= 0 else { return false }
        return true
    }
    
    func saveCoin() {
        guard let year = Int(yearText),
              let price = Double(marketPriceText) else { return }
        
        let newCoin = Coin(
            country: country,
            denomination: denomination,
            year: year,
            material: material,
            marketPrice: price,
            imageData: nil,  // устаревшее
            imageName: imageName, imagePath: imagePath, description: description,
            purchasePlace: purchasePlace,
            condition: condition
        )
        
        viewModel.addToCollection(newCoin)
        dismiss()
    }
}

struct CollectionView: View {
    @EnvironmentObject var viewModel: CoinCollectionViewModel
    @State private var showAddCoin = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(viewModel.collection) { coin in
                            NavigationLink(destination: CoinDetailView(coin: coin)) {
                                CoinRowView(coin: coin)
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(Color(red: 0.93, green: 0.94, blue: 0.97).opacity(0.8))
                                            .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 3)
                                    )
                                    .padding(.horizontal)
                            }
                        }
                        .onDelete(perform: deleteCoins)
                    }
                    .padding(.top)
                }
                
                Text("Total Price: $\(viewModel.totalMarketPrice, specifier: "%.2f")")
                    .foregroundStyle(.black)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(12)
                    .padding()
            }
            .navigationTitle("My Collection")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showAddCoin.toggle() }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAddCoin) {
                AddCoinView()
                    .environmentObject(viewModel)
            }
            .background(
                LinearGradient(
                    colors: [Color(red: 0.85, green: 0.88, blue: 0.95), Color.white],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            )
        }
    }
    
    private func deleteCoins(at offsets: IndexSet) {
        for index in offsets {
            let coin = viewModel.collection[index]
            viewModel.removeFromCollection(coin)
        }
    }
}


// MARK: - Экран желаемого списка
struct WishlistView: View {
    @EnvironmentObject var viewModel: CoinCollectionViewModel
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(viewModel.wishlist) { coin in
                            NavigationLink(destination: CoinDetailView(coin: coin)) {
                                CoinRowView(coin: coin)
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(Color(red: 0.93, green: 0.94, blue: 0.97).opacity(0.8))
                                            .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 3)
                                    )
                                    .padding(.horizontal)
                            }
                        }
                        .onDelete(perform: deleteCoins)
                    }
                    .padding(.top)
                }
            }
            .navigationTitle("Wishlist")
            .background(
                LinearGradient(
                    colors: [Color(red: 0.85, green: 0.88, blue: 0.95), Color.white],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            )
        }
    }
    
    private func deleteCoins(at offsets: IndexSet) {
        for index in offsets {
            let coin = viewModel.wishlist[index]
            viewModel.removeFromWishlist(coin)
        }
    }
}


// MARK: - Заглушки экранов Статистики, Ачивок и Настроек
// MARK: - Экран Статистики
struct StatsView: View {
    @EnvironmentObject var viewModel: CoinCollectionViewModel
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                StatRow(title: "Collected Coins", value: "\(viewModel.collection.count)")
                StatRow(title: "Coins in Wishlist", value: "\(viewModel.wishlist.count)")
                StatRow(title: "Total Market Price", value: String(format: "$%.2f", viewModel.totalMarketPrice))
                StatRow(title: "Unique Countries", value: "\(Set(viewModel.collection.map { $0.country }).count)")
                
                Spacer()
            }
            .padding()
            .navigationTitle("Statistics")
        }
    }
}

struct StatRow: View {
    var title: String
    var value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
            Spacer()
            Text(value)
                .font(.body)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(red: 0.93, green: 0.94, blue: 0.97).opacity(0.8))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 3)
    }
}

// MARK: - Экран Ачивок
struct AchievementsView: View {
    @EnvironmentObject var viewModel: CoinCollectionViewModel
    
    var body: some View {
        NavigationView {
            List {
                AchievementRow(title: "First 5 coins collected", achieved: viewModel.collection.count >= 5)
                AchievementRow(title: "10 coins collected", achieved: viewModel.collection.count >= 10)
                AchievementRow(title: "20 coins in wishlist", achieved: viewModel.wishlist.count >= 20)
                AchievementRow(title: "Collected coins from 3+ countries", achieved: Set(viewModel.collection.map { $0.country }).count >= 3)
                AchievementRow(title: "Total market value over $1000", achieved: viewModel.totalMarketPrice >= 1000)
            }
            .navigationTitle("Achievements")
        }
    }
}

struct AchievementRow: View {
    var title: String
    var achieved: Bool
    
    var body: some View {
        HStack {
            Image(systemName: achieved ? "checkmark.seal.fill" : "seal")
                .foregroundColor(achieved ? .green : .gray)
            Text(title)
                .foregroundColor(achieved ? .primary : .secondary)
            Spacer()
        }
        .padding(.vertical, 8)
    }
}

enum AppTheme: String, CaseIterable, Identifiable {
    case light = "Light"
    case dark = "Dark"
    case system = "System Default"
    
    var id: String { rawValue }
}

struct SettingsView: View {
    @AppStorage("notifications_enabled") private var notificationsEnabled = true
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("General")) {
                    Toggle("Enable Notifications", isOn: $notificationsEnabled)
                }
                
                Section(header: Text("Support")) {
                    Link("Privacy Policy", destination: URL(string: "https://your.privacy.policy.url")!)
                    Link("Support", destination: URL(string: "https://your.support.url")!)
                }
                
                Section(header: Text("About")) {
                    Text("Version 1.0.0")
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    MainTabView()
}

import SwiftUI
import PhotosUI

struct PhotoPicker: UIViewControllerRepresentable {
    @Binding var imagePath: String?
    @Environment(\.dismiss) var dismiss
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var parent: PhotoPicker
        
        init(parent: PhotoPicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            guard let itemProvider = results.first?.itemProvider else { return }
            if itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                    if let uiImage = image as? UIImage {
                        if let path = self.saveImageToDocuments(uiImage) {
                            DispatchQueue.main.async {
                                self.parent.imagePath = path
                            }
                        }
                    }
                }
            }
        }
        
        func saveImageToDocuments(_ image: UIImage) -> String? {
            guard let data = image.jpegData(compressionQuality: 0.8) else { return nil }
            let filename = UUID().uuidString + ".jpg"
            let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(filename)
            do {
                try data.write(to: url)
                return url.path
            } catch {
                return nil
            }
        }
    }
    
    func makeCoordinator() -> Coordinator { Coordinator(parent: self) }
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
}
