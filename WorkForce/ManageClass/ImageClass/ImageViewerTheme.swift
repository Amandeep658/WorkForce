import UIKit

public enum ImageViewerTheme {
    case light
    case dark
    case blur
    
    var color: UIColor {
        switch self {
        case .light:
            return .white
        case .dark:
            return .black
        case .blur:
            return .clear // UIColor.black.withAlphaComponent(0.8)
        }
    }
    
    var tintColor: UIColor {
        switch self {
        case .light:
            return .black
        case .dark:
            return .white
        case .blur:
            return .clear //UIColor.black.withAlphaComponent(0.8)
        }
    }
    
    var closeButtonForgourndColor: UIColor {
        switch self {
        case .light:
            return .black
        case .dark:
            return .white
        case .blur:
            return .white //UIColor.black.withAlphaComponent(0.8)
        }
    }
}
