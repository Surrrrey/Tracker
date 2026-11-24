import CoreData

final class TrackerCategoryStore: NSObject {
    private let context: NSManagedObjectContext
    
    var onCategoriesChanged: (() -> Void)?
    
    private(set) var categories: [TrackerCategory] = []
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCD> = {
        let request = TrackerCategoryCD.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "category", ascending: true)]
        
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
    
    func addNewTrackerCategory(_ trackerCategory: TrackerCategory) throws {
        let newTrackerCategory = TrackerCategoryCD(context: context)
        try updateExistingTrackerCategory(newTrackerCategory, with: trackerCategory)
        
        try context.save()
    }
    
    func updateExistingTrackerCategory(_ trackerCategoryCD: TrackerCategoryCD, with trackerCategory: TrackerCategory) throws {
        trackerCategoryCD.category = trackerCategory.category
        
        let ids: [UUID] = trackerCategory.trackers.map { $0.id }
        guard !ids.isEmpty else {
            trackerCategoryCD.trackers = nil
            return
        }
        let request = TrackerCD.fetchRequest()
        request.predicate = NSPredicate(format: "id IN %@", ids)
        
        let foundTrackers = try context.fetch(request)
        
        trackerCategoryCD.trackers = NSSet(array: foundTrackers)
    }
    
    private func refreshCache() {
        categories = (fetchedResultsController.fetchedObjects ?? []).compactMap {
            makeCategory(from: $0)
        }
    }
    
    private func makeCategory(from cd: TrackerCategoryCD) -> TrackerCategory? {
        guard let title = cd.category else { return nil }
        let trackers = (cd.trackers?.allObjects ?? [])
            .compactMap { $0 as? TrackerCD }
            .compactMap { $0.makeTracker() }
        return TrackerCategory(category: title, trackers: trackers)
    }
}

extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        refreshCache()
        onCategoriesChanged?()
    }
}
