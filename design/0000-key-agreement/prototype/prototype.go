package prototype

type Transport interface {
	Send(message []byte) (err error)
	Receive() (message []byte, err error)
}
