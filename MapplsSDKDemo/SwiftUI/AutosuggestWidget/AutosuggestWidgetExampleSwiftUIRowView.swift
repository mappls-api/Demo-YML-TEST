import SwiftUI

struct AutosuggestWidgetExampleSwiftUIRowView: View {
    var sampleType: AutosuggestWidgetSampleType

    var body: some View {
        Text(sampleType.title)
    }
}

struct AutosuggestWidgetExampleSwiftUIRowView_Previews: PreviewProvider {
    static var previews: some View {
        AutosuggestWidgetExampleSwiftUIRowView(sampleType: .defaultController)
    }
}
