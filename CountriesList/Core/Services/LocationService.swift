//
//  LocationService.swift
//  CountriesList
//
//  Created by Ibrahim Saber on 17/01/2026.
//

import Foundation
import CoreLocation
import Combine

protocol LocationServiceProtocol {
    func getCurrentCountryCode() -> AnyPublisher<String, Never>
}

final class LocationService: NSObject, LocationServiceProtocol {
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    private var currentSubject: PassthroughSubject<String, Never>?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
    }
    
    func getCurrentCountryCode() -> AnyPublisher<String, Never> {
        let subject = PassthroughSubject<String, Never>()
        currentSubject = subject
        
        let status = locationManager.authorizationStatus
        
        if status == .denied || status == .restricted {
            return Just("EG").eraseToAnyPublisher()
        }
        
        if status == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        } else {
            locationManager.requestLocation()
        }
        
        return subject
            .setFailureType(to: Error.self)
            .timeout(.seconds(5), scheduler: DispatchQueue.main, customError: { URLError(.timedOut) })
            .catch { _ in Just("EG") }
            .eraseToAnyPublisher()
    }
    
    private func sendResult(_ code: String) {
        currentSubject?.send(code)
        currentSubject?.send(completion: .finished)
        currentSubject = nil
    }
}

extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            sendResult("EG")
            return
        }
        
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            guard let self = self else { return }
            
            if let error = error {
                self.sendResult("EG")
                return
            }
            
            if let countryCode = placemarks?.first?.isoCountryCode {
                self.sendResult(countryCode)
            } else {
                self.sendResult("EG")
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        sendResult("EG")
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .denied || manager.authorizationStatus == .restricted {
            sendResult("EG")
        } else if manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways {
            manager.requestLocation()
        }
    }
}
