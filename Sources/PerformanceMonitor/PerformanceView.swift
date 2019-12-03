//
//  Copyright © 2019 Rosberry. All rights reserved.
//

import UIKit

final class PerformanceView: UIWindow {

    private var windowFrame: CGRect {
        guard let window = UIApplication.shared.delegate?.window as? UIWindow else {
            return .zero
        }
        let height = memoryUsageLabel.frame.height
        var topInset: CGFloat = 0
        if #available(iOS 11.0, *), let topSafeAreaInset = window.rootViewController?.view.safeAreaInsets.top {
            topInset = topSafeAreaInset
        }
        return .init(x: 0.0, y: topInset, width: window.bounds.width, height: height)
    }

    private let performanceMonitor: PerformanceMonitor

    // MARK: - Subviews

    private lazy var memoryUsageLabel: UILabel = .init()

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
        memoryUsageLabel.center = CGPoint(x: frame.width / 2, y: frame.height / 2)
        memoryUsageLabel.sizeToFit()
    }

    private func update(with info: PerformanceMonitor.MonitoringInfo) {
        let bytesInMegabyte = 1024.0 * 1024.0
        let usedMemory = Double(info.memoryUsage.used) / bytesInMegabyte
        let totalMemory = Double(info.memoryUsage.total) / bytesInMegabyte
        memoryUsageLabel.text = String(format: "%.1f of %.0f MB used", usedMemory, totalMemory)
        layoutInfoLabel()
    }
}
