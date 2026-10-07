import SwiftUI
import MapplsMap

struct MapplsMapViewSampleSwiftUI: View {
    @State var annotations: [MGLPointAnnotation] = [
        MGLPointAnnotation(title: "MAPPLS", coordinate: CLLocationCoordinate2D(latitude: 28.550679, longitude: 77.268949))
    ]
    
    var body: some View {
        MapplsMapViewSwiftUIView(annotations: $annotations).centerCoordinate(.init(latitude: 28.550679, longitude: 77.268949)).zoomLevel(16)
            .navigationBarTitle("Map", displayMode: .inline)
    }
}

struct MapplsMapViewSampleSwiftUIWrapper_Previews: PreviewProvider {
    static var previews: some View {
        MapplsMapViewSampleSwiftUI()
    }
}
