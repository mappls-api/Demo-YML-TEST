import SwiftUI
import MapplsMap

struct MapplsMapViewSwiftUIView: UIViewRepresentable {
    @Binding var annotations: [MGLPointAnnotation]
    
    private let mapView: MapplsMapView = MapplsMapView(frame: .zero)
    
    // MARK: - Configuring UIViewRepresentable protocol
    
    func makeUIView(context: UIViewRepresentableContext<MapplsMapViewSwiftUIView>) -> MapplsMapView {
        mapView.delegate = context.coordinator
        return mapView
    }
    
    func updateUIView(_ uiView: MapplsMapView, context: UIViewRepresentableContext<MapplsMapViewSwiftUIView>) {
        updateAnnotations()
    }
    
    func makeCoordinator() -> MapplsMapViewSwiftUIView.Coordinator {
        Coordinator(self)
    }
    
    // MARK: - Configuring MapmyIndiaMapView
    
    func centerCoordinate(_ centerCoordinate: CLLocationCoordinate2D) -> MapplsMapViewSwiftUIView {
        mapView.centerCoordinate = centerCoordinate
        return self
    }
    
    func zoomLevel(_ zoomLevel: Double) -> MapplsMapViewSwiftUIView {
        mapView.zoomLevel = zoomLevel
        return self
    }
    
    private func updateAnnotations() {
        if let currentAnnotations = mapView.annotations {
            mapView.removeAnnotations(currentAnnotations)
        }
        mapView.addAnnotations(annotations)
    }
    
    // MARK: - Implementing MapmyIndiaMapViewDelegate
    
    final class Coordinator: NSObject, MapplsMapViewDelegate {
        var control: MapplsMapViewSwiftUIView
        
        init(_ control: MapplsMapViewSwiftUIView) {
            self.control = control
        }
        
        func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
            
        }
        
        func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
            return nil
        }
         
        func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
            return true
        }
        
    }
    
}
