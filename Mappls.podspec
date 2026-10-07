Pod::Spec.new do |m|

  version       = '1.0.9'
  docVersion    = '1.0.11'
  name          = 'Mappls'

  m.name        = name
  m.version     = version

  m.summary           = "Mappls SDK for iOS."
  m.description       = "SDK for iOS to enrich your app with interactive maps, detailed information from Mappls Places database, Place Widgets etc."
  m.license           = { :type => 'Proprietary', :file => 'LICENSE.md' }
  m.author            = { 'Mappls' => 'apisupport@mappls.com' }
  m.screenshot        = "https://s3-ap-south-1.amazonaws.com/mmi-api-team/moveSDK/ios/resources/APIsImage.jpg"
  m.social_media_url  = 'https://twitter.com/mappls'
  m.homepage          = "https://github.com/mappls-api/mappls-ios-sdk"
  m.documentation_url = "https://github.com/mappls-api/mappls-ios-sdk/tree/main/docs/v#{docVersion.to_s}/README.md"
  m.readme            = "https://github.com/mappls-api/mappls-ios-sdk/tree/main/docs/v#{docVersion.to_s}/README.md"
  m.changelog         = "https://github.com/mappls-api/mappls-ios-sdk/tree/main/Version-History.md"

  m.source = {
    :git => 'https://github.com/mappls-api/mappls-ios-sdk.git',
    :tag => m.version.to_s
  }

  m.ios.deployment_target = '9.0'

  m.default_subspec = 'Complete'

  m.subspec 'Complete' do |complete|
    complete.dependency 'Mappls/Base'
    complete.dependency 'Mappls/MapplsUIWidgets'
    complete.dependency 'Mappls/MapplsNearbyUI'
    complete.dependency 'Mappls/MapplsDirectionUI'
    complete.dependency 'Mappls/MapplsGeoanalytics'
    complete.dependency 'Mappls/MapplsFeedbackKit'
    complete.dependency 'Mappls/MapplsFeedbackUIKit'
    complete.dependency 'Mappls/MapplsDrivingRangePlugin'
    complete.dependency 'Mappls/MapplsAnnotationExtension'
    complete.dependency 'Mappls/MapplsGeofenceUI'
    complete.dependency 'Mappls/MapplsRasterCatalogue'
    complete.dependency 'Mappls/MapplsIntouch'
  end

  m.subspec 'Base' do |base|
    base.dependency 'Mappls/MapplsAPICore'
    base.dependency 'Mappls/MapplsAPIKit'
    base.dependency 'Mappls/MapplsMap'
    base.ios.deployment_target = '9.0'
  end

  m.subspec 'MapplsAPICore' do |core|
    core.dependency	'MapplsAPICore', '~> 1.0.7'
    core.ios.deployment_target = '9.0'
    core.watchos.deployment_target = '6.2'
    core.osx.deployment_target = '10.12'
    core.tvos.deployment_target = '10.0'
  end

  m.subspec 'MapplsAPIKit' do |apiKit|
    apiKit.dependency	'MapplsAPIKit', '~> 2.0.15'
    apiKit.ios.deployment_target = '9.0'
    apiKit.watchos.deployment_target = '6.2'
    apiKit.osx.deployment_target = '10.12'
    apiKit.tvos.deployment_target = '10.0'
  end

  m.subspec 'MapplsMap' do |map|
    map.dependency 'MapplsMap', '~> 5.13.9'
  end

  m.subspec 'MapplsUIWidgets' do |uiWidgets|
    uiWidgets.dependency	'MapplsUIWidgets', '~> 1.0.3'
  end

  m.subspec 'MapplsNearbyUI' do |nearbyUI|
    nearbyUI.dependency	'MapplsNearbyUI', '~> 1.0.1'
  end

  m.subspec 'MapplsDirectionUI' do |directionUI|
    directionUI.dependency	'MapplsDirectionUI', '~> 1.0.3'
  end

  m.subspec 'MapplsGeoanalytics' do |geoanalytics|
    geoanalytics.dependency	'MapplsGeoanalytics', '~> 1.0.0'
  end

  m.subspec 'MapplsFeedbackKit' do |feedbackKit|
    feedbackKit.dependency	'MapplsFeedbackKit', '~> 1.0.0'
  end

  m.subspec 'MapplsFeedbackUIKit' do |feedbackUIKit|
    feedbackUIKit.dependency	'MapplsFeedbackUIKit', '~> 1.0.2'
  end

  m.subspec 'MapplsDrivingRangePlugin' do |drivingRangePlugin|
    drivingRangePlugin.dependency	'MapplsDrivingRangePlugin', '~> 1.0.1'
  end

  m.subspec 'MapplsAnnotationExtension' do |annotationExtension|
    annotationExtension.dependency	'MapplsAnnotationExtension', '~> 1.0.0'
  end

  m.subspec 'MapplsGeofenceUI' do |geofenceUI|
    geofenceUI.dependency	'MapplsGeofenceUI', '~> 1.0.1'
  end

  m.subspec 'MapplsRasterCatalogue' do |rasterCatalogue|
    rasterCatalogue.dependency	'MapplsRasterCatalogue', '~> 0.1.0'
  end

  m.subspec 'MapplsIntouch' do |intouch|
    intouch.dependency	'MapplsIntouch', '~> 1.0.1'
  end
  
  m.swift_version = '4.2'

end