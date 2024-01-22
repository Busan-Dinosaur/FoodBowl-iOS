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
            let repository = SearchUnivRepositoryImpl()
            let usecase = SearchUnivUsecaseImpl(repository: repository)
            let viewModel = SearchUnivViewModel(usecase: usecase)
            let viewController = SearchUnivViewController(viewModel: viewModel)
            viewController.delegate = self
            let navigationController = UINavigationController(rootViewController: viewController)
            navigationController.modalPresentationStyle = .fullScreen
            
            DispatchQueue.main.async {
                self?.present(navigationController, animated: true)
            }
        }
        $0.addAction(action, for: .touchUpInside)
        $0.frame = CGRect(x: 0, y: 0, width: 300, height: 45)
        $0.label.text = UserDefaultStorage.schoolName ?? "대학가"
    }
    
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
        viewModel.schoolId = UserDefaultStorage.schoolId
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

    private func currentUniv() {
        guard let schoolX = UserDefaultStorage.schoolX, let schoolY = UserDefaultStorage.schoolY else { return }

        mapView.setRegion(
            MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: schoolY, longitude: schoolX),
                span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
            ),
            animated: true
        )
    }
}

extension UnivViewController: SearchUnivViewControllerDelegate {
    func setUniv(univ: Store) {
        UserDefaultHandler.setSchoolId(schoolId: univ.id)
        UserDefaultHandler.setSchoolName(schoolName: univ.name)
        UserDefaultHandler.setSchoolX(schoolX: univ.x)
        UserDefaultHandler.setSchoolY(schoolY: univ.y)
        
        univTitleButton.label.text = univ.name
        viewModel.schoolId = univ.id
        self.currentUniv()
        if let customLocation = customLocation {
            customLocationPublisher.send(customLocation)
        }
    }
}
