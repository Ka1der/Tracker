//
//  NSFetchedResultsControllerDelegate.swift
//  Tracker
//
//  Created by Kaider on 28.12.2024.
//
import CoreData

final class NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
         
          NotificationCenter.default.post(
              name: NSNotification.Name("TrackersDataDidChange"),
              object: nil
          )
          print("\(#file):\(#line)] \(#function) База обновлена нахуй!")
      }
      
      func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                     didChange anObject: Any,
                     at indexPath: IndexPath?,
                     for type: NSFetchedResultsChangeType,
                     newIndexPath: IndexPath?) {
          print("\(#file):\(#line)] \(#function) Изменение объекта типа: \(type.rawValue)")
      }
}
