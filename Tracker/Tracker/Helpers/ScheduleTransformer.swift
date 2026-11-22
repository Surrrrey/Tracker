import Foundation
import CoreData

@objc
final class ScheduleTransformer: ValueTransformer {
    //Определяем тип данных для хранения
    override class func transformedValueClass() -> AnyClass {
        NSData.self
    }
    
    // Указываем что конвертация идёт в обе стороны
    override class func allowsReverseTransformation() -> Bool {
        true
    }
    
    //Переопределяем функции которые кодируют и декодируют объект
    override func transformedValue(_ value: Any?) -> Any? {
        if let data = value as? Data {
            return data
        }
        
        guard let schedule = value as? Schedule else { return nil }
        
        let days: [Weekday]
        switch schedule {
        case .none:
            days = []
        case .daily:
            days = Weekday.allCases
        case .weekly(let selected):
            days = Array(selected)
        }
        
        return try? JSONEncoder().encode(days)
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        value as? Data
    }
    
    //Регистрируем кастомный трансформер
    static func register() {
        ValueTransformer.setValueTransformer(ScheduleTransformer()
                                             , forName: NSValueTransformerName(rawValue: String(describing: ScheduleTransformer.self)))
    }
}

