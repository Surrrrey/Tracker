import UIKit

struct Tracker {
    let id: UUID
    let name: String
    let color: UIColor
    let emoji: String
    let schedule: Schedule
    
    func isScheduled(on date: Date) -> Bool {
        switch schedule {
        case .none, .daily:
            return true
        case .weekly(let days):
            let current = Weekday.current(from: date)
            
            guard let current else { return false }
            
            return days.contains(current)            
        }
    }
}
