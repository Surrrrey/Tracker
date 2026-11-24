import CoreData

final class TrackerRecordStore: NSObject {
    private let context: NSManagedObjectContext
    
    var onRecordsChanged: (() -> Void)?
    
    private(set) var records: [TrackerRecord] = []
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerRecordCD> = {
        let request = TrackerRecordCD.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        
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
    
    func addNewTrackerRecord(_ trackerRecord: TrackerRecord) throws {
        let newTrackerRecord = TrackerRecordCD(context: context)
        try updateExistingTrackerRecord(newTrackerRecord, with: trackerRecord)
        
        try context.save()
    }
    
    func deleteTrackerRecord(_ trackerRecord: TrackerRecord) throws {
        let request = TrackerRecordCD.fetchRequest()
        request.predicate = NSPredicate(format: "trackerId = %@ AND date == %@",
                                        trackerRecord.trackerId as CVarArg,
                                        trackerRecord.date as CVarArg)
        
        for object in try context.fetch(request) {
            context.delete(object)
        }
        try context.save()
    }
    
    func updateExistingTrackerRecord(_ trackerRecordCD: TrackerRecordCD, with trackerRecord: TrackerRecord) throws {
        trackerRecordCD.trackerId = trackerRecord.trackerId
        trackerRecordCD.date = trackerRecord.date
    }
    
    private func refreshCache() {
        records = (fetchedResultsController.fetchedObjects ?? []).compactMap {
            guard let id = $0.trackerId,
                  let date = $0.date
            else { return nil }
            return TrackerRecord(trackerId: id, date: date)
        }
    }
}

extension TrackerRecordStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        refreshCache()
        onRecordsChanged?()
    }
}
