import XCTest

class CustomerQueueTest: XCTestCase {
    var sut: CustomerQueue<Int> = CustomerQueue<Int>()

    override func setUpWithError() throws {
        sut = CustomerQueue<Int>()
    }

    func test_빈_큐에_1을_enqueue하면_1이_남는다() {
        sut.enqueue(value: 1)
        XCTAssertEqual(sut.customers.head?.value, 1)
        XCTAssertNil(sut.customers.head?.next)
    }
    
    func test_빈_큐에_1과2를_enqueue하면_1과2가_남는다() {
        sut.enqueue(value: 1)
        sut.enqueue(value: 2)
        XCTAssertEqual(sut.customers.head?.value, 1)
        XCTAssertEqual(sut.customers.head?.next?.value, 2)
        XCTAssertNil(sut.customers.head?.next?.next)
    }
    
    func test_빈_큐를_dequeue하면_nil이_반환된다() {
        let valueToRemove = sut.dequeue()
        XCTAssertTrue(sut.isEmpty)
        XCTAssertNil(valueToRemove)
    }
    
    func test_1이_있는_큐를_dequeue하면_빈큐가되고_1을_반환된다() {
        sut.enqueue(value: 1)
        let ValueToRemove = sut.dequeue()
        XCTAssertTrue(sut.isEmpty)
        XCTAssertEqual(ValueToRemove, 1)
    }
    
    func test_1과2가_들어간_큐를_clear하면_빈큐가_된다() {
        sut.enqueue(value: 1)
        sut.enqueue(value: 2)
        sut.clear()
        XCTAssertTrue(sut.isEmpty)
    }
    
    func test_1을_넣은_큐에_peek을_하면_1을_반환하고_1은_남아있다() {
        sut.enqueue(value: 1)
        let peekedNumber = sut.peek
        XCTAssertEqual(peekedNumber, 1)
        XCTAssertEqual(sut.customers.head?.value, 1)
    }
}
