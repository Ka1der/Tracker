//
//  NewScheduleControllerDelegate.swift
//  Tracker
//
//  Created by Kaider on 08.12.2024.
//

protocol NewScheduleControllerDelegate: AnyObject {
    func didUpdateSchedule(_ schedule: Set<WeekDay>)
}
