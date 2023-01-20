import Foundation

//실행 에러 deadLock
//!! 1) serialQueue.sync !!
let queue = DispatchQueue(label: "test")
queue.sync { // 1
    for index in 1...5 {
        print(index)
    }
    
    queue.sync { // 2
        print("!")
    }
    
    print("#")
}
// 1번 sync에서 2번 sync만나면, block처리 후 기다려서 2번 실행 안됨. deadlock


//!! 2) main.sync !!
var numbers = [0, 1, 2, 3, 4]
(0..<5).forEach({ index in //   메인 스레드에서 “끝날 때까지 기다리고 있을게~” 하고 task 를 메인 큐에 보냄
   DispatchQueue.main.sync { // main이 block 처리해버린 후 큐에 넣은 작업이 완료될 때까지 무한 기다림, sync task 시작도 못하고 deadLock
       print(numbers[index])
   }
})


//!! 3) main.async + main.sync !!
(0..<5).forEach({ index in
    DispatchQueue.main.async {// outer
        DispatchQueue.main.sync {// inner
//            // outer block 이 종료되기 전까지 main queue 에 task 를 삽입하지 않는다.
            print("3: \(numbers[index])")
        }
    } // inner block 이 종료되기 전까지 outer block 은 종료되지 않는다.
})



//----------------------------------------------------------------


// 실행 가능
(0..<5).forEach({ index in
    DispatchQueue.global().async {
        DispatchQueue.main.sync {
            print("2: \(numbers[index])")
        }
    }
})

// TableView나 CollectionView에 셀을 추가하거나 제거하는 작업이 진행 중
//> 네트워크 통신과 같은 다른 비동기 작업으로 인해 DataSource의 데이터가 변경
//> (셀을 추가하거나 제거하는 작업이 아직 안끝난 상태)
//> DataSource의 데이터와 View가 일치하지 않아 에러 발생
//> 방지위해 DispatchQueue.main.sync 사용
//> ex) PHPhotoLibraryChangeObserver

//----------------------------------------------------------------


//실행 에러
// !! 4) 같은 큐에서 같은 큐로 sync를 보냄 !! -> deadlock 가능성 있음
// 왜냐면, async로 할당되었던 스레드는 block 처리되어 내부 sync가 끝나길 바라는 기다리는 상태이고, 동일한 스레드로 sync task가 할당되면 sync는 시작도 못함.
(0..<5).forEach({ index in
    DispatchQueue.global().async { // thread 1
        DispatchQueue.global().sync {
            print("1: \(numbers[index])") // thread 1 - 같은 스레드로 할당되면(다른 스레드로 할당되면(우선순위가 다른 큐라던가) 데드락 X) 밖에서는 안에 작업이 끝나길 기다리고 있어 데드락!
        }
    }
})


//데드락 발생 가능성 있음
DispatchQueue.global().async {
    DispatchQueue.global().sync {
    }
}
//데드락 발생 가능성 없음
DispatchQueue.global(qos: .utility).async {
    DispatchQueue.global().sync {
    }
}



// 하면 안되는 경우!
//main에서
DispatchQueue.global().sync {
    
}
// -> main이 기다려서 UI 멈춘 상태임
