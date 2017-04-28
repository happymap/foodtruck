import Foundation
import MapKit

class Annotation: NSObject, MKAnnotation {
    let title: String?
    let identifier: Int
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, identifier: Int, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.identifier = identifier
        self.coordinate = coordinate
        
        super.init()
    }
}