//
//  UICollectionViewDataSource.swift
//  Tracker
//
//  Created by Kaider on 01.12.2024.
//

import UIKit

extension TrackersViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return filteredCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
          return filteredCategories[section].trackers.count
      }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TrackerCell.identifier,
            for: indexPath
        ) as? TrackerCell else {
            print("\(#file):\(#line)] \(#function) Ошибка приведения типа ячейки")
            return UICollectionViewCell()
        }
        
        let tracker = filteredCategories[indexPath.section].trackers[indexPath.row]
        let isCompleted = isTrackerCompleted(tracker, date: currentDate)
        let completedCount = countCompletedDays(for: tracker)
        
        cell.configure(
            with: tracker,
            currentDate: currentDate,
            completedDaysCount: completedCount,
            isCompleted: isCompleted
        )
        
        cell.configureCompletionHandler(tracker: tracker, isCompleted: isCompleted) { [weak self] in
            guard let self = self else { return }
            if isCompleted {
                self.removeTrackerRecord(tracker, date: self.currentDate)
            } else {
                self.addTrackerRecord(tracker, date: self.currentDate)
            }
        }
        
        print("\(#file):\(#line)] \(#function) Настройка ячейки для трекера: \(tracker.title), дата: \(currentDate)")
        
        return cell
    }
    
    func toggleTracker(_ tracker: Tracker) {
        let calendar = Calendar.current
        let trackerID = tracker.id
        
        if let index = completedTrackers.firstIndex(where: { record in
            record.id == trackerID && calendar.isDate(record.date, inSameDayAs: currentDate)
        }) {
            completedTrackers.remove(at: index)
        } else {
            let record = TrackerRecord(id: trackerID, date: currentDate)
            completedTrackers.append(record)
        }
        
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let view = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: "header",
                for: indexPath
            ) as? SupplementaryView else {
                print("\(#file):\(#line)] \(#function) Ошибка приведения типа header view")
                return UICollectionReusableView()
            }
            
            view.titleLabel.text = categories[indexPath.section].title
            return view
            
        case UICollectionView.elementKindSectionFooter:
    
            return UICollectionReusableView()
            
        default:
            print("\(#file):\(#line)] \(#function) Запрошен неизвестный тип supplementary view: \(kind)")
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return .zero
    }
}

extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 167, height: 148)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
    }
}
