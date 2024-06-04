//
//  ViewController.swift
//  SSLPinningDemo
//
//  Created by Mayank Negi on 31/05/24.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tempLabel: UILabel!

    let viewModel = ViewModel(service: NetworkManager())

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewModel.delegate = self
        viewModel.getTemp()
    }
}

extension ViewController: ViewModelDelegate {
    func viewModelDidReceiveWeatherInfo(_ viewModel: ViewModel) {
        DispatchQueue.main.async {
            self.tempLabel.text = viewModel.temp
        }
    }
    
    func viewModelDidFailToReceiveResponse(_ viewModel: ViewModel, error: Error) {
        print("Something went wrong.")
    }
}

