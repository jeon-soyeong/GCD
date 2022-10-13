import Foundation

// race condition 방지
////1. 동시 작업 개수 제한 (concurrentPerform도 가능함)
let semaphore = DispatchSemaphore(value: 2)

for i in 0..<3 {
    DispatchQueue.global().async() {
        semaphore.wait() // semaphore 감소
        print("공유자원 접근 시작 \(i)")
//        sleep(2)
        print("공유자원 접근 종료 \(i)")
        semaphore.signal() // semaphore 증가
    }
}

////2. 두 스레드의 특정 이벤트 완료 상태 동기화
////DispatchSemaphore 초기값 0으로 설정
let semaphore2 = DispatchSemaphore(value: 0)
print("task A가 끝나길 기다림")

// 다른 스레드에서 task A 실행
DispatchQueue.global(qos: .background).async {
     //task A
     print("task A 시작!")
     print("task A 진행중..")
     print("task A 끝!")
     //task A 끝났다고 알려줌
     semaphore2.signal()
}
// task A 끝날때까지는 value 가 0이라, task A 종료까지 block
semaphore2.wait()
print("task A 완료됨")
