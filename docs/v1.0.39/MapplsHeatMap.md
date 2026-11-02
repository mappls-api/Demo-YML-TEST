
## [MapplsHeatMap](#Mappls-Heat-Map)

### [MGLHeatmapStyleLayer](MGLHeatmapStyleLayer)

An `MGLHeatmapStyleLayer` is a style layer that renders a heatmap.

A heatmap visualizes the spatial distribution of a large, dense set of point data, using color to avoid cluttering the map with individual points at low zoom levels. The points are weighted by an attribute you specify. Use a heatmap style layer in conjunction with point or point collection features. These features can come from vector tiles loaded by an `MGLVectorTileSource` object, or they can be `MGLPointAnnotation`, MGLPointFeature, `MGLPointCollection`, or `MGLPointCollectionFeature` instances in an `MGLShapeSource` or `MGLComputedShapeSource` object.

Consider accompanying a heatmap style layer with an `MGLCircleStyleLayer` or `MGLSymbolStyleLayer` at high zoom levels. If you are unsure whether the point data in an `MGLShapeSource` is dense enough to warrant a heatmap, you can alternatively cluster the source using the `MGLShapeSourceOptionClustered` option and render the data using an `MGLCircleStyleLayer` or `MGLSymbolStyleLayer`.

You can access an existing heatmap style layer using the -[MGLStyle layerWithIdentifier:] method if you know its identifier; otherwise, find it using the MGLStyle.layers property. You can also create a new heatmap style layer and add it to the style using a method such as -[MGLStyle addLayer:].


See the [Create a heatmap layer](#) example to learn how to add this style layer to your map.

## [Example]()

```swift
let layer = MGLHeatmapStyleLayer(identifier: "earthquake-heat", source: earthquakes)
layer.heatmapWeight = NSExpression(format: "mgl_interpolate:withCurveType:parameters:stops:(magnitude, 'linear', nil, %@)",
                                   [0: 0,
                                    6: 1])
layer.heatmapIntensity = NSExpression(format: "mgl_interpolate:withCurveType:parameters:stops:($zoomLevel, 'linear', nil, %@)",
                                      [0: 1,
                                       9: 3])
mapView.style?.addLayer(layer)
```