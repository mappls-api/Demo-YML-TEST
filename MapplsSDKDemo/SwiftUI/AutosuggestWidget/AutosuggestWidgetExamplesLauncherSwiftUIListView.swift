import SwiftUI
import MapplsAPIKit

struct AutosuggestWidgetExamplesLauncherSwiftUIListView: View {
    //let samples = AutosuggestWidgetSampleType.allCases
    let samples: [AutosuggestWidgetSampleType] = [.defaultController, .customTheme]
    
    @State var selectedPlaceSuggestion: MapplsAtlasSuggestion?
    
    @State var styledAutosuggestWidgetSampleType: StyledAutosuggestWidgetSampleType?
    
    @State var selectedSampleType: AutosuggestWidgetSampleType? {
        didSet {
            switch selectedSampleType {
            case .defaultController, .customTheme:
                self.isShowActionSheet = true
            default:
                self.isShowActionSheet = false
                break
            }
        }
    }
    
    @State var isShowAlert: Bool = false
    
    @State var isPushAutoSuggestView: Bool = false
    
    @State var isPresentAutoSuggestView: Bool = false
    
    @State var isShowActionSheet: Bool = false {
        didSet {
            print(isShowActionSheet)
        }
    }
    
    var body: some View {
        List(samples) { sample in
            AutosuggestWidgetExampleSwiftUIRowView(sampleType: sample)
                .onTapGesture {
                self.selectedSampleType = sample
            }
        }
        .alert(isPresented: $isShowAlert) {
            Alert(title: Text("Selected Result:"), message: Text("\(self.selectedPlaceSuggestion?.placeName ?? "")"), dismissButton: .default(Text("Ok")))
        }
        .actionSheet(isPresented: self.$isShowActionSheet, content: {
            getActionSheet()
        })
        .sheet(isPresented: $isPresentAutoSuggestView) {
            AboutView(sample: self.selectedSampleType!, styledAutosuggestWidgetSampleType: self.styledAutosuggestWidgetSampleType, placeSuggestion: $selectedPlaceSuggestion.onChange({ atlasSuggestion in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    isShowAlert = true
                }
            }))
        }
        .background(
            NavigationLink(destination: AboutView(sample: self.selectedSampleType ?? .defaultController, placeSuggestion: $selectedPlaceSuggestion.onChange(
                { atlasSuggestion in
                isShowAlert = true
            })), isActive: $isPushAutoSuggestView) {

            }.hidden()
        )
        .listStyle(GroupedListStyle())
        .navigationBarTitle(Text("SwiftUI"), displayMode: .automatic)
        .navigationBarHidden(false)
    }
    
    func getActionSheet() -> ActionSheet {
        var buttons: [ActionSheet.Button] = []
        var alertTitle = "Choose Launch Type?"
        var alertMessage = "Select type of launch of Controller"
        if let sampleType = selectedSampleType {
            switch sampleType {
            case .defaultController:
                buttons.append(contentsOf: [
                    ActionSheet.Button.default(Text("Push"), action: {
                        self.isPushAutoSuggestView = true
                        //AboutView(sample: self.selectedSampleType!)
                    }),
                    ActionSheet.Button.default(Text("Present"), action: {
                        self.isPresentAutoSuggestView = true
                    })
                ])
            case .customTheme:
                alertTitle = "Choose Theme?"
                alertMessage = "Select a theme for Controller"
                buttons.append(contentsOf: [
                    ActionSheet.Button.default(Text(StyledAutosuggestWidgetSampleType.yellowAndBrown.title), action: {
                        self.styledAutosuggestWidgetSampleType = .yellowAndBrown
                        self.isPresentAutoSuggestView = true
                    }),
                    ActionSheet.Button.default(Text(StyledAutosuggestWidgetSampleType.whiteOnBlack.title), action: {
                        self.styledAutosuggestWidgetSampleType = .whiteOnBlack
                        self.isPresentAutoSuggestView = true
                    }),
                    ActionSheet.Button.default(Text(StyledAutosuggestWidgetSampleType.blueColors.title), action: {
                        self.styledAutosuggestWidgetSampleType = .blueColors
                        self.isPresentAutoSuggestView = true
                    }),
                    ActionSheet.Button.default(Text(StyledAutosuggestWidgetSampleType.hotDogStand.title), action: {
                        self.styledAutosuggestWidgetSampleType = .hotDogStand
                        self.isPresentAutoSuggestView = true
                    })
                ])
            default:
                break
            }
        }
        buttons.append(.cancel())
        
        return ActionSheet(title: Text(alertTitle), message: Text(alertMessage), buttons: buttons)
    }
}

struct AboutView : View {
    var sample : AutosuggestWidgetSampleType
    var styledAutosuggestWidgetSampleType : StyledAutosuggestWidgetSampleType?
    let placeSuggestion: Binding<MapplsAtlasSuggestion?>
    var body : some View {
        switch sample {
        case .defaultController:
            MapplsAutocompleteViewControllerSwiftUIView(placeSuggestion: placeSuggestion)
        case .customTheme:
            if let styledAutosuggestWidgetSampleType = styledAutosuggestWidgetSampleType {
                getStyledMapplsAutocompleteViewControllerSwiftUIView(styledAutosuggestWidgetSampleType: styledAutosuggestWidgetSampleType)
            } else {
                EmptyView()
            }
        case .customUISearchController:
            EmptyView()
        case .textFieldSearch:
            EmptyView()
        }
    }
    
    @ViewBuilder func getStyledMapplsAutocompleteViewControllerSwiftUIView(styledAutosuggestWidgetSampleType: StyledAutosuggestWidgetSampleType) -> some View {
        switch styledAutosuggestWidgetSampleType {
        case .yellowAndBrown:
            getBrownThemeView()
        case .whiteOnBlack:
            getBlackThemeView()
        case .blueColors:
            getBlueThemeView()
        case .hotDogStand:
            getHotDogThemeView()
        }
    }
    
    func getBrownThemeView() -> some View {
        let backgroundColor = UIColor(red: 215.0 / 255.0, green: 204.0 / 255.0, blue: 200.0 / 255.0, alpha: 1.0)
        let selectedTableCellBackgroundColor = UIColor(red: 236.0 / 255.0, green: 225.0 / 255.0, blue: 220.0 / 255.0, alpha: 1.0)
        let darkBackgroundColor = UIColor(red: 93.0 / 255.0, green: 64.0 / 255.0, blue: 55.0 / 255.0, alpha: 1.0)
        let primaryTextColor = UIColor(white: 0.33, alpha: 1.0)
        
        let highlightColor = UIColor(red: 255.0 / 255.0, green: 235.0 / 255.0, blue: 0.0 / 255.0, alpha: 1.0)
        let secondaryColor = UIColor(white: 114.0 / 255.0, alpha: 1.0)
        let tintColor = UIColor(red: 219 / 255.0, green: 207 / 255.0, blue: 28 / 255.0, alpha: 1.0)
        let searchBarTintColor = UIColor.yellow
        let separatorColor = UIColor(white: 182.0 / 255.0, alpha: 1.0)
        
        return StyledMapplsAutocompleteViewControllerSwiftUIView(placeSuggestion: placeSuggestion, withBackgroundColor: backgroundColor, selectedTableCellBackgroundColor: selectedTableCellBackgroundColor, darkBackgroundColor: darkBackgroundColor, primaryTextColor: primaryTextColor, highlightColor: highlightColor, secondaryColor: secondaryColor, tintColor: tintColor, searchBarTintColor: searchBarTintColor, separatorColor: separatorColor)
    }
    
    func getBlackThemeView() -> some View {
        let backgroundColor = UIColor(white: 0.25, alpha: 1.0)
        let selectedTableCellBackgroundColor = UIColor(white: 0.35, alpha: 1.0)
        let darkBackgroundColor = UIColor(white: 0.2, alpha: 1.0)
        let primaryTextColor = UIColor.white
        let highlightColor = UIColor(red: 0.75, green: 1.0, blue: 0.75, alpha: 1.0)
        let secondaryColor = UIColor(white: 1.0, alpha: 0.5)
        let tintColor = UIColor.white
        let searchBarTintColor = tintColor
        let separatorColor = UIColor(red: 0.5, green: 0.75, blue: 0.5, alpha: 0.30)
        
        return StyledMapplsAutocompleteViewControllerSwiftUIView(placeSuggestion: placeSuggestion, withBackgroundColor: backgroundColor, selectedTableCellBackgroundColor: selectedTableCellBackgroundColor, darkBackgroundColor: darkBackgroundColor, primaryTextColor: primaryTextColor, highlightColor: highlightColor, secondaryColor: secondaryColor, tintColor: tintColor, searchBarTintColor: searchBarTintColor, separatorColor: separatorColor)
    }
    
    func getBlueThemeView() -> some View {
        let backgroundColor = UIColor(red: 225.0 / 255.0, green: 241.0 / 255.0, blue: 252.0 / 255.0, alpha: 1.0)
        let selectedTableCellBackgroundColor = UIColor(red: 213.0 / 255.0, green: 219.0 / 255.0, blue: 230.0 / 255.0, alpha: 1.0)
        let darkBackgroundColor = UIColor(red: 187.0 / 255.0, green: 222.0 / 255.0, blue: 248.0 / 255.0, alpha: 1.0)
        let primaryTextColor = UIColor(white: 0.5, alpha: 1.0)
        let highlightColor = UIColor(red: 76.0 / 255.0, green: 175.0 / 255.0, blue: 248.0 / 255.0, alpha: 1.0)
        let secondaryColor = UIColor(white: 0.5, alpha: 0.65)
        let tintColor = UIColor(red: 0 / 255.0, green: 142 / 255.0, blue: 248.0 / 255.0, alpha: 1.0)
        let searchBarTintColor = tintColor
        let separatorColor = UIColor(white: 0.5, alpha: 0.65)
        
        return StyledMapplsAutocompleteViewControllerSwiftUIView(placeSuggestion: placeSuggestion, withBackgroundColor: backgroundColor, selectedTableCellBackgroundColor: selectedTableCellBackgroundColor, darkBackgroundColor: darkBackgroundColor, primaryTextColor: primaryTextColor, highlightColor: highlightColor, secondaryColor: secondaryColor, tintColor: tintColor, searchBarTintColor: searchBarTintColor, separatorColor: separatorColor)
    }
    
    func getHotDogThemeView() -> some View {
        let backgroundColor = UIColor.yellow
        let selectedTableCellBackgroundColor = UIColor.white
        let darkBackgroundColor = UIColor.red
        let primaryTextColor = UIColor.black
        let highlightColor = UIColor.red
        let secondaryColor = UIColor(white: 0.0, alpha: 0.6)
        let tintColor = UIColor.red
        let searchBarTintColor = UIColor.white
        let separatorColor = UIColor.red

        return StyledMapplsAutocompleteViewControllerSwiftUIView(placeSuggestion: placeSuggestion, withBackgroundColor: backgroundColor, selectedTableCellBackgroundColor: selectedTableCellBackgroundColor, darkBackgroundColor: darkBackgroundColor, primaryTextColor: primaryTextColor, highlightColor: highlightColor, secondaryColor: secondaryColor, tintColor: tintColor, searchBarTintColor: searchBarTintColor, separatorColor: separatorColor)
    }
}

struct AutosuggestWidgetExamplesLauncherSwiftUIListView_Previews: PreviewProvider {
    static var previews: some View {
        AutosuggestWidgetExamplesLauncherSwiftUIListView()
    }
}

extension Binding {
    func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
        Binding(
            get: { self.wrappedValue },
            set: { newValue in
                self.wrappedValue = newValue
                handler(newValue)
            }
        )
    }
}
