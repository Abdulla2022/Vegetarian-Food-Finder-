//
//  CalendarViewController.swift
//  Vegetarian-Food-Finder
//
//  This File was taken from https://github.com/richardtop/CalendarApp .
//  link to the file https://github.com/richardtop/CalendarApp/blob/master/Calendar/CalendarViewController.swift

import CalendarKit
import EventKit
import EventKitUI
import UIKit

final class CalendarViewController: DayViewController, EKEventEditViewDelegate {
    var visitStartTime: Date?
    var visitEndTime: Date?
    lazy var eventStore: EKEventStore = {
        EKEventStore()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Calendar"
        requestAccessToCalendar()
        subscribeToNotifications()
        createRestaurantEvent()
    }
    private func requestAccessToCalendar() {
        eventStore.requestAccess(to: .event) { [weak self] _, _ in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.initializeStore()
                self.subscribeToNotifications()
                self.reloadData()
            }
        }
    }

    private func subscribeToNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(storeChanged(_:)),
                                               name: .EKEventStoreChanged,
                                               object: eventStore)
    }

    private func initializeStore() {
        eventStore = EKEventStore()
    }

    @objc private func storeChanged(_ notification: Notification) {
        reloadData()
    }

    override func eventsForDate(_ date: Date) -> [EventDescriptor] {
        let startDate = date
        var oneDayComponents = DateComponents()
        oneDayComponents.day = 1
        let endDate = calendar.date(byAdding: oneDayComponents, to: startDate)!

        let predicate = eventStore.predicateForEvents(withStart: startDate,
                                                      end: endDate,
                                                      calendars: nil)

        let eventKitEvents = eventStore.events(matching: predicate)
        let calendarKitEvents = eventKitEvents.map(EkWrapper.init)

        return calendarKitEvents
    }

    override func dayViewDidSelectEventView(_ eventView: EventView) {
        guard let ckEvent = eventView.descriptor as? EkWrapper else {
            return
        }
        presentDetailViewForEvent(ckEvent.ekEvent)
    }

    private func presentDetailViewForEvent(_ ekEvent: EKEvent) {
        let eventController = EKEventViewController()
        eventController.event = ekEvent
        eventController.allowsCalendarPreview = true
        eventController.allowsEditing = true
        navigationController?.pushViewController(eventController,
                                                 animated: true)
    }

    override func dayView(dayView: DayView, didLongPressTimelineAt date: Date) {
        endEventEditing()
        let newEKWrapper = createNewEvent(at: date)
        create(event: newEKWrapper, animated: true)
    }

    private func createNewEvent(at date: Date) -> EkWrapper {
        let newEKEvent = EKEvent(eventStore: eventStore)
        newEKEvent.calendar = eventStore.defaultCalendarForNewEvents

        var components = DateComponents()
        components.hour = 1
        let endDate = calendar.date(byAdding: components, to: date)

        newEKEvent.startDate = date
        newEKEvent.endDate = endDate
        newEKEvent.title = "New event"

        let newEKWrapper = EkWrapper(eventKitEvent: newEKEvent)
        newEKWrapper.editedEvent = newEKWrapper
        return newEKWrapper
    }

    override func dayViewDidLongPressEventView(_ eventView: EventView) {
        guard let descriptor = eventView.descriptor as? EkWrapper else {
            return
        }
        endEventEditing()
        beginEditing(event: descriptor,
                     animated: true)
    }

    override func dayView(dayView: DayView, didUpdate event: EventDescriptor) {
        guard let editingEvent = event as? EkWrapper else { return }
        if let originalEvent = event.editedEvent {
            editingEvent.commitEditing()

            if originalEvent === editingEvent {
                presentEditingViewForEvent(editingEvent.ekEvent)
            } else {
                try! eventStore.save(editingEvent.ekEvent,
                                     span: .thisEvent)
            }
        }
        reloadData()
    }

    private func presentEditingViewForEvent(_ ekEvent: EKEvent) {
        let eventEditViewController = EKEventEditViewController()
        eventEditViewController.event = ekEvent
        eventEditViewController.eventStore = eventStore
        eventEditViewController.editViewDelegate = self
        present(eventEditViewController, animated: true, completion: nil)
    }

    override func dayView(dayView: DayView, didTapTimelineAt date: Date) {
        endEventEditing()
    }

    override func dayViewDidBeginDragging(dayView: DayView) {
        endEventEditing()
    }

    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        endEventEditing()
        reloadData()
        controller.dismiss(animated: true, completion: nil)
    }
}
