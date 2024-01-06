//
//  CircularProgressView.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 03/01/2024.
//

import UIKit

class CircularProgressView: UIView {

    private let shapeLayer = CAShapeLayer()
    private let backgroundLayer = CAShapeLayer()
    private let progressAnimationDuration: TimeInterval = 0.5
    private let stepLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayers()
        setupLabel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayers() {
        // Background layer for the unfilled part of the circle
        backgroundLayer.lineWidth = 10
        backgroundLayer.fillColor = UIColor.clear.cgColor
        backgroundLayer.strokeColor = UIColor.myGray.cgColor
        layer.addSublayer(backgroundLayer)

        // Shape layer for the filled part of the circle
        shapeLayer.lineWidth = 10
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.mySecondary.cgColor // Change to your desired color
        layer.addSublayer(shapeLayer)
    }

    private func setupLabel() {
        stepLabel.translatesAutoresizingMaskIntoConstraints = false
        stepLabel.textAlignment = .center
        stepLabel.font = UIFont.boldSystemFont(ofSize: 16) // Adjust font size as needed
        addSubview(stepLabel)

        NSLayoutConstraint.activate([
            stepLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            stepLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: bounds.midX, y: bounds.midY), radius: bounds.width / 2, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
        backgroundLayer.path = circularPath.cgPath
        backgroundLayer.strokeEnd = 1.0

        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeEnd = 0
    }

    func setStepNumber(currentStep: Int, totalSteps: Int) {
        stepLabel.text = "\(currentStep) of \(totalSteps)"
    }

    func animateProgress(forStep step: Int, totalSteps: Int) {
        let progress = CGFloat(step) / CGFloat(totalSteps)
        shapeLayer.strokeEnd = progress

        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = shapeLayer.presentation()?.strokeEnd
        animation.toValue = progress
        animation.duration = progressAnimationDuration
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        shapeLayer.add(animation, forKey: "progressAnimation")
    }
}
