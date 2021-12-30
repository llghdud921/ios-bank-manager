import Foundation

class Bank {
    private var waitingLine = Queue<Customer>()
    private var bankClerk = BankClerk()
    
    func setWaitingLine(with numberOfCustomer: Int) {
        let totalNumber = numberOfCustomer
        for number in 1...totalNumber {
            waitingLine.enqueue(Customer(waitingNumber: number))
        }
    }
    
    private func dequeueWaitingLine() -> Customer? {
        return waitingLine.dequeue()
    }
    
    func startWork() {
        let depositQueue = DispatchQueue(label: "depositQueue", attributes: .concurrent)
        let loanQueue = DispatchQueue(label: "loanQueue")
        let workGroup = DispatchGroup()
        let semaphore = DispatchSemaphore(value: 2)
        let sequenceQueue = DispatchQueue(label: "sequenceQueue")
        
        var numberOfCustomer = 0
        
        let date = Date()
        
        while waitingLine.isEmpty == false {
            guard let customer = dequeueWaitingLine() else {
                fatalError("unknown error")
            }
            
            switch customer.task {
            case .deposit:
                sequenceQueue.async {
                    depositQueue.async(group: workGroup) {
                        semaphore.wait()
                        self.bankClerk.handleTask(of: customer)
                        numberOfCustomer += 1
                        semaphore.signal()
                    }
                }
            case .loan:
                loanQueue.async(group: workGroup) {
                    self.bankClerk.handleTask(of: customer)
                    numberOfCustomer += 1
                }
            default:
                return
            }
        }
        workGroup.wait()
        
        let taskTime = abs(date.timeIntervalSinceNow)
        self.close(totalCustomer: numberOfCustomer, taskTime: taskTime)
    }
    
    private func close(totalCustomer: Int, taskTime: Double) {
        let totalTime = String(format: "%.2f", taskTime)
        
        print("업무가 마감되었습니다. 오늘 업무를 처리한 고객은 총 \(totalCustomer)명이며, 총 업무시간은 \(totalTime)초입니다.")
    }
}
