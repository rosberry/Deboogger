//
//  Copyright © 2019 Rosberry. All rights reserved.
//

typealias MemoryUsage = (used: UInt64, total: UInt64)

final class PerformanceMonitor {

    typealias MonitoringHandler = (MonitoringInfo) -> Void

    struct MonitoringInfo {
        let memoryUsage: MemoryUsage
    }

    var monitoringHandler: MonitoringHandler?

    private lazy var displayLink: CADisplayLink = .init(target: self, selector: #selector(step))

    private var isMonitoring: Bool = false

    // MARK: - Lifecycle

    deinit {
        displayLink.invalidate()
    }

    func startMonitoring() {
        guard isMonitoring == false else {
            return
        }
        displayLink = .init(target: self, selector: #selector(step))
        displayLink.add(to: .current, forMode: .common)
        isMonitoring = true
    }

    func stopMonitoring() {
        guard isMonitoring else {
            return
        }
        displayLink.invalidate()
        isMonitoring = false
    }

    // MARK: - Private

    @objc private func step() {
        let memoryUsage = getMemoryUsage()
        let monitorInfo = MonitoringInfo(memoryUsage: memoryUsage)
        monitoringHandler?(monitorInfo)
    }

    private func getMemoryUsage() -> MemoryUsage {
        var taskInfo = task_vm_info_data_t()
        var count = mach_msg_type_number_t(MemoryLayout<task_vm_info>.size) / 4
        let result: kern_return_t = withUnsafeMutablePointer(to: &taskInfo) { pointer in
            pointer.withMemoryRebound(to: integer_t.self, capacity: 1) { pointer in
                task_info(mach_task_self_, task_flavor_t(TASK_VM_INFO), pointer, &count)
            }
        }

        var used: UInt64 = 0
        if result == KERN_SUCCESS {
            used = UInt64(taskInfo.phys_footprint)
        }

        let total = ProcessInfo.processInfo.physicalMemory
        return (used, total)
    }
}
