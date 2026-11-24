import CoreData
import UIKit

private enum TrackerStoreError: Error {
    case scheduleTransformError
}

final class TrackerStore: NSObject {
    private let context: NSManagedObjectContext
    
    var onTrackersChanged: (() -> Void)?
    
    private(set) var trackers: [Tracker] = []
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCD> = {
        let request = TrackerCD.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        let frc = NSFetchedResultsController(fetchRequest: request,
                                             managedObjectContext: context,
                                             sectionNameKeyPath: nil,
                                             cacheName: nil)
        
        frc.delegate = self
        return frc
    }()
    
    override convenience init() {
        self.init(context: CoreDataStack.shared.context)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
        super.init()
    }
    
    func performFetch() throws {
        try fetchedResultsController.performFetch()
        refreshCache()
    }
    
    func addNewTracker(_ tracker: Tracker) throws {
        let newTracker = TrackerCD(context: context)
        try updateExistingTracker(newTracker, with: tracker)
        
        try context.save()
    }
    
    func updateExistingTracker(_ trackerCD: TrackerCD, with tracker: Tracker) throws {
        let scheduleData = ScheduleTransformer().transformedValue(tracker.schedule) as? NSData
        guard let scheduleData else {
            print("Decode error: cannot transform schedule from tracker")
            throw TrackerStoreError.scheduleTransformError }
        trackerCD.id = tracker.id
        trackerCD.name = tracker.name
        trackerCD.color = tracker.color
        trackerCD.emoji = tracker.emoji
        trackerCD.schedule = scheduleData
    }
    
    private func refreshCache() {
        trackers = (fetchedResultsController.fetchedObjects ?? []).compactMap {
            $0.makeTracker()
        }
    }
}

extension TrackerStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        refreshCache()
        onTrackersChanged?()
    }
}

extension TrackerCD {
    func makeTracker() -> Tracker? {
        guard
            let id = id,
            let name = name,
            let emoji = emoji,
            let color = color as? UIColor,
            let scheduleData = schedule as? Data
        else {
            print("makeTracker dropped tracker, id:", String(describing: id))
            return nil
        }

        let days = (try? JSONDecoder().decode([Weekday].self, from: scheduleData)) ?? []
        let set = Set(days)

        let schedule: Schedule
        if set.isEmpty {
            schedule = .none
        } else if set.count == Weekday.allCases.count {
            schedule = .daily
        } else {
            schedule = .weekly(days: set)
        }

        return Tracker(id: id, name: name, color: color, emoji: emoji, schedule: schedule)
    }
}
