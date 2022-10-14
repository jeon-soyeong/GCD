import Foundation

//DispatchItem: task 캡슐화


DispatchQueue.global().async(qos: .utility) { }
// ==
//우선순위 정할 수 있음
let utilityItem = DispatchWorkItem(qos: .utility) {
  print("Task 시작")
  print("Task 끝")
}

// execute로 실행
DispatchQueue.global().async(execute: utilityItem)
//아니면 perform() 메소드를 통해 현재 스레드에서 sync 하게 동작 가능
utilityItem.perform()

/*DispatchWorkItem의 기능
1) 취소 기능
    - 작업 실행 전
    즉 작업이 아직 큐에 있는 상황. 이때 cancel() 을 호출하면 작업이 제거

    - 작업 실행 중
    실행 중인 작업에 cancel()을 호출하는 경우, 작업이 멈추지는 않고 DispatchWorkItem 의 속성인 inCancelled 가 true 로 설정.*/

utilityItem.cancel()

/*
2) 순서 기능
    notify(queue:execute:) 라는 함수를 통해 작업 A가 끝난 후 작업 B가 특정 queue에서 실행되도록 지정할 수 있음. */
let itemA = DispatchWorkItem { }
let itemB = DispatchWorkItem { }
itemA.notify(queue: DispatchQueue.global(), execute: itemB)
