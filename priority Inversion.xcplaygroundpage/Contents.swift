import Foundation
/*
 동시성 문제
 1) race Condition
 2) deadLock
 3) priority Inversion
     high priority task가 필요한 자원을 low priority task 가 잠그고 있는 경우 (자원을 배타적으로 사용) 작업의 우선 순위가 바뀔 수 있음
     ex) 시리얼 큐에서 high priority task가 low priority task의 뒤에 보내지는 경우
 
    qos: userInteractive  task 3
         userInitiative   task 2
         default          task 1
    각각 이 있을 떄
 
    task 1이 공유자원 A를 점유하고 있다. 이때 task 3도 접근하려고 하면 접근 못함
    따라서 다음 우선순위 task2 실행 -> task 1(자원 들고 있어서) -> task3 순으로 실행 priority Inversion 발생함!!
 
 
    -> 해결방법
    GCD 자체적으로 우선 순위 조정을 통해 문제를 해결합니다. (자원을 점유하고 있는 task의 우선순위를 높여서 처리)
    task 1을 userInteractive으로 변경
    task 1 -> task 3 -> task 2 순으로 조정됨.
 
 
    -> 이렇게 GCD 에서 자체적으로 처리하는 것 외에도, 공유 자원을 접근할 때는 동일한 qos를 사용해야 Priority Inversion의 가능성을 줄일 수 있음!
 */




//DispatchQueue와 task의 QoS 가 다를때의 동작 방식
//https://sujinnaljin.medium.com/ios-dispatchqueue%EC%9D%98-qos%EC%99%80-task%EC%9D%98-qos-%EA%B0%80-%EB%8B%A4%EB%A5%BC%EB%95%8C%EC%9D%98-%EB%8F%99%EC%9E%91-%EB%B0%A9%EC%8B%9D-e67f0c777db8

let queue = DispatchQueue.global(qos: .background)
// queue qos < task qos
// queue가 utility로 상승
queue.async(qos: .utility) {
 print("북쪽에 계신")
 print("아름다운")
 print("메리메리")
 print("리얼")
}

//다시 원래 queue 우선순위였던 background로 돌아옴.
queue.async {
 print("카인드니스 여러분")
 print("안녕하십니까")
}

// queue qos > task qos
// 큐의 qos를 따라가게 됨.

