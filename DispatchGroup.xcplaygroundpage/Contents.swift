import Foundation

/*
 Dispatch Group: 여러 스레드로 분배된 작업들이 끝나는 시점을 각각 파악하는 것이 아니라, 하나로 그룹지어서 한번에 파악하고 싶을때
 */
let group1 = DispatchGroup()
DispatchQueue.global().async(group: group1) { // task
}

//이때 task 를 다른 큐로 보내더라도 같은 그룹으로 지정할 수 있습니다.
DispatchQueue.global(qos: .utility).async(group: group1) { // task
}
DispatchQueue.global().async(group: group1) { // task
}


/*
 디스패치 그룹에 비동기 작업이 포함된 task 를 보낼때 발생 가능한 문제
 비동기는 요청만 보내고 끝났다고 notify 날림. error!!
 */

// enter. leave, notify로 비동기 작업 끝나면 받도록 함!
//group.enter()
//   URLSession.shared.dataTask(with: imageUrl) { [weak self] data, urlResponse, error in
//       // defer로 클로저의 마지막에 사용하도록 등록
//       defer { group.leave() }
//}.resume()
