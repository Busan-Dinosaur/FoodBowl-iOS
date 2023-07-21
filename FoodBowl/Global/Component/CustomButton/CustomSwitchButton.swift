//
//  CustomSwitchButton.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/07/22.
//

import UIKit

protocol CustomSwitchButtonDelegate: AnyObject {
    func isOnValueChange(isOn: Bool)
}

class CustomSwitchButton: UIButton {
    typealias SwitchColor = (bar: UIColor, circle: UIColor)

    private var barView: UIView!
    private var circleView: UIView!

    var isOn: Bool = false {
        didSet {
            changeState()
        }
    }

    // on 상태의 스위치 색상
    var onColor: SwitchColor = (#colorLiteral(red: 0.9960784314, green: 0.9058823529, blue: 0.9058823529, alpha: 1), #colorLiteral(red: 0.8901960784, green: 0.3137254902, blue: 0.3254901961, alpha: 1)) {
        didSet {
            if isOn {
                self.barView.backgroundColor = self.onColor.bar
                self.circleView.backgroundColor = self.onColor.circle
            }
        }
    }

    // off 상태의 스위치 색상
    var offColor: SwitchColor = (#colorLiteral(red: 0.9098039216, green: 0.9098039216, blue: 0.9098039216, alpha: 1), #colorLiteral(red: 0.7709601521, green: 0.7709783912, blue: 0.7709685564, alpha: 1)) {
        didSet {
            if isOn == false {
                self.barView.backgroundColor = self.offColor.bar
                self.circleView.backgroundColor = self.offColor.circle
            }
        }
    }

    // 스위치가 이동하는 애니메이션 시간
    var animationDuration: TimeInterval = 0.25

    // 스위치 isOn 값 변경 시 애니메이션 여부
    private var isAnimated: Bool = false

    // barView의 상, 하단 마진 값
    var barViewTopBottomMargin: CGFloat = 5

    weak var delegate: CustomSwitchButtonDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)

        buttonInit(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        buttonInit(frame: frame)
    }

    private func buttonInit(frame: CGRect) {
        let barViewHeight = frame.height - (barViewTopBottomMargin * 2)

        barView = UIView(frame: CGRect(x: 0, y: barViewTopBottomMargin, width: frame.width, height: barViewHeight))
        barView.backgroundColor = offColor.bar
        barView.layer.masksToBounds = true
        barView.layer.cornerRadius = barViewHeight / 2

        addSubview(barView)

        circleView = UIView(frame: CGRect(x: 0, y: 0, width: frame.height, height: frame.height))
        circleView.backgroundColor = offColor.circle
        circleView.layer.masksToBounds = true
        circleView.layer.cornerRadius = frame.height / 2

        addSubview(circleView)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        setOn(on: !isOn, animated: true)
    }

    func setOn(on: Bool, animated: Bool) {
        isAnimated = animated
        isOn = on
    }

    private func changeState() {
        var circleCenter: CGFloat = 0
        var barViewColor: UIColor = .clear
        var circleViewColor: UIColor = .clear

        if isOn {
            circleCenter = frame.width - (circleView.frame.width / 2)
            barViewColor = onColor.bar
            circleViewColor = onColor.circle
        } else {
            circleCenter = circleView.frame.width / 2
            barViewColor = offColor.bar
            circleViewColor = offColor.circle
        }

        let duration = isAnimated ? animationDuration : 0

        UIView.animate(withDuration: duration, animations: { [weak self] in
            guard let self = self else { return }

            self.circleView.center.x = circleCenter
            self.barView.backgroundColor = barViewColor
            self.circleView.backgroundColor = circleViewColor

        }) { [weak self] _ in
            guard let self = self else { return }

            self.delegate?.isOnValueChange(isOn: self.isOn)
            self.isAnimated = false
        }
    }
}
