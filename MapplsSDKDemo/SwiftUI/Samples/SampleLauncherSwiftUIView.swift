import SwiftUI

struct SampleLauncherSwiftUIListView: View {
//    let samples = [SectionInfoSwiftUI(id: UUID().uuidString, rows: SampleTypeSwiftUI.allCases, headerTitle: "Samples")]
    
    let samples = [SectionInfoSwiftUI(id: UUID().uuidString, rows: [.map, .autosuggestWidget], headerTitle: "Samples")]

    @State var selectedSample: SampleTypeSwiftUI?
    
    var body: some View {
        List(samples) { sample in
            Section(header: Text(sample.headerTitle!)) {
                ForEach(sample.rows) { row in
                    NavigationLink(destination: SampleDynamicSwiftUIView(sample: row)) {
                        Text(row.title)
                    }
                }
            }
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle(Text("SwiftUI"), displayMode: .automatic)
    }
}

struct SampleDynamicSwiftUIView : View {
    var sample : SampleTypeSwiftUI
    var body : some View {
        switch sample {
        case .map:
            MapplsMapViewSampleSwiftUI()
        case .placePicker:
            EmptyView()
        case .autosuggestWidget:
            AutosuggestWidgetExamplesLauncherSwiftUIListView()
        }
    }
}

struct SampleLauncherSwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SampleLauncherSwiftUIListView()
    }
}
