package socket

import (
	"bufio"
	"encoding/binary"
	"errors"
	// "fmt"
	"io"
	"net"
	"prototype"
)

type transport struct {
	address string
	connectionType string
	connection net.Conn
	handler connectionHandler
}

func (t transport) Send(message []byte) (err error) {
	length := len(message)
	if length > 65535 {
		return errors.New("message cannot be longer than 65535 bytes")
	}

	err = binary.Write(t.connection, binary.BigEndian, uint16(length))
	if err != nil {
		return err
	}

	_, err = t.connection.Write(message)
	return err
}

func (t transport) Receive() ([]byte, error) {
	reader := bufio.NewReader(t.connection)

	var length uint16
	err := binary.Read(reader, binary.BigEndian, &length)
	if err != nil {
		return nil, err
	}

	message := make([]byte, length)
	_, err = io.ReadFull(reader, message)
	if err != nil {
		return nil, err
	}

	return message, nil
}

type connectionHandler func(prototype.Transport) error

func SetupClient(connectionType string, address string, handler connectionHandler) error {
	connection, err := net.Dial(connectionType, address)
	if err != nil {
		return err
	}

	err = handler(transport{connectionType: connectionType, address: address, handler: handler, connection: connection})
	if err != nil {
		return err
	}

	return nil
}

func SetupServer(connectionType string, address string, handler connectionHandler) error {
	listener, err := net.Listen(connectionType, address)
	if err != nil {
		return err
	}
	defer listener.Close()

	for {
		// wait to accept a connection
		connection, err := listener.Accept()
		if err != nil {
			return err
		}

		go func(t transport) {
			defer t.connection.Close()

			err := handler(t)
			if err != nil {
				// ??
			}
		}(transport{connectionType: connectionType, address: address, handler: handler, connection: connection})
	}

	return nil
}
