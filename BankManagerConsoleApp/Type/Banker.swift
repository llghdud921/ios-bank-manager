//
//  Banker.swift
//  BankManagerConsoleApp
//
//  Created by ysp on 2021/04/27.
//

import Foundation

class Banker: Operation {
    let bankerNumber: Int
    let client: Client?
    let notification: NSNotification.Name
    var businessTime: Float = 0
    
    init(bankerNumber: Int, client: Client?, notification: NSNotification.Name) {
        self.bankerNumber = bankerNumber
        self.client = client
        self.notification = notification
    }
    
    override func main() {
        if let client = self.client {
            let clientGrade = convertGradeToString(grade: client.grade)
            print("\(client.waitingNumber)번 \(clientGrade) \(client.taskType)업무 시작")
            setBusinessTime(taskType: client.taskType)
            Thread.sleep(forTimeInterval: Double(businessTime))
            print("\(client.waitingNumber)번 \(clientGrade) \(client.taskType)업무 완료")
        }
        NotificationCenter.default.post(name: notification, object: nil, userInfo: [UserInformationKey.bankerNumber: bankerNumber, UserInformationKey.notificationNumber: notification,UserInformationKey.businessTime: businessTime])
    }
    
    private func setBusinessTime(taskType: String) {
        if taskType == ClientTask.loan {
            requestLoan()
            businessTime =  1.1
        }
        businessTime =  0.7
    }
    
    private func requestLoan() {
        let loanNotification = Notification.Name("Notification")
//        NotificationCenter.default.addObserver(<#T##observer: Any##Any#>, selector: <#T##Selector#>, name: <#T##NSNotification.Name?#>, object: <#T##Any?#>)
//        
//        NotificationCenter.default.removeObserver(<#T##observer: Any##Any#>, name: <#T##NSNotification.Name?#>, object: <#T##Any?#>)
        
    }
    
    private func convertGradeToString(grade: Int) -> String {
        switch grade {
        case 1:
            return ClientGrade.vvip
        case 2:
            return ClientGrade.vip
        default:
            return ClientGrade.general
        }
    }
}
