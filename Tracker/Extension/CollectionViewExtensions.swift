//
//  UICollectionViewDataSource.swift
//  Tracker
//
//  Created by Kaider on 01.12.2024.
//

import UIKit

extension NavigationBarViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TrackerCell.identifier,
            for: indexPath
        ) as? TrackerCell else {
            print("\(#file):\(#line)] \(#function) Ошибка приведения типа ячейки")
            return UICollectionViewCell()
        }
        let tracker = trackers[indexPath.item]
        cell.configure(title: tracker.title, emoji: tracker.emoji)
        cell.backgroundColor = tracker.color
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
               let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
                      withReuseIdentifier: "header",
                      for: indexPath
                  )
                  
                  // Создаем и настраиваем лейбл в хедере
                  let label = UILabel()
                  label.text = "30 ноября" //  текст хедера
                  label.font = .boldSystemFont(ofSize: 16)
                  label.translatesAutoresizingMaskIntoConstraints = false
                  
                  header.addSubview(label)
                  
                  NSLayoutConstraint.activate([
                      label.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 16),
                      label.centerYAnchor.constraint(equalTo: header.centerYAnchor)
                  ])
                  
                  return header
              } else {
                  let footer = collectionView.dequeueReusableSupplementaryView(
                      ofKind: kind,
                      withReuseIdentifier: "footer",
                      for: indexPath
                  )
                  
                  // Настраиваем футер аналогично
                  let label = UILabel()
                  label.text = "Выполнено: 5" // текст футера
                  label.font = .systemFont(ofSize: 14)
                  label.translatesAutoresizingMaskIntoConstraints = false
                  
                  footer.addSubview(label)
                  
                  NSLayoutConstraint.activate([
                      label.leadingAnchor.constraint(equalTo: footer.leadingAnchor, constant: 16),
                      label.centerYAnchor.constraint(equalTo: footer.centerYAnchor)
                  ])
                  
                  return footer
        }
    }

    // Размеры хедера/футера
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }
}
    
extension NavigationBarViewController: UICollectionViewDelegateFlowLayout {
    
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

