import Foundation

// concurrentPerform 로 concurrent한 순서 상관없는 작업 갯수 지정 가능

var start = DispatchTime.now()
for i in 0..<20 {
    print(i, terminator: " ")
}
var end = DispatchTime.now()
print("\n")
print("for loop :", start.distance(to: end))


print("\n")
//반복순서가 중요하지 않을 때 속도 개선가능
start = .now()
DispatchQueue.concurrentPerform(iterations: 20) { i in
    print(i, terminator: " ")
}
end = .now()
print("\n")
print("concurrentPerform :", start.distance(to: end)) // for문 보다 훨씬 빠름
