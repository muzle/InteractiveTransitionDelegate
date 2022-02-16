import Foundation

protocol Applicable {
    
}

extension Applicable {
    @discardableResult
    func apply(_ closure: (Self) -> Void) -> Self {
        closure(self)
        return self
    }
}

extension NSObject: Applicable { }
