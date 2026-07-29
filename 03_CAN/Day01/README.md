CAN통신 이해

Controller Area Network 약자
자동차 내부의 ECU들이 서로 데이터를 주고받기 위한 통신 네트워크이다.
엔진 ECU
        │
        │ RPM = 2500
        ▼
CAN BUS
        ▲
        │
계기판 ECU
계기판은 엔진 ECU에게 RPM 얼마야? 라고 직접 묻지 않는다.
엔진 ECU가 CAN 버스에 RPM = 2500 이라는 메시지를 보내면, 계기판 ECU가 그 메시지를 읽어서 RPM을 표시한다.


자동차 안에는 ECU가 정말 많다.

예를 들면

Engine ECU
Transmission ECU
ABS ECU
EPS ECU
Airbag ECU
Body ECU
Cluster ECU
ADAS ECU

이 ECU들이 모두 CAN을 통해 데이터를 공유한다.

