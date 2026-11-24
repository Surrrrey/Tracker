import UIKit

final class UIColorValueTransformer: NSSecureUnarchiveFromDataTransformer {

    override class var allowedTopLevelClasses: [AnyClass] {
        [UIColor.self]
    }

    static func register() {
        ValueTransformer.setValueTransformer(
            UIColorValueTransformer(),
            forName: NSValueTransformerName(rawValue: String(describing: UIColorValueTransformer.self))
        )
    }
}

