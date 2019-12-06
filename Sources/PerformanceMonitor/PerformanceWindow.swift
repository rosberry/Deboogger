//
//  Copyright © 2019 Rosberry. All rights reserved.
//

import UIKit

final class PerformanceWindow: UIWindow {

    private enum Constants {
        static let labelContentInset: CGFloat = 4
        static let defaultStatusBarHeight: CGFloat = 20
    }

    private var windowFrame: CGRect {
        guard let window = UIApplication.shared.delegate?.window as? UIWindow else {
            return .zero
        }
        let height: CGFloat
        if memoryUsageLabel.frame.height < Constants.defaultStatusBarHeight {
            height = Constants.defaultStatusBarHeight
        }
        else {
            height = memoryUsageLabel.frame.height
        }
        var topInset: CGFloat = 0
        if #available(iOS 11.0, *), let topSafeAreaInset = window.rootViewController?.view.safeAreaInsets.top {
            if topSafeAreaInset > Constants.defaultStatusBarHeight {
                topInset = topSafeAreaInset
            }
        }
        return .init(x: 0.0, y: topInset, width: window.bounds.width, height: height)
    }

    private let performanceMonitor: PerformanceMonitor

    // MARK: - Subviews

    private lazy var memoryUsageLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.clipsToBounds = true
        label.layer.cornerRadius = 4
        label.layer.borderColor = UIColor.black.cgColor
        label.layer.borderWidth = 1
        label.backgroundColor = .white
        label.textColor = .black
        label.font = .systemFont(ofSize: 10)
        label.numberOfLines = 0
        label.textPaddings = UIEdgeInsets(top: 0,
                                          left: Constants.labelContentInset,
                                          bottom: 0,
                                          right: Constants.labelContentInset)
        return label
    }()

    // MARK: - Lifecycle

    init(performanceMonitor: PerformanceMonitor) {
        self.performanceMonitor = performanceMonitor
        super.init(frame: .zero)
        configure()

        performanceMonitor.monitoringHandler = { [weak self] info in
            self?.update(with: info)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layoutWindow()
    }

    func show() {
        isHidden = false
        performanceMonitor.startMonitoring()
        layoutWindow()
    }

    func hide() {
        isHidden = true
        performanceMonitor.stopMonitoring()
    }

    // MARK: - Private

    private func configure() {
        windowLevel = UIWindow.Level.statusBar + 1
        backgroundColor = .green
        clipsToBounds = true
        isHidden = true

        addSubview(memoryUsageLabel)
    }

    private func layoutWindow() {
        frame = windowFrame
        layoutInfoLabel()
    }

    private func layoutInfoLabel() {
        let labelSize = memoryUsageLabel.sizeThatFits(frame.size)
        memoryUsageLabel.frame = .init(origin: .zero, size: labelSize)
        memoryUsageLabel.center = CGPoint(x: frame.width / 2, y: frame.height / 2)
    }

    private func update(with info: PerformanceMonitor.MonitoringInfo) {
        let bytesInMegabyte = 1024.0 * 1024.0
        let usedMemory = Double(info.memoryUsage.used) / bytesInMegabyte
        let totalMemory = Double(info.memoryUsage.total) / bytesInMegabyte
        memoryUsageLabel.text = String(format: "%.1f of %.0f MB used", usedMemory, totalMemory)
        layoutInfoLabel()
    }
}
