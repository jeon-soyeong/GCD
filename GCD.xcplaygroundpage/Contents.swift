import UIKit
/*
 Sync는 큐에 작업을 등록한 이후에 해당 작업이 완료될 때까지 더 이상 코드를 진행하지 않고 기다리는 것을 의미
 Async는 큐에 작업을 등록하면 작업의 완료여부와 상관없이 계속 코드를 실행시키는 것을 의미
 concurrent, serial은 이미 큐에 들어온 작업을 어떻게 처리하냐에 대한 설정 (분산/순차적 처리)
 */

// 1) Serial + Sync
var numbers = [0, 1, 2, 3, 4]
let dispatchQueue = DispatchQueue(label: "serial")
(0..<5).forEach({ index in
    dispatchQueue.sync {
        print("Serial + Sync: ", numbers[index])
    }
})


// 2) Serial + Async
(0..<5).forEach({ index in
    dispatchQueue.async {
        print("Serial + Async: ", numbers[index])
    }
})


// 3) Concurrent + Sync
(0..<5).forEach({ index in
    DispatchQueue.global().sync {
        print("Concurrent + Sync: ", numbers[index])
    }
})
// 해당 3가지 case 출력결과 동일, 등록순서, 출력순서 동일하게 찍힘
// --------------------------




// 4) Concurrent + Async
(0..<5).forEach({ index in
    DispatchQueue.global().async {
        print("Concurrent + Async: ", numbers[index])
    }
})


//ref: https://jeonyeohun.tistory.com/279
