//
//  TrackerTests.swift
//  TrackerTests
//
//  Created by Kaider on 24.11.2024.
//

import XCTest
import UIKit
import SnapshotTesting
@testable import Tracker

final class TrackerTests: XCTestCase {
    func testViewController() {

           let vc = TrackersViewController()
           print("View controller создан: \(vc)")

           print("Создание снимка view controller")
           assertSnapshot(of: vc, as: .image, record: false)
           print("Снимок успешно создан и проверен")
       }
}
