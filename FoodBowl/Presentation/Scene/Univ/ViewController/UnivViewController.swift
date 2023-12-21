//
//  UnivViewController.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/07/18.
//

import MapKit
import UIKit

import SnapKit
import Then

final class UnivViewController: MapViewController {
    
    // MARK: - ui component

    private lazy var univTitleButton = UnivTitleButton().then {
        let action = UIAction { [weak self] _ in
            let searchUnivViewController = SearchUnivViewController()
            searchUnivViewController.delegate = self
            let navigationController = UINavigationController(rootViewController: searchUnivViewController)
            navigationController.modalPresentationStyle = .fullScreen
            DispatchQueue.main.async {
                self?.present(navigationController, animated: true)
            }
        }
        $0.downButton.addAction(action, for: .touchUpInside)
        $0.frame = CGRect(x: 0, y: 0, width: 300, height: 45)
        $0.label.text = "대학가"
    }
    
    private var univ = UserDefaultsManager.currentUniv
    
    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.setupNavigationBar()
        self.currentUniv()
    }
    
    override func configureUI() {
        super.configureUI()
        viewModel.type = .univ
        viewModel.schoolId = univ?.id
    }
    
    private func setupNavigationBar() {
        let leftOffsetUnivTitleButton = removeBarButtonItem(with: univTitleButton, offsetX: 10)
        let univTitleButton = makeBarButtonItem(with: leftOffsetUnivTitleButton)
        let plusButton = makeBarButtonItem(with: plusButton)
        navigationItem.leftBarButtonItem = univTitleButton
        navigationItem.rightBarButtonItem = plusButton
    }

    private func removeBarButtonItem(with button: UIButton, offsetX: CGFloat = 0, offsetY: CGFloat = 0) -> UIView {
        let offsetView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 45))
        offsetView.bounds = offsetView.bounds.offsetBy(dx: offsetX, dy: offsetY)
        offsetView.addSubview(button)
        return offsetView
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        univTitleButton.label.text = univ?.name ?? "대학가"
    }

    private func currentUniv() {
        guard let univ = self.univ else { return }

        mapView.setRegion(
            MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: univ.y, longitude: univ.x),
                span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
            ),
            animated: true
        )
    }
}

extension UnivViewController: SearchUnivViewControllerDelegate {
    func setUniv(univ: School) {
        self.univ = univ
        UserDefaultsManager.currentUniv = univ
        univTitleButton.label.text = univ.name
        viewModel.schoolId = univ.id
        self.currentUniv()
        if let customLocation = customLocation {
            customLocationPublisher.send(customLocation)
        }
    }
}
