//
//  ViewModel.swift
//  SSLPinningDemo
//
//  Created by Mayank Negi on 31/05/24.
//

import Foundation

protocol ViewModelDelegate: AnyObject {
    func viewModelDidReceiveWeatherInfo(_ viewModel: ViewModel)
    func viewModelDidFailToReceiveResponse(_ viewModel: ViewModel, error: Error)
}

final class ViewModel {

    var temp = ""

    weak var delegate: ViewModelDelegate?

    let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=29.7453&lon=78.5198&appid={YOUR_APP_ID}}&units=metric"
    let service: NetworkManager

    init(service: NetworkManager) {
        self.service = service
    }

    func getTemp() {

        self.service.getTemp(urlString: urlString) { [weak self] result in
            guard let self else {
                return
            }

            switch result {
            case .success(let response):
                self.temp = "\(response.main.temp)"
                self.delegate?.viewModelDidReceiveWeatherInfo(self)
            case .failure(let error):
                self.delegate?.viewModelDidFailToReceiveResponse(self, error: error)
            }
        }
    }
}
