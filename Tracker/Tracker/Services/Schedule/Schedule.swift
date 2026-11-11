import Foundation

enum Schedule {
    case none
    case daily
    case weekly(days: Set<Weekday>)
}

enum Weekday: Int, CaseIterable {
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    case sunday
    
    var calendarComponent: Calendar.Component {
        switch self {
        case .monday: return .weekday
        case .tuesday: return .weekday
        case .wednesday: return .weekday
        case .thursday: return .weekday
        case .friday: return .weekday
        case .saturday: return .weekday
        case .sunday: return .weekday
        }
    }
    
    var displayName: String {
        switch self {
        case .monday: return "Понедельник"
        case .tuesday: return "Вторник"
        case .wednesday: return "Среда"
        case .thursday: return "Четверг"
        case .friday: return "Пятница"
        case .saturday: return "Суббота"
        case .sunday: return "Воскресенье"
        }
    }
    
    var displayShortName: String {
        switch self {
        case .monday: return "Пн"
        case .tuesday: return "Вт"
        case .wednesday: return "Ср"
        case .thursday: return "Чт"
        case .friday: return "Пт"
        case .saturday: return "Сб"
        case .sunday: return "Вс"
        }
    }
}

extension Weekday {
    static func current(from date: Date) -> Weekday? {
        let number = Calendar.current.component(.weekday, from: date)
        
        return Weekday(rawValue: (number + 5) % 7)
    }
}
