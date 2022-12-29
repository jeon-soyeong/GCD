### actor
-> data race 막기위해
(shared mutable state에 대한 접근을 동기화하기 때문에 Concurrent code에서 data race를 피할 수 있음.) <br/>
actor<br/>
내부모듈 - self.로 접근 가능  or let 이라면 가능<br/>
외부모듈 - async await<br/>
<br/>

actor: Actor: Sendable<br/>
Sendable: concurrent code에서 안정하게 사용될 수 있음을 나타냄.<br/>
(A에서 B로 값을 복사하고, A와 B가 서로 간섭하지 않고 해당 값의 복사본을 안전하게 수정할 수 있는 경우 타입은 Sendable이 될 수 있음.)<br/>
