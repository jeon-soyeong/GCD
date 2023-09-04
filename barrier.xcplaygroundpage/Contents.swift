import Foundation

// race condition 방지 == thread safe 1) barrier, 2) samaphore, 3) NSLock
// custom Queue
// - 여러개의 queue 동작할 때 전역 1개보다 여러개 custom queue이면 어떤 것에서 돌아가는지 명확하게 알 수 있어서 debuging 하기 편함.

// - barrier 를 지정하는 큐는 직접 만든 concurrent queue 여야만 함. barrier 를 포함한 몇몇 세부적인 설정들은 글로벌 큐에서는 사용할 수 없음.
let concurrentQueue = DispatchQueue(label: "concurrent", attributes: .concurrent)
let serialQueue = DispatchQueue(label: "serial")
// - 비동기 작업들이 실행되다가 flag 가 barrier 로 설정된 작업이 실행되면, 그 작업이 끝날 때 까지 serial queue 처럼 동작 함.
for i in 1...5 {
  concurrentQueue.async {
      print("\(i)")
  }
}

concurrentQueue.async(flags: .barrier) {
  print("barrier!!")
//  sleep(2)
}

for i in 6...10 {
  concurrentQueue.async {
      print("\(i)")
  }
}



// ------------------
// NSLock 도 가능
let queue = DispatchQueue(label: "sellQueue", attributes: .concurrent)
let lock = NSLock()

queue.async {
    lock.lock()
//    sell(value: 1000)
    lock.unlock()
}


//------------
// concurrent.sync 로 읽고 빠르게 concurrent하게 동시에 읽기 위해서
// concurrent.async(flags: barrier) 안정성있게 다른 스레드에서 읽지 말라고
// 성능을 위해 read할땐 sync로, write할땐 async로 접근

// concurrent queue를 사용하기 때문에 조금 더 효율적인 방법이라고 할 수 있음. (읽기 작업에서 여러 스레드 사용 가능)
