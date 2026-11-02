import Foundation

enum Schedule {
    case none
    case daily
    case weekly(days: Set<Weekday>)
    case everyNDay(interval: Int)
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
